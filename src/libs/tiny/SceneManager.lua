local SceneManager = Class{}

function SceneManager:init(scenes)
  self.empty = {
    render = function() end,
    update = function() end,
    enter = function() end,
    exit = function() end
  }
  self.scenes = scenes or {} -- [name] -> [function that returns states]
  self.current = self.empty
end

function SceneManager:change(sceneName, enterParams)
  assert(self.scenes[sceneName]) -- state must exist in the State Machine!
  self.current:exit()
  self.current = self.scenes[sceneName]()
  self.current:enter(enterParams)
end

function SceneManager:update(dt)
  self.current:update(dt)
end

function SceneManager:render()
  self.current:render()
end

return SceneManager