BehaviourEntityMovingDown = Class{__includes = StateMachineBehaviour}

function BehaviourEntityMovingDown:init()
  self.name = 'BehaviourEntityMovingDown'
  StateMachineBehaviour.init(self)
end

function BehaviourEntityMovingDown:OnStateUpdate(dt, animatorController)
  local entity = animatorController.parent
  local entityController = entity.components['Script']['EntityController']
  local bounds = MAP_RENDER_OFFSET.y + MAP_SIZE.y * TILE_SIZE - TILE_SIZE
  
  entity.position.y = entity.position.y + math.floor(entityController.speed * dt)
  if entity.position.y + 8 >= bounds then
    entity.position.y = bounds - 8
  end
end
