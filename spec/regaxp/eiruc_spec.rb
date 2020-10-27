RSpec.describe Regaxp::Eiruc do
  subject(:eiruc) { described_class.new }

  describe "#fun, binds token to a function" do
    it "accepts a block" do
      eiruc.fun("+") { |oper1, oper2| oper1 + oper2 }

      expect(eiruc.evaluate([1, 2, :+])).to eq 3
    end

    it "accepts a #call[able]" do
      callable = ->(left, right) { left - right }
      eiruc.fun("-", callable)

      expect(eiruc.evaluate([1, 2, :-])).to eq -1
    end
  end

  describe "#evaluate" do
    it "raises if a non-existent function is called" do
      expect { eiruc.evaluate([2, 1, :-]) }
        .to raise_error Regaxp::Eiruc::UndefinedFun
    end

    it "evaluates a stack and return the result" do
      eiruc.fun("-") { |oper1, oper2| oper1 - oper2 }

      expect(eiruc.evaluate([2, 1, :-])).to eq 1
    end
  end
end
