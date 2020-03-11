AnimatorState = Class{}

function AnimatorState:init(name)
  self.name = name
  self.transitions = {}
  self.animation = nil
end

function AnimatorState:update(dt)
  if self.animation then
    self.animation:update(dt)
  end
end

function AnimatorState:AddTransition(state)
  local transition = AnimatorStateTransition(state)
  table.insert(self.transitions, transition)
  return transition
end
