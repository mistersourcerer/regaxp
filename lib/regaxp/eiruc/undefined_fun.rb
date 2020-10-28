class Regaxp::Eiruc::UndefinedFun < StandardError
  def initialize(operation_name)
    super "Function #{operation_name} is not defined."
  end
end
