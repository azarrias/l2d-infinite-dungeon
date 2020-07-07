EntityController = Class{__includes = tiny.Script}

function EntityController:init()
  tiny.Script.init(self, 'EntityController')
  self.speed = nil
  self.health = 1
  self.dead = false
end

function EntityController:update(dt)
  --local entityAnimatorController = self.entity.components['AnimatorController']
  if self.health <= 0 then
    self.dead = true
  end
end

-- decrease health for the specified amount
function EntityController:damage(amount)
  self.health = self.health - amount
end