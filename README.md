# Argumentative

 For flexible argument processing in a readable, declarative style!

```ruby
def method_with_flexible_args(*args)
  argumentative(args) do
    when_type(String) do |string|
      puts "I was called with a string: #{string}"
    end

    when_type(Numeric) do |number|
      puts "I was called with a number: #{number}"
    end
  end
end
```
