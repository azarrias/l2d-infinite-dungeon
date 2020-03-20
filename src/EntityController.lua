EntityController = Class{__includes = Script}

function EntityController:init()
  Script.init(self, 'EntityController')
  self.speed = 70
end

function EntityController:update(dt)
  local entityAnimatorController = self.parent.components['AnimatorController']
end