BehaviourPlayerAttackingRight = Class{__includes = tiny.StateMachineBehaviour}

function BehaviourPlayerAttackingRight:init()
  self.name = 'BehaviourPlayerAttackingRight'
  tiny.StateMachineBehaviour.init(self)
end

function BehaviourPlayerAttackingRight:OnStateEnter(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  local colliderCenter = tiny.Vector2D(9, 3)
  local colliderSize = tiny.Vector2D(10, 18)
  local collider = tiny.Collider(colliderCenter, colliderSize)
  entity:AddComponent(collider)
  playerController.attackCollider = collider
  SOUNDS['sword']:play()
end

function BehaviourPlayerAttackingRight:OnStateExit(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  colliders = entity.components['Collider']
  entity:RemoveComponent(playerController.attackCollider)
  playerController.attackCollider = nil
end

function BehaviourPlayerAttackingRight:OnStateUpdate(dt, animatorController)
end
