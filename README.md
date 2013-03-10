# Argumentative

 For flexible argument processing in a readable, declarative style!

```ruby
include Argumentative

def method_with_flexible_args(*args)
  argumentative(args) do
    when_type(String) do |string|
      puts "I was called with a string (#{string})"
    end

    when_type(Numeric) do |number|
      puts "I was called with a number (#{number})"
    end

    when_type(String.*, Hash) do |*strings, options|
      puts "I got strings #{strings.inspect} and options #{options.inspect}"
    end
  end
end

method_with_flexible_args('string')   # I was called with a string (string)
method_with_flexible_args(123.5)      # I was called with a number (123.5)
method_with_flexible_args('one', 'two', 'three', :four => 4)
# I got strings ["one", "two", "three"] and options {:four=>4}
```
