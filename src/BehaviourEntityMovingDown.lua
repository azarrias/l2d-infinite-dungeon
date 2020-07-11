BehaviourEntityMovingDown = Class{__includes = tiny.StateMachineBehaviour}

function BehaviourEntityMovingDown:init()
  self.name = 'BehaviourEntityMovingDown'
  tiny.StateMachineBehaviour.init(self)
  self.bounds = MAP_RENDER_OFFSET.y + MAP_SIZE.y * TILE_SIZE - TILE_SIZE
  
  -- used for AI control
  self.movementDuration = 0
  self.movementTimer = 0
end

function BehaviourEntityMovingDown:OnStateEnter(dt, animatorController)
  self.movementDuration = math.random() + math.random(4)
  self.movementTimer = 0
  self.bumped = false
end

function BehaviourEntityMovingDown:OnStateExit(dt, animatorController)
end

function BehaviourEntityMovingDown:OnStateUpdate(dt, animatorController)
  local entity = animatorController.entity
  local entityController = entity.components['Script']['EntityController']
  
  -- if entity runs into a wall or its movement finished, it can go idle or move again
  if self.bumped or self.movementTimer > self.movementDuration then
    animatorController:SetValue('MoveDown', false)
    if math.random(3) ~= 1 then
      local parameters = { 'MoveUp', 'MoveLeft', 'MoveRight' }
      animatorController:SetValue(parameters[math.random(#parameters)], true)
    end
  end
  
  self.movementTimer = self.movementTimer + dt
  
  entity.position.y = entity.position.y + entityController.speed * dt
  if entity.position.y + 8 >= self.bounds then
    entity.position.y = self.bounds - 8
    self.bumped = true
  end
end
