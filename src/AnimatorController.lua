AnimatorController = Class{__includes = Component}

function AnimatorController:init(name)
  Component.init(self)
  self.componentType = 'AnimatorController'
  self.name = name
  self.stateMachine = AnimatorStateMachine()
  self.parameters = {}
  self.animations = {}
  self.changingState = false
end

function AnimatorController:update(dt)
  self.stateMachine:update(dt)
  
  -- check the state machine's transitions for triggered conditions
  -- if all the conditions of a transition are met, perform the transition
  for k, transition in pairs(self.stateMachine.anyStateTransitions) do
    if (#self.stateMachine.currentState.animation.frames <= 1 or
      self.stateMachine.currentState.animation.timer > transition.exitTime * self.stateMachine.currentState.animation.duration)
      and self:AreAllConditionsMet(transition) then
        self:ChangeState(transition)
        self.changingState = true
        break
    end
  end
  
  for k, transition in pairs(self.stateMachine.currentState.transitions) do
    if (#self.stateMachine.currentState.animation.frames <= 1 or 
      self.stateMachine.currentState.animation.timer > transition.exitTime * self.stateMachine.currentState.animation.duration)
      and self:AreAllConditionsMet(transition) then
        self:ChangeState(transition)
        self.changingState = true
        break
    end
  end
  
  -- execute update behaviour for the current state, except for its first and last frame
  if self.changingState then
    self.changingState = false
  else
    for k, behaviour in pairs(self.stateMachine.currentState.behaviours) do
      behaviour:OnStateUpdate(dt, self)
    end
  end
  
  -- update sprite component of the parent entity (if it exists)
  if self.entity.components['Sprite'] then
    local animation = self.stateMachine.currentState.animation
    if animation then
      self.entity.components['Sprite'].texture = animation.frames[animation.currentFrame].texture
      self.entity.components['Sprite'].quad = animation.frames[animation.currentFrame].quad
    end
  end
end

--[[
     Creates a new state with the animation in it
  ]]
function AnimatorController:AddAnimation(name, frames, interval)
  local animation = Animation(name, frames, interval)
  self.animations[name] = animation
  local state = self.stateMachine:AddState(name)
  state.animation = animation
  return state
end
  
function AnimatorController:AddParameter(name, _type)
  local parameter = AnimatorControllerParameter(name, _type)
  self.parameters[name] = parameter
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
    else error("AnimatorConditionOperatorType '"..tostring(condition.operator).."' does not exist.")
    end
  end
  
  return true
end

function AnimatorController:ChangeState(transition)
  -- automatically reset animation and triggers and that have been consumed by this transaction
  self.stateMachine.currentState.animation:Reset()
  self:ResetTransitionTriggers(transition)
  
  -- execute all exit behaviours for the source state
  for k, behaviour in pairs(self.stateMachine.currentState.behaviours) do
    behaviour:OnStateExit(dt, self)
  end

  self.stateMachine.currentState = transition.destinationState
  
  -- execute all enter behaviours for the target state
  for k, behaviour in pairs(self.stateMachine.currentState.behaviours) do
    behaviour:OnStateEnter(dt, self)
  end
  --print("Change to " .. transition.destinationState.name)
end

function AnimatorController:ResetTransitionTriggers(transition)
  for k, condition in pairs(transition.conditions) do
    if self.parameters[condition.parameterName].type == 'Trigger' then
      self:ResetTrigger(condition.parameterName)
    end
  end
end

function AnimatorController:SetValue(parameterName, value)
  if self.parameters[parameterName].type == 'Bool' or
    self.parameters[parameterName].type == 'Numeric' then
      self.parameters[parameterName].value = value
  elseif self.parameters[parameterName].type == 'Trigger' then
    error('Parameter '..parameterName..' is a Trigger and cannot be given a value.')
  else
    error('Parameter '..parameterName..' is of type '..self.parameters[parameterName].type..' which is not supported.')
  end
end

function AnimatorController:SetTrigger(triggerName)
  if self.parameters[triggerName].type == 'Trigger' then
    self.parameters[triggerName].value = true
  else
    error('Parameter '..triggerName..' is not a Trigger.')
  end
end

function AnimatorController:ResetTrigger(triggerName)
  if self.parameters[triggerName].type == 'Trigger' then
    self.parameters[triggerName].value = false
  else
    error('Parameter '..triggerName..' is not a Trigger.')
  end
end
