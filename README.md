# Argumentative

[![Build Status](https://travis-ci.org/dillonkearns/argumentative.png?branch=master)](https://travis-ci.org/dillonkearns/argumentative)
[![Coverage Status](https://coveralls.io/repos/dillonkearns/argumentative/badge.png?branch=master)](https://coveralls.io/r/dillonkearns/argumentative)
[![Gem Version](https://fury-badge.herokuapp.com/rb/argumentative.png)](http://badge.fury.io/rb/argumentative)
[![Dependency Status](https://gemnasium.com/dillonkearns/argumentative.png)](https://gemnasium.com/dillonkearns/argumentative)
[![Code Climate](https://codeclimate.com/github/dillonkearns/argumentative.png)](https://codeclimate.com/github/dillonkearns/argumentative)


Flexible argument processing in a readable, declarative style!

## Installation

Just add `gem 'argumentative'` to your `Gemfile` and `require 'argumentative'`.

## Usage

```ruby
require 'argumentative'

def flexible_args_method(*args)
  Argumentative.handle(args) do |a|
    a.type(String) do |string|
      "I was called with a string (#{string})"
    end

    a.type(Numeric) do |number|
      "I was called with a number (#{number})"
    end

    a.type(String.*, Hash) do |*strings, options|
      "I got strings #{strings.inspect} and options #{options.inspect}"
    end
  end
end

flexible_args_method('string')                # => "I was called with a string (string)"
flexible_args_method(123.5)                   # => "I was called with a number (123.5)"
flexible_args_method('one', 'two', three: 3)  # => 'I got strings ["one", "two"] and options {:three=>3}'
```


```ruby
require 'argumentative'

def flexible_args_method(*args)
  Argumentative::Processor.new(args).
    type(String) { |string| "I was called with a string (#{string})" }.
    type(Numeric) { |number| "I was called with a number (#{number})" }.
    type(String.*, Hash) { |*strings, options| "I got strings #{strings.inspect} and options #{options.inspect}" }.
    process
end

flexible_args_method('string')                # => "I was called with a string (string)"
flexible_args_method(123.5)                   # => "I was called with a number (123.5)"
flexible_args_method('one', 'two', three: 3)  # => 'I got strings ["one", "two"] and options {:three=>3}'
```
