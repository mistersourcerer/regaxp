class Regaxp::Eiruc::InvalidFun < StandardError
  def initialize(operation_name)
    super "Function body given to #{operation_name} is not #call(able)."
  end
end
