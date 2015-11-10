# compairs the current date with the last successful form submission
def new_month?
  File.open('logfile.log', 'r') do |f|
    # only look at the last line in the file
    f.readlines[-1..-1].each do |line|
      # the last line of the log file holds the success log if
      # the form was successfuly submitted
      if /\[\d+-(\d+)/.match(line) && /success$/.match(line)
        last_successful_month = /\[\d+-(\d+)/.match(line)[1]
        # if still in the same month
        return false if last_successful_month.to_i == Time.now.to_a[4]
      end
    end
  end
  # only reaches here if the last line in the log file does not
  # indicate successful submission of the form for this month
  # therefore it is either a new month or submission has failed so far
  true
end
