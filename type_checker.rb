module TypeChecker
  def handle_types(args)
    @@checker = TypeChecker.new(*args)
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

  private
  class TypeChecker
    attr_reader :args

    def initialize(*args)
      @args = args
      @@handlers = []
      @found_match = false
    end

    def check_match(types)
      if match?(types)
        @return_value = yield
        @found_match = true
      end
    end

    def found_match?
      @found_match
    end

    def return_value
      @return_value
    end

    private
    def match?(types)
      @args.zip(types).all? { |arg, type| arg.is_a?(type) }
    end
  end
end

