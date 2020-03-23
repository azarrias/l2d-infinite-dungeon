PlayerController = Class{__includes = Script}

function PlayerController:init()
  Script.init(self, 'PlayerController')
  self.speed = 80
end

function PlayerController:update(dt)
  local playerAnimatorController = self.parent.components['AnimatorController']
  
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