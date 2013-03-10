module TypeChecker
  def handle_types(*args)
    @@checker = TypeChecker.new(*args)
  end

  private
  class TypeChecker
    def initialize(*args)
      @args = args
      @@handlers = []
    end

    def match?(*types)
      @args.zip(types).all? { |arg, type| arg.is_a?(type) }
    end

    def register_handler(*types, proc)

    end
  end

  class TypeHandler
    def initialize

    end

  end
  def register_handler(*types, callable)

  end
end

