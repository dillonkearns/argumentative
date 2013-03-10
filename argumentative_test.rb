require 'minitest/autorun'

require_relative 'argumentative'

describe Argumentative do
  include Argumentative
  it 'raises error when type not handled' do
    def complicated_method(*args)
      argumentative(args) do
        when_type(Array) do
          raise "Shouldn't evaluate non-matching block"
        end

        when_type(Numeric) do
          raise "Shouldn't evaluate non-matching block"
        end
      end
    end

    assert_raises(ArgumentError) { complicated_method("some string") }
  end

  it 'runs clause for type when first matches' do
    def complicated_method(*args)
      argumentative(args) do
        when_type(Numeric) do
          raise "Shouldn't evaluate non-matching block"
        end

        when_type(String) do
          'Handled String'
        end
      end
    end

    assert_equal 'Handled String', complicated_method("some string")
  end

  it 'runs clause for type when last matches' do
    def complicated_method(*args)
      argumentative(args) do
        when_type(String) do
          'Handled String'
        end

        when_type(Numeric) do
          raise "Shouldn't evaluate non-matching block"
        end
      end
    end

    assert_equal 'Handled String', complicated_method("some string")
  end

  it 'passes original args through to the executed block' do
    def complicated_method(*args)
      argumentative(args) do
        when_type(String) do |string_arg|
          assert_equal "some string", string_arg
          'Handled String'
        end

        when_type(Numeric) do
          raise "Shouldn't evaluate non-matching block"
        end
      end
    end

    assert_equal 'Handled String', complicated_method("some string")
  end
end
