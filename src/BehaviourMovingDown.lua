BehaviourMovingDown = Class{__includes = StateMachineBehaviour}

function BehaviourMovingDown:init()
  self.name = 'BehaviourMovingDown'
  StateMachineBehaviour.init(self)
end

function BehaviourMovingDown:OnStateUpdate(dt, animatorController)
  local entity = animatorController.parent
  local playerController = entity.components['Script']['PlayerController']
  entity.position.y = entity.position.y + math.floor(playerController.speed * dt)
end