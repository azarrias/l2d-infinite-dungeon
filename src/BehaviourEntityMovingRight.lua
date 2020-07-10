BehaviourEntityMovingRight = Class{__includes = tiny.StateMachineBehaviour}

function BehaviourEntityMovingRight:init()
  self.name = 'BehaviourEntityMovingRight'
  tiny.StateMachineBehaviour.init(self)
  self.bumped = false
  self.bounds = MAP_RENDER_OFFSET.x + MAP_SIZE.x * TILE_SIZE - TILE_SIZE
  
  -- used for AI control
  self.movementDuration = 0
  self.movementTimer = 0
end

function BehaviourEntityMovingRight:OnStateEnter(dt, animatorController)
  self.movementDuration = math.random() + math.random(4)
  self.movementTimer = 0
  self.bumped = false
end

function BehaviourEntityMovingRight:OnStateExit(dt, animatorController)
end

function BehaviourEntityMovingRight:OnStateUpdate(dt, animatorController)
  local entity = animatorController.entity
  local entityController = entity.components['Script']['EntityController']
  
  -- if entity runs into a wall or its movement finished, it can go idle or move again
  if self.bumped or self.movementTimer > self.movementDuration then
    animatorController:SetValue('MoveRight', false)
    if math.random(3) ~= 1 then
      local parameters = { 'MoveUp', 'MoveLeft', 'MoveDown' }
      animatorController:SetValue(parameters[math.random(#parameters)], true)
    end
  end
  
  self.movementTimer = self.movementTimer + dt
  
  entity.position.x = entity.position.x + entityController.speed * dt
  if entity.position.x + 6 >= self.bounds then
    entity.position.x = self.bounds - 6
    self.bumped = true
  end
end
