BehaviourMovingLeft = Class{__includes = StateMachineBehaviour}

function BehaviourMovingLeft:init()
  self.name = 'BehaviourMovingLeft'
  StateMachineBehaviour.init(self)
end

function BehaviourMovingLeft:OnStateUpdate(dt, animatorController)
  local entity = animatorController.parent
  local playerController = entity.components['Script']['PlayerController']
  entity.position.x = entity.position.x - math.floor(playerController.speed * dt)
end