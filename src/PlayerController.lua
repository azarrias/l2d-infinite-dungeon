PlayerController = Class{__includes = tiny.Script}

function PlayerController:init()
  tiny.Script.init(self, 'PlayerController')
  self.speed = 80
  self.health = 6
  self.invulnerable = false
  self.invulnerableDuration = 0
  self.invulnerableTimer = 0
  self.flashTimer = 0
  self.dead = false
  self.bodyCollider = nil
  self.attackCollider = nil
end

function PlayerController:update(dt)
  -- handle the player's invulnerability status
  if self.invulnerable then
    self.flashTimer = self.flashTimer + dt
    self.invulnerableTimer = self.invulnerableTimer + dt
    
    if self.invulnerableTimer > self.invulnerableDuration then
      self.invulnerable = false
      self.invulnerableTimer = 0
      self.invulnerableDuration = 0
      self.flashTimer = 0
    end
  end
  
  -- make the player's sprite flash when it it invulnerable after being hit
  sprite = self.entity.components['Sprite']
  if self.invulnerable and self.flashTimer > 0.1 then
    self.flashTimer = 0
  elseif self.invulnerable and self.flashTimer > 0.06 then
    if sprite then
      sprite.color = { 255 / 255, 255 / 255, 255 / 255, 64 / 255 }
    else
      error("Sprite not found!")
    end
  else
    if sprite then
      sprite.color = { 1, 1, 1, 1 }
    end
  end
  
  -- update the animator controller's parameters with the given input
  local playerAnimatorController = self.entity.components['AnimatorController']
  
  local isDownDown = love.keyboard.isDown('down')
  local isDownUp = love.keyboard.isDown('up')
  local isDownLeft = love.keyboard.isDown('left')
  local isDownRight = love.keyboard.isDown('right')
  
  playerAnimatorController:SetValue('MoveDown', isDownDown)
  playerAnimatorController:SetValue('MoveUp', isDownUp)
  playerAnimatorController:SetValue('MoveLeft', isDownLeft)
  playerAnimatorController:SetValue('MoveRight', isDownRight)
  
  if love.keyboard.keysPressed['space'] then
    playerAnimatorController:SetTrigger('Attack')
  end
end

-- decrease health for the specified amount
function PlayerController:damage(amount)
  self.health = self.health - amount
  self:makeInvulnerable(1.5)
end

-- render the player invulnerable for a given number of seconds
function PlayerController:makeInvulnerable(duration)
  self.invulnerable = true
  self.invulnerableDuration = duration
end