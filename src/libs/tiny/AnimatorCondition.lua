local AnimatorCondition = Class{}

function AnimatorCondition:init(parameterName, operator, value)
  self.parameterName = parameterName
  self.operator = operator
  self.value = value
end

return AnimatorCondition