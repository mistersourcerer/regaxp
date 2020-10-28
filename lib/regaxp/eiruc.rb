# Executes Reverse Polish Notation expressions.
#
# An expression is an iterable {Enumerable#reduce (`#reduce`)}
# containing operands and _Symbols_.
#
# _Symbols_ are used to identify functions
# that can be registered on an {Regaxp::Eiruc}
# instance via the {Regaxp::Eiruc#fun `#fun`} method:
#
#   evaluator = Regaxp::Eiruc.new
#   evaluator.fun("plus") { |left, right| left + right }
#   evaluator.evaluate([1, 2, :plus])
#   # => 3
#
# If a function is not registered the evaluator
# fallsback to a method of the the left argument object.
# If the method doesn't exist it will raise {UndefinedFun an error}.
class Regaxp::Eiruc
  def initialize
    @functions = {}
  end

  # Evaluates an expression given by an {Enumerable#reduce `#reduce`}.
  # The expression is expected to be in RPNotation.
  # _Symbols_ in the collection will be handled as function names.
  #
  # Functions are looked up in the following order:
  # - first the ones registered via {Eiruc#fun `#fun`}
  # - then checking if the "_left_" object {Object#respond_to? `#respond_to?`} _Symbol_
  #
  # @param expression [#reduce] collection representing an RPN expression.
  # @return [Object] result of evaluating an expression.
  # @raise [UndefinedFun] if a _Symbol_ in the expression is not a function
  #   or a method in the "left" argument of the expression.
  def evaluate(expression)
    expression.reduce([]) { |stack, token|
      result = token.is_a?(Symbol) ? execute(token, stack) : token
      stack.push result
    }.first
  end

  # Associates a {#call `#call(able)`} _Object_
  # to be executed when the `name` is found in an RPN expression
  # when {#evaluate `#evaluate(ing)`} it.
  #
  # @param name [#to_sym] to identify a function on the RPN expression
  # @param fun_object [#call] to be called when evaluating the expression
  # @yield [left, right] if a block is given, it will be used as the function
  # @raise [InvalidFun] if the `fun_object` is not a `#call(able)` thing
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
