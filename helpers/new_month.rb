def new_month?(logfile)
  File.open(logfile, 'r') do |f|
    f.readlines[-1..-1].each do |line|
      last_successful_month = line[/\[\d+-(\d+)/, 1]
      has_last_successful_month = !!last_successful_month
      is_same_month = last_successful_month.to_i == Time.now.to_a[4] if has_last_successful_month ||= false
      success_line = !!line[/success$/]
      return (has_last_successful_month && !is_same_month) || !success_line 
    end
  end
end
