require 'minitest/autorun'

require_relative 'argumentative'

describe Argumentative do
  include Argumentative
  it 'raises error when type not handled' do
    def flexible_args_method(*args)
      argumentative(args) do
        when_type(Array) { raise "Shouldn't evaluate non-matching block" }
        when_type(Numeric) { raise "Shouldn't evaluate non-matching block" }
      end
    end

    assert_raises(ArgumentError) { flexible_args_method("some string") }
  end

  it 'runs clause for type when first matches' do
    def flexible_args_method(*args)
      argumentative(args) do
        when_type(Numeric) { raise "Shouldn't evaluate non-matching block" }
        when_type(String) { 'Handled String' }
      end
    end

    assert_equal 'Handled String', flexible_args_method("some string")
  end

  it 'runs clause for type when last matches' do
    def flexible_args_method(*args)
      argumentative(args) do
        when_type(String) { 'Handled String' }
        when_type(Numeric) { raise "Shouldn't evaluate non-matching block" }
      end
    end

    assert_equal 'Handled String', flexible_args_method("some string")
  end

  it 'passes original args through to the executed block' do
    def flexible_args_method(*args)
      argumentative(args) do
        when_type(String) do |string_arg|
          assert_equal "some string", string_arg
          'Handled String'
        end

        when_type(Numeric) { raise "Shouldn't evaluate non-matching block" }
      end
    end

    assert_equal 'Handled String', flexible_args_method("some string")
  end
end
