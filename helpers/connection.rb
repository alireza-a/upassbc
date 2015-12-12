# checks if it can stablish a connection to the provided url
# surpasses any error raised in the process and returns false
def accessable?(url)
  open(url)
rescue StandardError
  false
end

# checks the internet connection
def can_be_reached?(number_of_trials, url, for_the_next_seconds)
  number_of_trials.times do |i|
    # try accessing the url and ingnore any error raised in the process
    break if accessable? url
    # if the url cannot be reached in every trial then connection has failed
    return false if i == number_of_trials - 1
    # sleep for the specified number of seconds before the next trial
    sleep(for_the_next_seconds)
  end
  # is only reached if the connection is stablished in one of the trials
  true
end
