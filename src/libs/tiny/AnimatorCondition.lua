local AnimatorCondition = Class{}

AnimatorConditionOperatorType = {
  GreaterThan = "GreaterThan",
  LessThan = "LessThan",
  Equals = "Equals",
  NotEqual = "NotEqual"
}

function AnimatorCondition:init(parameterName, operator, value)
  self.parameterName = parameterName
  self.operator = operator
  self.value = value
end

return AnimatorCondition