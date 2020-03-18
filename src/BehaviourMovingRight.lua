BehaviourMovingRight = Class{__includes = StateMachineBehaviour}

function BehaviourMovingRight:init()
  self.name = 'BehaviourMovingRight'
  StateMachineBehaviour.init(self)
end

function BehaviourMovingRight:OnStateUpdate(dt, animatorController)
  local entity = animatorController.parent
  local playerController = entity.components['Script']['PlayerController']
  local bounds = MAP_RENDER_OFFSET.x + MAP_SIZE.x * TILE_SIZE - TILE_SIZE
  
  entity.position.x = entity.position.x + math.floor(playerController.speed * dt)
  if entity.position.x + 8 >= bounds then
    entity.position.x = bounds - 8
  end
end