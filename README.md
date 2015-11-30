# UpassBC Automator
The following is what I think happens when you try to log into your UpassBC profile.

1. Select Simon Fraser University

2. Redirect to SFU login page

3. SFU automatically authorizes UpassBC app

4. Redirect to UpassBC callback page with access token

After this point the UpassBC page can access your information by providing the token to SFU CAS.

This script follows this path to reload your Compass card every month.

# Getting Started
## Requirements
For this automator to work you need to have the following installed:

1. Ruby

2. RubyGems (Comes with Ruby by default)

## Install the dependencies
Run the following command in terminal or CMD to install all the dependencies (If you do not have bundler installed run: gem install bundler):
```sh
cd ~/path_to_directory/upassbc
bundle install
```
*Windows users see Windows section below

## Save your username and password
Enter your SFU Computing ID and Password instead of the place holders in the auth.json file.
```json
{
	"username": "davida",
	"password": "1234abcd"
}
```

## Register the script to run periodically
### On linux
Run the following to schedule a Cron job
```sh
crontab -e
```
When the editor opens copy the following line and save it. This would schedule the script to run at 3:30pm everyday
```txt
30 15 * * * ruby /path_to_directory/upassbc/automator.rb
```
### On OS X

Edit the runAutomator.sh file -> Replace <DirName> with the full path to the upassbc folder

Edit the upassbc_launchagent.plist file -> Replace {DirName} inside ProgramArguments key with the full path to the runAutomator.sh file

Make sure the full path is accessible by the root.
Do NOT use the '~/Desktop/...' but use the full path '/Users/{username}/Desktop/...'


runAutomator.sh must be owned by root:
```sh
sudo chown root ./runAutomator.sh
sudo chmod 755 ./runAutomator.sh
```

Move the launch agent to ~/Library/LaunchAgents to run as a User Agent:
```sh
cp upassbc_launchagent.plist ~/Library/LaunchAgents/
```
The launch agent must be owned by root

As mentioned on [Stack Exchange](http://superuser.com/questions/793872/can-t-launch-daemon-with-launchctl-in-yosemite) by [diimdeep](http://superuser.com/users/23591/diimdeep)
```sh
sudo chmod 600 ~/Library/LaunchAgents/upassbc_launchagent.plist
sudo chown root ~/Library/LaunchAgents/upassbc_launchagent.plist
```
Register the launch file:
```sh
sudo launchctl load -w ~/Library/LaunchAgents/upassbc_launchagent.plist
```

The script will be run once as soon as the Launch Agent is loaded. If you don't see a logfile in the directory, something has gone wrong. If that happens try logging in as root and manually running runAutomator.sh file

### On Windows
IMPORTANT - There are issues with using Mechanize to open secure SSL URLs. To bypass this, SSL verification has been set to none. This shouldn't be a problem as the URLs are hardcoded in the script but it's important to relay this information.

If you recieve error while installing bundles such as " gem requires installed build tools", follow the instructions below as explained by [Massimo Fazzolari](http://stackoverflow.com/users/216685/massimo-fazzolari) on [Stack Exchange](http://stackoverflow.com/questions/8100891/the-json-native-gem-requires-installed-build-tools)
```sh
Download DevKit file from rubyinstaller.org for your particular ruby version
Extract DevKit to path C:\Ruby<Ver>\DevKit
Run cd C:\Ruby<Ver>\DevKit
Run ruby dk.rb init
Run ruby dk.rb review
Run ruby dk.rb install
```

Nokogiri doesn't support Ruby 2.2 and up on Windows yet. To make it work, download [Nokogiri 1.6.6.2 (x64)](https://github.com/paulgrant999/ruby-2.2.2-nokogiri-1.6.6.2-x86-x64-mingw32.gem/raw/master/nokogiri-1.6.6.2-x64-mingw32.gem) or [Nokogiri 1.6.6.2 (x86)](https://github.com/paulgrant999/ruby-2.2.2-nokogiri-1.6.6.2-x86-x64-mingw32.gem/raw/master/nokogiri-1.6.6.2-x86-mingw32.gem) and do the following 
```sh
gem uninstall nokogiri
gem install --local <Nokogiri Download Directory>
```

Windows scheduler can be used to schedule the running of the script. To set up scheduler, do the following steps:

1. Google how to create a new task using task scheduler.

2. When setting an action for the task, set the following:

```txt
	Program/script -> runAutomatorWindows.bat
	Start in (optional) -> Directory of the script
```

# Notes
The automator.rb script only makes a request on your behalf to upassbc website to register for all the possible months available.
To increase the probability of successful update, this setup configures your system to execute the script multiple times.

The following docs were used in developing this automator

1. [mechanize guide](http://docs.seattlerb.org/mechanize/GUIDE_rdoc.html)

2. [mechanize examples](http://docs.seattlerb.org/mechanize/EXAMPLES_rdoc.html)

3. [logger](http://ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html)

4. [openURI](http://ruby-doc.org/stdlib-2.1.2/libdoc/open-uri/rdoc/OpenURI.html)

5. [file](http://ruby-doc.org/core-2.2.0/File.html)

6. [json](http://ruby-doc.org/stdlib-2.0.0/libdoc/json/rdoc/JSON.html)
