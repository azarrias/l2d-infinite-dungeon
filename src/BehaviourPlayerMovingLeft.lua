BehaviourPlayerMovingLeft = Class{__includes = tiny.StateMachineBehaviour}

function BehaviourPlayerMovingLeft:init()
  self.name = 'BehaviourPlayerMovingLeft'
  tiny.StateMachineBehaviour.init(self)
end

function BehaviourPlayerMovingLeft:OnStateEnter(dt, animatorController)
end

function BehaviourPlayerMovingLeft:OnStateExit(dt, animatorController)
end

function BehaviourPlayerMovingLeft:OnStateUpdate(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  local bounds = MAP_RENDER_OFFSET.x + TILE_SIZE
    
  entity.position.x = entity.position.x - playerController.speed * dt
  if entity.position.x - 8 <= bounds then
    entity.position.x = bounds + 8
  end
end