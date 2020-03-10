AnimatorStateMachine = Class{}

function AnimatorStateMachine:init()
  self.defaultState = nil
  self.currentState = nil
  self.states = {}
  self.anyStateTransitions = {}
  self.entryTransition = nil
end

function AnimatorStateMachine:update(dt)
  self.currentState:update(dt)
end

function AnimatorStateMachine:AddState(name)
  local state = AnimatorState(name)
  -- the first state that is created for a state machine
  -- becomes the default state, and an entry transition
  -- must be created for it as well
  if next(self.states) == nil then
    self.defaultState = state
    self.currentState = state
    self:AddEntryTransition(state)
  end
  self.states[state.name] = state
  
  return state
end

function AnimatorStateMachine:AddAnyStateTransition(state)
  local transition = AnimatorStateTransition(state)
  table.insert(self.anyStateTransitions, transition)
  
  return transition
end

function AnimatorStateMachine:AddEntryTransition(state)
  local transition = AnimatorStateTransition(state)
  self.entryTransition = transition
  
  return transition
end
