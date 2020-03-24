BehaviourMovingUp = Class{__includes = StateMachineBehaviour}

function BehaviourMovingUp:init()
  self.name = 'BehaviourMovingUp'
  StateMachineBehaviour.init(self)
end

function BehaviourMovingUp:OnStateEnter(dt, animatorController)
end

function BehaviourMovingUp:OnStateExit(dt, animatorController)
end

function BehaviourMovingUp:OnStateUpdate(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  local bounds = MAP_RENDER_OFFSET.y + TILE_SIZE
  
  entity.position.y = entity.position.y - playerController.speed * dt
  if entity.position.y - 11 <= bounds then
    entity.position.y = bounds + 11
  end
end