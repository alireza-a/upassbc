def new_month?(logfile)
  File.open(logfile, 'r') do |f|
    f.readlines[-1..-1].each do |line|
      last_successful_month = line[/\[\d+-(\d+)/, 1]
      success_line = line[/success$/]
      is_same_month = last_successful_month.to_i == Time.now.to_a[4]
      return last_successful_month && success_line && !is_same_month
    end
  end
end
