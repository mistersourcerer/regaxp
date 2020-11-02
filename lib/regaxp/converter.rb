# Conversions for regular expression syntax.
#
# For adding an explicit {#expl_concat concatenation operator}
# to a standard regular expression:
#
#   converter = Regaxp::Converter.new
#   converter.expl_concat "4(20)"
#   # => ["4", ".", "(", "2", ".", "0", ")"]
class Regaxp::Converter
  # Adds an explicit concatenation operator
  # to a standard ("human readable") regular expression.
  #
  # The standard separator is the char ".",
  # but it is possible to coustomize it passing an `operator`.
  #
  #   converter = Regaxp::Converter.new
  #   converter.expl_concat "4(20)", operator: :dot
  #   # => ["4", :dot, "(", "2", :dot, "0", ")"]
  #
  # @param regex [#each] the "human readable" regexp expression
  # @param operator: [String, Symbol] the concatenation _symbol_
  # @return [#each] tokens for the already concatenated regexp
  def expl_concat(regex, operator: ".")
    regex.each_with_index.reduce([]) { |output, (token, index)|
      output << token
      should_concat?(regex, token, index) ? output << operator : output
    }
  end

  private

  def should_concat?(regex, token, index)
    peek = regex[index + 1]
    is_operand = binary_ops.include?(token) || operators.include?(peek)
    is_grouping = token == "(" || peek == ")"
    eof = regex.length == index + 1

    !is_operand && !is_grouping && !eof
  end

  def operators
    @operators ||= %w[| ? + *]
  end

  def binary_ops
    @binary_ops ||= %w[|]
  end
end
