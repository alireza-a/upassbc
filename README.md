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

## Register a Cron job
run the following to run automator.rb every day of every month at 3:30pm
```sh
30 15 * * * ruby /path_to_directory/upassbc/automator.rb
```

## change permission for the folder
```sh
chmod u+rwx -R /path_to_direcory
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
