module Argumentative
  def self.process(args)
    processor = Processor.new(args)
    yield processor
    processor.process
  end

  class Processor
    attr_reader :args

    def initialize(args)
      raise ArgumentError, "" unless args.is_a?(Array)
      @args = args
      @found_match = false
    end

    def found_match?
      @found_match
    end

    def process
      raise ArgumentError, "No matches found for #{args.inspect}" unless found_match?
      @return_value
    end

    def type(*types)
      check_match(types) do
        yield(*args)
      end
      self
    end

    private
    def check_match(types)
      unless found_match?
        if match?(types)
          @return_value = yield
          @found_match = true
        end
      end
    end

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
        types.count == args.count && args.zip(types).all? { |arg, type| arg.is_a?(type) }
      end
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
end

class Class
  def *
    Argumentative::Matchers::Star.new(self)
  end

  def optional
    Argumentative::Matchers::Optional.new(self)
  end
end
