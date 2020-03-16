AnimatorState = Class{}

function AnimatorState:init(name)
  self.name = name
  self.transitions = {}
  self.animation = nil
  self.behaviours = {}
end

function AnimatorState:update(dt)
  if self.animation then
    self.animation:update(dt)
  end
end

function AnimatorState:AddStateMachineBehaviour(behaviourName)
  -- generates anonymous function that returns an instance of the behaviour class
  local f = loadstring("return " .. behaviourName .. "()")
  if f then
    local behaviour = f()
    self.behaviours[behaviourName] = behaviour
  else
    error("Object '"..behaviourName.."' does not exist or is not accessible.")
  end
end

function AnimatorState:AddTransition(state)
  local transition = AnimatorStateTransition(state)
  table.insert(self.transitions, transition)
  return transition
end
