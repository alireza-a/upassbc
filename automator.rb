require 'rubygems'
require 'logger'
require 'json'
require 'open-uri'
require 'mechanize'
require 'rbconfig'

require_relative './helpers/connection.rb'
require_relative './helpers/new_month.rb'

logfile = 'logfile.log'

# only continue execution if form has not been submitted for this month
exit if File.exist?(logfile) && !new_month?(logfile)
# create a logger to direct the data to logfile
logger = Logger.new(logfile)
# read the username and password from auth.json file
auth = File.read('auth.json')
auth_hash = JSON.parse(auth)

# check for internet connection
# quit if unable to establish connection after trying hard
# try accessing google ten times over the next three hours
unless can_be_reached? 10, 'http://www.google.com/', 1800
  # exit after ten trials
  logger.warn 'failed to establish a network connection'
  exit
end

# make a request for all the eligible months
# to improve the readibility and logging, the following code is flattened
agent = Mechanize.new

# There are issues with opening SSL URLs with Mechanize on Windows
# Workaround is to not verify URLs thereby bypassing certificates
# The following lines check if the host is windows and set the http mode to verify none
if RbConfig::CONFIG["host_os"] =~ /mingw|mswin/
  agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
end

# fetch the upassbc website
login_page = agent.get('https://upassbc.translink.ca')
unless %r{https://upassbc.translink.ca}.match(login_page.uri.to_s)
  logger.warn 'cannot reach the upassbc website'
  exit
end

# select sfu from select school form
sfu_login_page = login_page.form_with(action: '/') do |select_school_form|
  select_school_form.PsiId = 'sfu' # select sfu from the drop down menu
end.submit
# makes sure the submission redirects to cas for login
unless %r{https://cas.sfu.ca/cas/login}.match(sfu_login_page.uri.to_s)
  logger.warn 'something about the upass bc select school form has changed'
  exit
end

# login using your sfu computing id and password
hidden = sfu_login_page.form_with(name: 'login') do |login_form|
  login_form.username = auth_hash['username']
  login_form.password = auth_hash['password']
end.submit
# makes sure the submission is successful and doesn't redirects back to cas page
unless %r{https://idp.sfu.ca/idp/profile/SAML2}.match(hidden.uri.to_s)
  logger.warn 'login failed! please check your username and password'
  exit
end

# follows the redirects
hidden = hidden.forms.first.submit
# this redirects you to 'my upass bc' page
my_upassbc_page = hidden.forms.first.submit
# make sure you are logged into upassbc website
unless %r{https://upassbc.translink.ca}.match(my_upassbc_page.uri.to_s)
  logger.warn 'something has changed in sfu authentication process'
  exit
end

# requests the next month upass
next_month = 0
eligibility_request_action = '/fs/Eligibility/Request'
is_eligible = lambda { |form| return form.checkbox_with(name: /^Eligibility\[.*\].Selected$/) }
response = my_upassbc_page.form_with(action: eligibility_request_action) do |request_form|
  if is_eligible.call(request_form)
    next_month = 1
    request_form.checkbox_with(name: /^Eligibility\[.*\].Selected$/).check
  end
end.submit
# log the result
if next_month > 0
  response.form_with(action: eligibility_request_action) do |request_form|
    if is_eligible.call(request_form)
      logger.warn 'request failed'
    else
      logger.info 'success'
    end
  end
else
  logger.info 'not available yet'
end
