BehaviourMovingDown = Class{__includes = StateMachineBehaviour}

function BehaviourMovingDown:init()
  self.name = 'BehaviourMovingDown'
  StateMachineBehaviour.init(self)
end

function BehaviourMovingDown:OnStateEnter(dt, animatorController)
end

function BehaviourMovingDown:OnStateExit(dt, animatorController)
end

function BehaviourMovingDown:OnStateUpdate(dt, animatorController)
  local entity = animatorController.parent
  local playerController = entity.components['Script']['PlayerController']
  local bounds = MAP_RENDER_OFFSET.y + MAP_SIZE.y * TILE_SIZE - TILE_SIZE
  
  entity.position.y = entity.position.y + playerController.speed * dt
  if entity.position.y + 11 >= bounds then
    entity.position.y = bounds - 11
  end
end