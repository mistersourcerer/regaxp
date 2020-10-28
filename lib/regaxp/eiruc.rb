# Parses and execute Reverse Polish notation expressions.

class Regaxp::Eiruc
  def initialize
    @functions = {}
  end

  def evaluate(expression)
    expression.reduce([]) { |stack, token|
      result = token.is_a?(Symbol) ? execute(token, stack) : token
      stack.push result
    }.first
  end

  def fun(name, fun_object = nil, &fun_body)
    body = fun_body || fun_object
    raise InvalidFun.new(name) if !body.respond_to?(:call)

    functions[name.to_sym] = body
  end

  private

  attr_accessor :functions

  def execute(operation, stack)
    right = stack.pop
    left = stack.pop

    if functions[operation].nil?
      raise UndefinedFun.new(operation) if !left.respond_to?(operation)
      left.public_send operation, right
    else
      functions[operation].call left, right
    end
  end
end
