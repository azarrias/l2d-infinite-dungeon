BehaviourEntityMovingUp = Class{__includes = StateMachineBehaviour}

function BehaviourEntityMovingUp:init()
  self.name = 'BehaviourEntityMovingUp'
  StateMachineBehaviour.init(self)
end

function BehaviourEntityMovingUp:OnStateUpdate(dt, animatorController)
  local entity = animatorController.parent
  local entityController = entity.components['Script']['EntityController']
  local bounds = MAP_RENDER_OFFSET.y + TILE_SIZE
  
  entity.position.y = entity.position.y - math.floor(entityController.speed * dt)
  if entity.position.y - 8 <= bounds then
    entity.position.y = bounds + 8
  end
end