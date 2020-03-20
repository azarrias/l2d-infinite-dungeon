BehaviourEntityMovingLeft = Class{__includes = StateMachineBehaviour}

function BehaviourEntityMovingLeft:init()
  self.name = 'BehaviourEntityMovingLeft'
  StateMachineBehaviour.init(self)
  self.bumped = false
  self.bounds = MAP_RENDER_OFFSET.x + TILE_SIZE
  
  -- used for AI control
  self.movementDuration = 0
  self.movementTimer = 0
end

function BehaviourEntityMovingLeft:OnStateEnter(dt, animatorController)
  self.movementDuration = math.random() + math.random(4)
  self.movementTimer = 0
  self.bumped = false
end

function BehaviourEntityMovingLeft:OnStateExit(dt, animatorController)
end

function BehaviourEntityMovingLeft:OnStateUpdate(dt, animatorController)
  local entity = animatorController.parent
  local entityController = entity.components['Script']['EntityController']
  
  -- if entity runs into a wall or its movement finished, it can go idle or move again
  if self.bumped or self.movementTimer > self.movementDuration then
    animatorController:SetValue('MoveLeft', false)
    if math.random(3) ~= 1 then
      local parameters = { 'MoveUp', 'MoveDown', 'MoveRight' }
      animatorController:SetValue(parameters[math.random(#parameters)], true)
    end
  end
  
  self.movementTimer = self.movementTimer + dt
  
  entity.position.x = entity.position.x - math.floor(entityController.speed * dt)
  if entity.position.x - 8 <= self.bounds then
    entity.position.x = self.bounds + 8
    self.bumped = true
  end
end
