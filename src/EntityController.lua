EntityController = Class{__includes = tiny.Script}

function EntityController:init()
  tiny.Script.init(self, 'EntityController')
  self.speed = nil
end

function EntityController:update(dt)
  local entityAnimatorController = self.entity.components['AnimatorController']
end