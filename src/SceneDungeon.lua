SceneDungeon = Class{__includes = Scene}

function SceneDungeon:init()
  self.player = self:CreatePlayer()
  
  self.rooms = {}
  self.currentRoom = Room(self.player)
end

function SceneDungeon:update(dt)
  self.currentRoom:update(dt)
  self.player:update(dt)
end

function SceneDungeon:render()
  self.currentRoom:render()
  self.player:render()
end

function SceneDungeon:CreatePlayer()
  local player = Entity(VIRTUAL_SIZE.x / 2, VIRTUAL_SIZE.y / 2)
  
  -- sprite component
  local playerSprite = Sprite(TEXTURES['player'], FRAMES['player-walk-up'][1])
  player:AddComponent(playerSprite)
  player:AddScript('PlayerController')
  
  -- create animator controller and setup parameters
  local playerAnimatorController = AnimatorController('PlayerAnimatorController')
  player:AddComponent(playerAnimatorController)
  playerAnimatorController:AddParameter('MoveDown', AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter('MoveUp', AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter('MoveLeft', AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter('MoveRight', AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter("Attack", AnimatorControllerParameterType.Trigger)
  
  -- create state machine states (first state to be created will be the default state)
  local movingFrameDuration = 0.3
  local attackingFrameDuration = 0.07
  local stateIdleDown = playerAnimatorController:AddAnimation('IdleDown')
  stateIdleDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-down'][1])
  local stateIdleUp = playerAnimatorController:AddAnimation('IdleUp')
  stateIdleUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-up'][1])
  local stateIdleLeft = playerAnimatorController:AddAnimation('IdleLeft')
  stateIdleLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-left'][1])
  local stateIdleRight = playerAnimatorController:AddAnimation('IdleRight')
  stateIdleRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-right'][1])
  local stateMovingDown = playerAnimatorController:AddAnimation('MovingDown')
  stateMovingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-down'][1], movingFrameDuration)
  stateMovingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-down'][2], movingFrameDuration)
  stateMovingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-down'][3], movingFrameDuration)
  stateMovingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-down'][4], movingFrameDuration)
  local stateMovingUp = playerAnimatorController:AddAnimation('MovingUp')
  stateMovingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-up'][1], movingFrameDuration)
  stateMovingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-up'][2], movingFrameDuration)
  stateMovingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-up'][3], movingFrameDuration)
  stateMovingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-up'][4], movingFrameDuration)
  local stateMovingLeft = playerAnimatorController:AddAnimation('MovingLeft')
  stateMovingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-left'][1], movingFrameDuration)
  stateMovingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-left'][2], movingFrameDuration)
  stateMovingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-left'][3], movingFrameDuration)
  stateMovingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-left'][4], movingFrameDuration)
  local stateMovingRight = playerAnimatorController:AddAnimation('MovingRight')
  stateMovingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-right'][1], movingFrameDuration)
  stateMovingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-right'][2], movingFrameDuration)
  stateMovingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-right'][3], movingFrameDuration)
  stateMovingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-right'][4], movingFrameDuration)
  local stateAttackingDown = playerAnimatorController:AddAnimation('AttackingDown')
  stateAttackingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-down'][1], attackingFrameDuration)
  stateAttackingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-down'][2], attackingFrameDuration)
  stateAttackingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-down'][3], attackingFrameDuration)
  stateAttackingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-down'][4], attackingFrameDuration)
  local stateAttackingUp = playerAnimatorController:AddAnimation('AttackingUp')
  stateAttackingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-up'][1], attackingFrameDuration)
  stateAttackingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-up'][2], attackingFrameDuration)
  stateAttackingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-up'][3], attackingFrameDuration)
  stateAttackingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-up'][4], attackingFrameDuration)
  local stateAttackingRight = playerAnimatorController:AddAnimation('AttackingRight')
  stateAttackingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-right'][1], attackingFrameDuration)
  stateAttackingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-right'][2], attackingFrameDuration)
  stateAttackingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-right'][3], attackingFrameDuration)
  stateAttackingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-right'][4], attackingFrameDuration)
  local stateAttackingLeft = playerAnimatorController:AddAnimation('AttackingLeft')
  stateAttackingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-left'][1], attackingFrameDuration)
  stateAttackingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-left'][2], attackingFrameDuration)
  stateAttackingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-left'][3], attackingFrameDuration)
  stateAttackingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-left'][4], attackingFrameDuration)

  -- animation states behaviours
  stateMovingLeft:AddStateMachineBehaviour('BehaviourPlayerMovingLeft')
  stateMovingRight:AddStateMachineBehaviour('BehaviourPlayerMovingRight')
  stateMovingUp:AddStateMachineBehaviour('BehaviourPlayerMovingUp')
  stateMovingDown:AddStateMachineBehaviour('BehaviourPlayerMovingDown')
  
  -- transitions
  local idleDownToMovingDownTransition = playerAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateMovingDown)
  local idleUpToMovingDownTransition = playerAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateMovingDown)
  local idleLeftToMovingDownTransition = playerAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateMovingDown)
  local idleRightToMovingDownTransition = playerAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateMovingDown)
  local idleDownToMovingUpTransition = playerAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateMovingUp)
  local idleUpToMovingUpTransition = playerAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateMovingUp)
  local idleLeftToMovingUpTransition = playerAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateMovingUp)
  local idleRightToMovingUpTransition = playerAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateMovingUp)
  local idleDownToMovingLeftTransition = playerAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateMovingLeft)
  local idleUpToMovingLeftTransition = playerAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateMovingLeft)
  local idleLeftToMovingLeftTransition = playerAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateMovingLeft)
  local idleRightToMovingLeftTransition = playerAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateMovingLeft)
  local idleDownToMovingRightTransition = playerAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateMovingRight)
  local idleUpToMovingRightTransition = playerAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateMovingRight)
  local idleLeftToMovingRightTransition = playerAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateMovingRight)
  local idleRightToMovingRightTransition = playerAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateMovingRight)
  local movingDownToIdleDownTransition = playerAnimatorController.stateMachine.states[stateMovingDown.name]:AddTransition(stateIdleDown)
  local movingUpToIdleUpTransition = playerAnimatorController.stateMachine.states[stateMovingUp.name]:AddTransition(stateIdleUp)
  local movingLeftToIdleLeftTransition = playerAnimatorController.stateMachine.states[stateMovingLeft.name]:AddTransition(stateIdleLeft)
  local movingRightToIdleRightTransition = playerAnimatorController.stateMachine.states[stateMovingRight.name]:AddTransition(stateIdleRight)
  local idleDownToAttackingDownTransition = playerAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateAttackingDown)
  local movingDownToAttackingDownTransition = playerAnimatorController.stateMachine.states[stateMovingDown.name]:AddTransition(stateAttackingDown)
  local attackingDownToIdleDownTransition = playerAnimatorController.stateMachine.states[stateAttackingDown.name]:AddTransition(stateIdleDown)
  attackingDownToIdleDownTransition.exitTime = 1
  local attackingDownToMovingDownTransition = playerAnimatorController.stateMachine.states[stateAttackingDown.name]:AddTransition(stateMovingDown)
  attackingDownToMovingDownTransition.exitTime = 1
  local idleUpToAttackingUpTransition = playerAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateAttackingUp)
  local movingUpToAttackingUpTransition = playerAnimatorController.stateMachine.states[stateMovingUp.name]:AddTransition(stateAttackingUp)
  local attackingUpToIdleUpTransition = playerAnimatorController.stateMachine.states[stateAttackingUp.name]:AddTransition(stateIdleUp)
  attackingUpToIdleUpTransition.exitTime = 1
  local attackingUpToMovingUpTransition = playerAnimatorController.stateMachine.states[stateAttackingUp.name]:AddTransition(stateMovingUp)
  attackingUpToMovingUpTransition.exitTime = 1
  local idleRightToAttackingRightTransition = playerAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateAttackingRight)
  local movingRightToAttackingRightTransition = playerAnimatorController.stateMachine.states[stateMovingRight.name]:AddTransition(stateAttackingRight)
  local attackingRightToIdleRightTransition = playerAnimatorController.stateMachine.states[stateAttackingRight.name]:AddTransition(stateIdleRight)
  attackingRightToIdleRightTransition.exitTime = 1
  local attackingRightToMovingRightTransition = playerAnimatorController.stateMachine.states[stateAttackingRight.name]:AddTransition(stateMovingRight)
  attackingRightToMovingRightTransition.exitTime = 1
  local idleLeftToAttackingLeftTransition = playerAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateAttackingLeft)
  local movingLeftToAttackingLeftTransition = playerAnimatorController.stateMachine.states[stateMovingLeft.name]:AddTransition(stateAttackingLeft)
  local attackingLeftToIdleLeftTransition = playerAnimatorController.stateMachine.states[stateAttackingLeft.name]:AddTransition(stateIdleLeft)
  attackingLeftToIdleLeftTransition.exitTime = 1
  local attackingLeftToMovingLeftTransition = playerAnimatorController.stateMachine.states[stateAttackingLeft.name]:AddTransition(stateMovingLeft)
  attackingLeftToMovingLeftTransition.exitTime = 1
  
  -- transition conditions
  idleDownToMovingDownTransition:AddCondition('MoveDown', AnimatorConditionOperatorType.Equals, true)
  idleUpToMovingDownTransition:AddCondition('MoveDown', AnimatorConditionOperatorType.Equals, true)
  idleLeftToMovingDownTransition:AddCondition('MoveDown', AnimatorConditionOperatorType.Equals, true)
  idleRightToMovingDownTransition:AddCondition('MoveDown', AnimatorConditionOperatorType.Equals, true)
  idleDownToMovingUpTransition:AddCondition('MoveUp', AnimatorConditionOperatorType.Equals, true)
  idleUpToMovingUpTransition:AddCondition('MoveUp', AnimatorConditionOperatorType.Equals, true)
  idleLeftToMovingUpTransition:AddCondition('MoveUp', AnimatorConditionOperatorType.Equals, true)
  idleRightToMovingUpTransition:AddCondition('MoveUp', AnimatorConditionOperatorType.Equals, true)
  idleDownToMovingLeftTransition:AddCondition('MoveLeft', AnimatorConditionOperatorType.Equals, true)
  idleUpToMovingLeftTransition:AddCondition('MoveLeft', AnimatorConditionOperatorType.Equals, true)
  idleLeftToMovingLeftTransition:AddCondition('MoveLeft', AnimatorConditionOperatorType.Equals, true)
  idleRightToMovingLeftTransition:AddCondition('MoveLeft', AnimatorConditionOperatorType.Equals, true)
  idleDownToMovingRightTransition:AddCondition('MoveRight', AnimatorConditionOperatorType.Equals, true)
  idleUpToMovingRightTransition:AddCondition('MoveRight', AnimatorConditionOperatorType.Equals, true)
  idleLeftToMovingRightTransition:AddCondition('MoveRight', AnimatorConditionOperatorType.Equals, true)
  idleRightToMovingRightTransition:AddCondition('MoveRight', AnimatorConditionOperatorType.Equals, true)
  movingDownToIdleDownTransition:AddCondition('MoveDown', AnimatorConditionOperatorType.Equals, false)
  movingUpToIdleUpTransition:AddCondition('MoveUp', AnimatorConditionOperatorType.Equals, false)
  movingLeftToIdleLeftTransition:AddCondition('MoveLeft', AnimatorConditionOperatorType.Equals, false)
  movingRightToIdleRightTransition:AddCondition('MoveRight', AnimatorConditionOperatorType.Equals, false)
  idleDownToAttackingDownTransition:AddCondition('Attack', AnimatorConditionOperatorType.Equals, true)
  movingDownToAttackingDownTransition:AddCondition('Attack', AnimatorConditionOperatorType.Equals, true)
  attackingDownToIdleDownTransition:AddCondition('MoveDown', AnimatorConditionOperatorType.Equals, false)
  attackingDownToMovingDownTransition:AddCondition('MoveDown', AnimatorConditionOperatorType.Equals, true)
  idleUpToAttackingUpTransition:AddCondition('Attack', AnimatorConditionOperatorType.Equals, true)
  movingUpToAttackingUpTransition:AddCondition('Attack', AnimatorConditionOperatorType.Equals, true)
  attackingUpToIdleUpTransition:AddCondition('MoveUp', AnimatorConditionOperatorType.Equals, false)
  attackingUpToMovingUpTransition:AddCondition('MoveUp', AnimatorConditionOperatorType.Equals, true)
  idleRightToAttackingRightTransition:AddCondition('Attack', AnimatorConditionOperatorType.Equals, true)
  movingRightToAttackingRightTransition:AddCondition('Attack', AnimatorConditionOperatorType.Equals, true)
  attackingRightToIdleRightTransition:AddCondition('MoveRight', AnimatorConditionOperatorType.Equals, false)
  attackingRightToMovingRightTransition:AddCondition('MoveRight', AnimatorConditionOperatorType.Equals, true)
  idleLeftToAttackingLeftTransition:AddCondition('Attack', AnimatorConditionOperatorType.Equals, true)
  movingLeftToAttackingLeftTransition:AddCondition('Attack', AnimatorConditionOperatorType.Equals, true)
  attackingLeftToIdleLeftTransition:AddCondition('MoveLeft', AnimatorConditionOperatorType.Equals, false)
  attackingLeftToMovingLeftTransition:AddCondition('MoveLeft', AnimatorConditionOperatorType.Equals, true)

  -- add collider
  local collider = Collider { center = Vector2D(0, 1), size = PLAYER_WALK_SIZE - Vector2D(8, 12) }
  player:AddComponent(collider)

  return player
end
