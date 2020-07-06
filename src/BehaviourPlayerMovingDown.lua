BehaviourPlayerMovingDown = Class{__includes = StateMachineBehaviour}

function BehaviourPlayerMovingDown:init()
  self.name = 'BehaviourPlayerMovingDown'
  StateMachineBehaviour.init(self)
end

function BehaviourPlayerMovingDown:OnStateEnter(dt, animatorController)
end

function BehaviourPlayerMovingDown:OnStateExit(dt, animatorController)
end

function BehaviourPlayerMovingDown:OnStateUpdate(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  local bounds = MAP_RENDER_OFFSET.y + MAP_SIZE.y * TILE_SIZE - TILE_SIZE
  
  entity.position.y = entity.position.y + playerController.speed * dt
  if entity.position.y + 11 >= bounds then
    entity.position.y = bounds - 11
  end
end