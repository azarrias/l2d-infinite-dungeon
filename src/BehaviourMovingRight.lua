BehaviourMovingRight = Class{__includes = StateMachineBehaviour}

function BehaviourMovingRight:init()
  self.name = 'BehaviourMovingRight'
  StateMachineBehaviour.init(self)
end

function BehaviourMovingRight:OnStateUpdate(dt, animatorController)
  local entity = animatorController.parent
  local playerController = entity.components['Script']['PlayerController']
  entity.position.x = entity.position.x + math.floor(playerController.speed * dt)
end