BehaviourPlayerMovingRight = Class{__includes = tiny.StateMachineBehaviour}

function BehaviourPlayerMovingRight:init()
  self.name = 'BehaviourPlayerMovingRight'
  tiny.StateMachineBehaviour.init(self)
end

function BehaviourPlayerMovingRight:OnStateEnter(dt, animatorController)
end

function BehaviourPlayerMovingRight:OnStateExit(dt, animatorController)
end

function BehaviourPlayerMovingRight:OnStateUpdate(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  local bounds = MAP_RENDER_OFFSET.x + MAP_SIZE.x * TILE_SIZE - TILE_SIZE
  
  entity.position.x = entity.position.x + playerController.speed * dt
  if entity.position.x + 8 >= bounds then
    entity.position.x = bounds - 8
  end
end