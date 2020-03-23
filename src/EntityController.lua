EntityController = Class{__includes = Script}

function EntityController:init()
  Script.init(self, 'EntityController')
  self.speed = nil
end

function EntityController:update(dt)
  local entityAnimatorController = self.parent.components['AnimatorController']
end