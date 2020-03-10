AnimatorController = Class{__includes = Component}

function AnimatorController:init(name)
  self.componentType = 'AnimatorController'
  self.name = name
  self.stateMachine = AnimatorStateMachine()
  self.parameters = {}
end

function AnimatorController:AddParameter(name, _type)
  local parameter = AnimatorControllerParameter(name, _type)
  self.parameters[name] = parameter
end

function AnimatorController:update(dt)
  -- check the state machine's transitions for triggered conditions
  -- if all the conditions of a transition are met, perform the transition
  for k, transition in pairs(self.stateMachine.anyStateTransitions) do
    if self:AreAllConditionsMet(transition) then
      self.stateMachine.currentState = transition.destinationState
      print("Change to " .. transition.destinationState.name)
    end
  end
  
  for k, transition in pairs(self.stateMachine.currentState.transitions) do
    if self:AreAllConditionsMet(transition) then
      self.stateMachine.currentState = transition.destinationState
      print("Change to " .. transition.destinationState.name)
    end
  end
  
end

--[[
     Returns true if all the transition conditions are met
  ]]
function AnimatorController:AreAllConditionsMet(transition)
  for i, condition in pairs(transition.conditions) do
    if condition.operator == AnimatorConditionOperatorType.Equals then
      if self.parameters[condition.parameterName].value == nil or condition.value == nil or
        self.parameters[condition.parameterName].value ~= condition.value then
          return false
      end
    elseif condition.operator == AnimatorConditionOperatorType.NotEqual then
      if self.parameters[condition.parameterName].value == nil or condition.value == nil or
        self.parameters[condition.parameterName].value ~= condition.value then
          return false
      end
    elseif condition.operator == AnimatorConditionOperatorType.GreaterThan then
      if self.parameters[condition.parameterName].value == nil or condition.value == nil or
        self.parameters[condition.parameterName].value <= condition.value then
          return false
      end
    elseif condition.operator == AnimatorConditionOperatorType.LessThan then
      if self.parameters[condition.parameterName].value == nil or condition.value == nil or
        self.parameters[condition.parameterName].value >= condition.value then
          return false
      end
    else error("AnimatorConditionOperatorType '"..tostring(condition.operator).."' does not exist.", 2)
    end
  end
  
  return true
end

function AnimatorController:SetValue(parameterName, value)
  self.parameters[parameterName].value = value
end
