module Argumentative
  def argumentative(args)
    @@checker = Argumentative.new(*args)
    yield
    raise ArgumentError.new("No matches found for #{@@checker.args.inspect}") unless @@checker.found_match?
    return_value = @@checker.return_value
    @@checker = nil
    return_value
  end

  def when_type(*types)
    @@checker.check_match(types) do
      yield(*@@checker.args)
    end
  end

  module Matchers
    class Base
      def match?(types)
        raise 'Called abstract method match?'
      end
    end

    class Star < Base
      def initialize(klass)
        @klass = klass
      end

      def match?(types)
        true
      end
    end

    class Optional < Base
      def initialize(klass)
        @klass = klass
      end

      def match?(types)
        true
      end
    end
  end

  private
  class Argumentative
    attr_reader :args

    def initialize(*args)
      @args = args
      @@handlers = []
      @found_match = false
    end

    def check_match(types)
      unless found_match?
        if match?(types)
          @return_value = yield
          @found_match = true
        end
      end
    end

    def found_match?
      @found_match
    end

    def return_value
      @return_value
    end

    private
    def contain_matchers?(types)
      types.any? { |type| type.is_a?(Matchers::Base) }
    end

    def fuzzy_match?(types)
      true
    end

    def match?(types)
      if contain_matchers?(types)
        fuzzy_match?(types)
      else
        types.count == @args.count && @args.zip(types).all? { |arg, type| arg.is_a?(type) }
      end
    end
  end
end

class Class
  def *
    Argumentative::Matchers::Star.new(self)
  end

  def optional
    Argumentative::Matchers::Optional.new(self)
  end
end
