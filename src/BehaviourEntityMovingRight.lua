BehaviourEntityMovingRight = Class{__includes = StateMachineBehaviour}

function BehaviourEntityMovingRight:init()
  self.name = 'BehaviourEntityMovingRight'
  StateMachineBehaviour.init(self)
end

function BehaviourEntityMovingRight:OnStateUpdate(dt, animatorController)
  local entity = animatorController.parent
  local entityController = entity.components['Script']['EntityController']
  local bounds = MAP_RENDER_OFFSET.x + MAP_SIZE.x * TILE_SIZE - TILE_SIZE
  
  entity.position.x = entity.position.x + math.floor(entityController.speed * dt)
  if entity.position.x + 8 >= bounds then
    entity.position.x = bounds - 8
  end
end
