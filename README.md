# Csjparser

[![Build Status](https://travis-ci.org/estebanz01/csjparser.svg?branch=master)](https://travis-ci.org/estebanz01/csjparser)
[![Coverage Status](https://coveralls.io/repos/github/estebanz01/csjparser/badge.svg?branch=master)](https://coveralls.io/github/estebanz01/csjparser?branch=master)
[![Gem Version](https://badge.fury.io/rb/csjparser.svg)](https://badge.fury.io/rb/csjparser)

CSJ Parser is a gem that allows you parse a [Comma Separated JSON](http://www.kirit.com/Comma%20Separated%20JSON) file into a Hash ruby object.
The idea of this project is to have fun and learn a lot while coding in ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'csjparser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csjparser

## Usage

Simply require the csjparser and use the Parser or ValueChecker class as follows:

```ruby
require 'csjparser'

filepath = '/dir/of/file.csj'

# This will give you an object like:
# [{ key: value1 }, ..., { key: valueN }]
array_of_hashes = Csjparser::Parse.new(filepath).parse_document

# You can also use the ValueChecker class to see how an object respond to a value.
value_a = 'weirdString'
value_b = '34'
value_c = '2015-06-31'

Csjparser::ValueChecker.new(value_a).integer? # false
Csjparser::ValueChecker.new(value_b).integer? # true
Csjparser::ValueChecker.new(value_c).integer? # false

Csjparser::ValueChecker.new(value_a).date? # false
Csjparser::ValueChecker.new(value_b).date? # false
Csjparser::ValueChecker.new(value_c).date? true

# The methods availables in ValueChecker class are:
# bool?
# nil?
# date?
# array?
# integer?
# float?
```

## Known issues (TODO list)

* It does not support nested arrays.
* It does not parse valid hexadecimal digits.
* The valid ["[1, 2, 3, 4]"] is not supported.
* It does not create a valid CSJ file from a ruby object.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/estebanz01/csjparser. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

