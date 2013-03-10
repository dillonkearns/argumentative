require 'minitest/autorun'

require_relative 'type_checker'

describe TypeChecker do
  include TypeChecker
  it 'raises error when type not handled' do
    def complicated_method(*args)
      handle_types(args) do
        when_type(Array) do

        end

        when_type(Numeric) do

        end
      end
    end

    assert_raises(Exception) { complicated_method("some string") }
  end

  it 'runs clause for type' do
    def complicated_method(*args)
      handle_types(args) do
        when_type(Numeric) do
          'Handled Numeric'
        end

        when_type(String) do
          'Handled String'
        end
      end
    end

    assert_equal 'Handled string', complicated_method("some string")
  end
end
