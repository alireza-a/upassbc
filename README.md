# Getting Started

## Requirements
For this automator to work you need to have the following installed:

1. Ruby

2. RubyGems (Comes with Ruby by default)

## Install the dependencies
Run the following command in terminal to install all the dependencies (If you do not have bundler installed run: gem install bundler):
```sh
bundle install
```

## Save your username and password
enter your sfu computing id and password instead of the place holders in the auth.json file
```json
{
	"username": "davida",
	"password": "1234abcd"
}
```

## Register the script to run periodically
### On linux
run the following to run automator.rb every day of every month at 3:30pm
```sh
30 15 * * * ruby /path_to_directory/upassbc/automator.rb
```
### On OS X
move the launch agent to ~/Library/LaunchAgents to run as a user agent
```sh
cp upassbc_launchagent.plist ~/Library/LaunchAgents/
```
The launch agent must be owned by root

As mentioned on [Stack Exchange](http://superuser.com/questions/793872/can-t-launch-daemon-with-launchctl-in-yosemite) by [diimdeep](http://superuser.com/users/23591/diimdeep)
```sh
sudo chmod 600 ~/Library/LaunchAgents/upassbc_launchagent.plist
sudo chown root ~/Library/LaunchAgents/upassbc_launchagent.plist
```
register the launch file
```sh
sudo launchctl load -w ~/Library/LaunchAgents/upassbc_launchagent.plist
```

### On windows


## change permission for the folder
```sh
chmod 700 -R /path_to_direcory
```

# Notes
The automator.rb script only makes a request on your behalf to upassbc website to register for all the possible months availible.
To make sure this request succeeds, register the Cron job to run multiple time during a month.
This ensures the automator will succeed with high probability.

The following docs were used in developing this automator

1. [mechanize guide](http://docs.seattlerb.org/mechanize/GUIDE_rdoc.html)

2. [mechanize examples](http://docs.seattlerb.org/mechanize/EXAMPLES_rdoc.html)

3. [logger](http://ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html)

4. [openURI](http://ruby-doc.org/stdlib-2.1.2/libdoc/open-uri/rdoc/OpenURI.html)

5. [file](http://ruby-doc.org/core-2.2.0/File.html)

6. [json](http://ruby-doc.org/stdlib-2.0.0/libdoc/json/rdoc/JSON.html)
