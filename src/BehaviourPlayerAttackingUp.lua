BehaviourPlayerAttackingUp = Class{__includes = tiny.StateMachineBehaviour}

function BehaviourPlayerAttackingUp:init()
  self.name = 'BehaviourPlayerAttackingUp'
  tiny.StateMachineBehaviour.init(self)
end

function BehaviourPlayerAttackingUp:OnStateEnter(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  local colliderCenter = tiny.Vector2D(0, -6)
  local colliderSize = tiny.Vector2D(16, 12)
  local collider = tiny.Collider(colliderCenter, colliderSize)
  entity:AddComponent(collider)
  playerController.attackCollider = collider
  SOUNDS['sword']:play()
end

function BehaviourPlayerAttackingUp:OnStateExit(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  colliders = entity.components['Collider']
  entity:RemoveComponent(playerController.attackCollider)
  playerController.attackCollider = nil
end

function BehaviourPlayerAttackingUp:OnStateUpdate(dt, animatorController)
end
