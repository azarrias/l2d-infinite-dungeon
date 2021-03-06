BehaviourPlayerAttackingLeft = Class{__includes = tiny.StateMachineBehaviour}

function BehaviourPlayerAttackingLeft:init()
  self.name = 'BehaviourPlayerAttackingLeft'
  tiny.StateMachineBehaviour.init(self)
end

function BehaviourPlayerAttackingLeft:OnStateEnter(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  local colliderCenter = tiny.Vector2D(-10, 3)
  local colliderSize = tiny.Vector2D(10, 18)
  local collider = tiny.Collider(colliderCenter, colliderSize)
  entity:AddComponent(collider)
  playerController.attackCollider = collider
  SOUNDS['sword']:play()
end

function BehaviourPlayerAttackingLeft:OnStateExit(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  colliders = entity.components['Collider']
  entity:RemoveComponent(playerController.attackCollider)
  playerController.attackCollider = nil
end

function BehaviourPlayerAttackingLeft:OnStateUpdate(dt, animatorController)
end
