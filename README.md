# Argumentative

[![Build Status](https://travis-ci.org/dillonkearns/argumentative.png)](https://travis-ci.org/dillonkearns/argumentative)
[![Coverage Status](https://coveralls.io/repos/dillonkearns/argumentative/badge.png?branch=master)](https://coveralls.io/r/dillonkearns/argumentative)
[![Gem Version](https://fury-badge.herokuapp.com/rb/argumentative.png)](http://badge.fury.io/rb/argumentative)
[![Dependency Status](https://gemnasium.com/dillonkearns/argumentative.png)](https://gemnasium.com/dillonkearns/argumentative)
[![Code Climate](https://codeclimate.com/github/dillonkearns/argumentative.png)](https://codeclimate.com/github/dillonkearns/argumentative)


 For flexible argument processing in a readable, declarative style!

```ruby
include Argumentative

def method_with_flexible_args(*args)
  argumentative(args) do
    when_type(String) do |string|
      "I was called with a string (#{string})"
    end

    when_type(Numeric) do |number|
      "I was called with a number (#{number})"
    end

    when_type(String.*, Hash) do |*strings, options|
      "I got strings #{strings.inspect} and options #{options.inspect}"
    end
  end
end

method_with_flexible_args('string')   # => "I was called with a string (string)"
method_with_flexible_args(123.5)      # => "I was called with a number (123.5)"
method_with_flexible_args('one', 'two', 'three', :four => 4)
# => 'I got strings ["one", "two", "three"] and options {:four=>4}'
```
