# Envee

Provides casting wrappers around fetch for environment variables.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'envee'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install envee

## Usage

``` ruby
ENV['NUM'] = '1'
ENV.int('NUM') #=> 1

ENV['NAME'] = 'bob'
ENV.str('NAME') #=> 'bob'

ENV['TIME'] = '1970-01-01 00:00:00 UTC'
ENV.time('TIME') #=> 1970-01-01 00:00:00 UTC

ENV['ITIME'] = 0
ENV.int_time('ITIME') #=> 1970-01-01 00:00:00 UTC

ENV['START'] = 'false' # or no, off, 0. Everything else is true.
ENV.bool(START) #=> falsey

# Specify defaults like you do with fetch
ENV.int('MISSING', '1') #=> 1, also casts default
ENV.time('TIME2'){Time.at(0)} #=> 1970-01-01 00:00:00 UTC

ENV['MISSING'] = 'CHANGEME'
ENV.validate!(missing_value: 'CHANGEME') #=> Envee::MissingValuesError,
                                         #   The following environment variables are not set, but should be:
                                         #   MISSING
```

## Contributing

1. Fork it ( https://github.com/secondrotation/envee/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
