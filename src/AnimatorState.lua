AnimatorState = Class{}

function AnimatorState:init(name)
  self.name = name
  self.transitions = {}
end

function AnimatorState:AddTransition(state)
  local transition = AnimatorStateTransition(state)
  table.insert(self.transitions, transition)
  return transition
end