# Parses and execute Reverse Polish notation expressions.

class Regaxp::Eiruc
  class UndefinedFun < StandardError
    def initialize(operation_name)
      super "Function #{operation_name} is not defined."
    end
  end

  def initialize
    @functions = {}
  end

  def evaluate(expression)
    expression.reduce([]) { |stack, token| process_token token, stack }[0]
  end

  def fun(name, fun_object = nil, &fun_body)
    # TODO: validates fun_object is a callable
    # TODO: validates arity?
    functions[name.to_sym] = fun_body || fun_object
  end

  private

  attr_accessor :functions

  def fun?(operation)
    !functions[operation].nil?
  end

  def execute(operation, stack)
    right = stack.pop
    left = stack.pop

    functions[operation].call left, right
  end

  def process_token(token, stack)
    result =
      if token.is_a?(Symbol)
        raise UndefinedFun.new(token) if !fun?(token)
        execute(token, stack)
      else
        token
      end

    stack.push result
  end
end
