BehaviourMovingLeft = Class{__includes = StateMachineBehaviour}

function BehaviourMovingLeft:init()
  self.name = 'BehaviourMovingLeft'
  StateMachineBehaviour.init(self)
end

function BehaviourMovingLeft:OnStateEnter(dt, animatorController)
end

function BehaviourMovingLeft:OnStateExit(dt, animatorController)
end

function BehaviourMovingLeft:OnStateUpdate(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  local bounds = MAP_RENDER_OFFSET.x + TILE_SIZE
    
  entity.position.x = entity.position.x - playerController.speed * dt
  if entity.position.x - 8 <= bounds then
    entity.position.x = bounds + 8
  end
end