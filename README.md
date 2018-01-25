# Tikarb

A simple Apache Tika binding for ruby using rjb.

## Dependencies

* ruby 2.3+
* tika 1.16+

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tikarb'
```

And then execute:

    $ bundle

## Usage

Setup path to tika-app jar file:

```ruby
Tikarb.path = '/path/to/your/tika-app.jar'
```

Use as follows:

```ruby
# extract text and metadata from file
Tikarb.parse('/path/to/your/file')

# detect media type
Tikarb.detect('/path/to/your/file')

# call with command-line options
Tikarb.cli('--xml', '/path/to/your/file')
```

You can use `StringIO` as an argument:

```ruby
Tikarb.parse(StringIO.new(your_data))
```

## Pros and Cons

This gem calls Tika libraries via Java Native Interface using rjb.

Pros:
* It will be faster than command-line interface in case Tika is executed repeatedly.

Cons:
* It requires some memory to load JavaVM in the process.
* It will affect JDK and Tika internal specification change.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kanety/tikarb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
