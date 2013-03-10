require_relative 'test_helper'

require_relative '../lib/argumentative'
require 'minitest/autorun'


describe Argumentative do
  include Mocha::Integration::MiniTest
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

  it 'matches Class.*' do
    def flexible_args_method(*args)
      argumentative(args) do
        when_type(String, Hash) { raise "Shouldn't evaluate non-matching block" }

        when_type(String.*) do |*strings|
          "Matched String.* with #{strings.inspect}"
        end
      end
    end

    assert_equal 'Matched String.* with ["one", "two", "three"]', flexible_args_method('one', 'two', 'three')
  end
end
