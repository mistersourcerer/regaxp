RSpec.describe Regaxp::Eiruc do
  subject(:eiruc) { described_class.new }

  describe "#fun, binds token to a function" do
    it "accepts a block" do
      eiruc.fun("plus") { |oper1, oper2| oper1 + oper2 }

      expect(eiruc.evaluate([1, 2, :plus])).to eq 3
    end

    it "accepts a #call[able]" do
      callable = ->(left, right) { left - right }
      eiruc.fun("sub", callable)

      expect(eiruc.evaluate([1, 2, :sub])).to eq -1
    end

    it "rejects non-callable bodies" do
      expect {
        eiruc.fun("nope", "nope")
      }.to raise_error Regaxp::Eiruc::InvalidFun
    end
  end

  describe "#evaluate" do
    it "evaluates a stack and return the result" do
      eiruc.fun("sub") { |oper1, oper2| oper1 - oper2 }

      expect(eiruc.evaluate([2, 1, :sub])).to eq 1
    end

    context "multiple functions and precedence" do
      before do
        eiruc.fun("*") { |left, right| left * right }
        eiruc.fun("-") { |left, right| left - right }
        eiruc.fun("^") { |left, right| left ** right }
        eiruc.fun("/") { |left, right| left / right }
        eiruc.fun("+") { |left, right| left + right }
      end

      it "executes the expression correctly" do
        expression = [3.0, 4.0, 2.0, :*, 1.0, 5.0, :-, 2.0, 3.0, :^, :^, :/, :+]

        expect(eiruc.evaluate(expression)).to eq 3.0001220703125
      end
    end

    context "non-registered functions" do
      it "fallback to the a method on the `left` operand" do
        expect(eiruc.evaluate([2, 1, :+])).to eq 3
      end

      it "raises if a non-existent function is called" do
        expect { eiruc.evaluate([2, 1, :omg]) }
          .to raise_error Regaxp::Eiruc::UndefinedFun
      end
    end
  end
end
