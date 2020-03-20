BehaviourEntityMovingLeft = Class{__includes = StateMachineBehaviour}

function BehaviourEntityMovingLeft:init()
  self.name = 'BehaviourEntityMovingLeft'
  StateMachineBehaviour.init(self)
end

function BehaviourEntityMovingLeft:OnStateUpdate(dt, animatorController)
  local entity = animatorController.parent
  local entityController = entity.components['Script']['EntityController']
  local bounds = MAP_RENDER_OFFSET.x + TILE_SIZE
  
  entity.position.x = entity.position.x - math.floor(entityController.speed * dt)
  if entity.position.x - 8 <= bounds then
    entity.position.x = bounds + 8
  end
end
