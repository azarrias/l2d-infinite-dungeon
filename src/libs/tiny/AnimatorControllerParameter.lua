local AnimatorControllerParameter = Class{}

AnimatorControllerParameterType = {
  Bool = "Bool",
  Numeric = "Numeric",
  Trigger = "Trigger"
}

function AnimatorControllerParameter:init(name, _type, value)
  self.name = name
  self.type = _type
  -- unlike Bool parameters, a Trigger parameter is automatically 
  -- given a 'true' value when activated, which will be restored to 
  -- false once it has been consumed by a transition
  if _type == 'Trigger' then
    self.value = false
  else
    self.value = value
  end
end

return AnimatorControllerParameter