RSpec.describe Regaxp::Converter do
  subject(:converter) { described_class.new }

  describe "#expl_concat" do
    it "adds an explicit concatenation char/symbol to the expression" do
      regex = "o(mg)|l*ol+bbq"

      expect(converter.expl_concat(regex.split(""))).to eq [
        "o", ".",
        "(", "m", ".", "g", ")", "|",
        "l", "*", ".",
        "o", ".", "l", "+", ".",
        "b", ".", "b", ".", "q"
      ]
    end

    it "accepts customization of the concatenation operator" do
      expect(converter.expl_concat("omg".split(""), operator: :dot)).to eq [
        "o", :dot, "m", :dot, "g"
      ]
    end
  end
end
