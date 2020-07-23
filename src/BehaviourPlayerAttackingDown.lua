BehaviourPlayerAttackingDown = Class{__includes = tiny.StateMachineBehaviour}

function BehaviourPlayerAttackingDown:init()
  self.name = 'BehaviourPlayerAttackingDown'
  tiny.StateMachineBehaviour.init(self)
end

function BehaviourPlayerAttackingDown:OnStateEnter(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  local colliderCenter = tiny.Vector2D(0, 11)
  local colliderSize = tiny.Vector2D(16, 12)
  local collider = tiny.Collider(colliderCenter, colliderSize)
  entity:AddComponent(collider)
  playerController.attackCollider = collider
  SOUNDS['sword']:play()
end

function BehaviourPlayerAttackingDown:OnStateExit(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  colliders = entity.components['Collider']
  entity:RemoveComponent(playerController.attackCollider)
  playerController.attackCollider = nil
end

function BehaviourPlayerAttackingDown:OnStateUpdate(dt, animatorController)
end
