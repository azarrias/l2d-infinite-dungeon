BehaviourMovingUp = Class{__includes = StateMachineBehaviour}

function BehaviourMovingUp:init()
  self.name = 'BehaviourMovingUp'
  StateMachineBehaviour.init(self)
end

function BehaviourMovingUp:OnStateUpdate(dt, animatorController)
  local entity = animatorController.parent
  local playerController = entity.components['Script']['PlayerController']
  entity.position.y = entity.position.y - math.floor(playerController.speed * dt)
end