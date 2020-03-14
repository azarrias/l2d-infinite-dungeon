SceneManager = Class{}

function SceneManager:init(states)
  self.empty = {
    render = function() end,
    update = function() end,
    enter = function() end,
    exit = function() end
  }
  self.states = states or {} -- [name] -> [function that returns states]
  self.current = self.empty
end

function SceneManager:change(stateName, enterParams)
  assert(self.states[stateName]) -- state must exist in the State Machine!
  self.current:exit()
  self.current = self.states[stateName]()
  self.current:enter(enterParams)
end

function SceneManager:update(dt)
  self.current:update(dt)
end

function SceneManager:render()
  self.current:render()
end