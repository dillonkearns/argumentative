require_relative 'test_helper'

require_relative '../lib/argumentative'
require 'minitest/autorun'


describe Argumentative do
  include Mocha::Integration::MiniTest
  it 'raises error when type not handled' do
    def flexible_args_method(*args)
      Argumentative.handle(args) do |a|
        a.type(Array) { raise "Shouldn't evaluate non-matching block" }
        a.type(Numeric) { raise "Shouldn't evaluate non-matching block" }
      end
    end

    assert_raises(ArgumentError) { flexible_args_method("some string") }
  end

  it 'runs clause for type when first matches' do
    def flexible_args_method(*args)
      Argumentative.handle(args) do |a|
        a.type(Numeric) { raise "Shouldn't evaluate non-matching block" }
        a.type(String) { 'Handled String' }
      end
    end

    assert_equal 'Handled String', flexible_args_method("some string")
  end

  it 'runs clause for type when last matches' do
    def flexible_args_method(*args)
      Argumentative.handle(args) do |a|
        a.type(String) { 'Handled String' }
        a.type(Numeric) { raise "Shouldn't evaluate non-matching block" }
      end
    end

    assert_equal 'Handled String', flexible_args_method("some string")
  end

  it 'runs only the first block it matches' do
    def flexible_args_method(*args)
      Argumentative.handle(args) do |a|
        a.type(String) { |string| "Handled String with #{string}" }
        a.type(String.*) { |*strings| "Matched String.* with #{strings}" }
      end
    end

    assert_equal 'Handled String with some string', flexible_args_method("some string")
    assert_equal 'Matched String.* with ["several", "different", "strings"]', flexible_args_method("several", "different", "strings")
  end

  it 'passes original args through to the executed block' do
    def flexible_args_method(*args)
      Argumentative.handle(args) do |a|
        a.type(String) do |string_arg|
          assert_equal "some string", string_arg
          'Handled String'
        end

        a.type(Numeric) { raise "Shouldn't evaluate non-matching block" }
      end
    end

    assert_equal 'Handled String', flexible_args_method("some string")
  end

  describe 'called with constructor' do
    it 'returns correct values' do
      def flexible_args_method(*args)
        Argumentative::Processor.new(args).
            type(String) { |s| "I got string #{s}" }.
            type(Numeric) { |n| "I got number #{n}" }.
            process
      end

      assert_equal 'I got string some string', flexible_args_method("some string")
      assert_equal 'I got number 1086', flexible_args_method(1086)
    end


    it 'gives error when args is not an array' do
        assert_raises(ArgumentError) { Argumentative::Processor.new('non-array argument') }
    end
  end

  describe 'matchers' do
    it 'matches Class.*' do
      def flexible_args_method(*args)
        Argumentative.handle(args) do |a|
          a.type(String, Hash) { raise "Shouldn't evaluate non-matching block" }

          a.type(String.*) do |*strings|
            "Matched String.* with #{strings.inspect}"
          end
        end
      end

      assert_equal 'Matched String.* with ["one", "two", "three"]', flexible_args_method('one', 'two', 'three')
    end

    it 'supplies nil for optional when not passed in' do
      def flexible_args_method(*args)
        Argumentative.handle(args) do |a|
          a.type(String, Hash.optional) do |string, optional_hash|
            [string, optional_hash]
          end
        end
      end

      assert_equal ['a string', { :some_option => 'some value' }], flexible_args_method('a string', :some_option => 'some value')
      assert_equal ['a string', nil], flexible_args_method('a string')
    end
  end
end
