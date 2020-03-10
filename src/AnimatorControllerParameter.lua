AnimatorControllerParameter = Class{}

AnimatorControllerParameterType = {
  Bool = "Bool",
  Numeric = "Numeric",
  Trigger = "Trigger"
}

function AnimatorControllerParameter:init(name, _type, value)
  self.name = name
  self.type = _type
  self.value = value
end