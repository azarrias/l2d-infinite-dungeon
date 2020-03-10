AnimatorStateTransition = Class{}

function AnimatorStateTransition:init(state)
  self.destinationState = state
  self.conditions = {}
end

function AnimatorStateTransition:AddCondition(parameter, operator, value)
  local condition = AnimatorCondition(parameter, operator, value)
  table.insert(self.conditions, condition)
end