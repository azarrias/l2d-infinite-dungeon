SceneDungeon = Class{__includes = Scene}

function SceneDungeon:init()
  self.player = Entity(VIRTUAL_SIZE.x / 2, VIRTUAL_SIZE.y / 2)

  -- sprite component
  playerSprite = Sprite(TEXTURES['player'], FRAMES['player-walk-down'][1])
  self.player:AddComponent(playerSprite)
  self.player:AddScript('PlayerController')
  
  -- create animator controller and setup parameters
  playerAnimatorController = AnimatorController('PlayerAnimatorController')
  self.player:AddComponent(playerAnimatorController)
  playerAnimatorController:AddParameter('MoveDown', AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter('MoveUp', AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter('MoveLeft', AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter('MoveRight', AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter("Attack", AnimatorControllerParameterType.Trigger)
  
  -- create state machine states (first state to be created will be the default state)
  stateIdleDown = playerAnimatorController:AddAnimation('IdleDown')
  stateIdleDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-down'][1])
  stateIdleUp = playerAnimatorController:AddAnimation('IdleUp')
  stateIdleUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-up'][1])
  stateIdleLeft = playerAnimatorController:AddAnimation('IdleLeft')
  stateIdleLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-left'][1])
  stateIdleRight = playerAnimatorController:AddAnimation('IdleRight')
  stateIdleRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-right'][1])
  stateMovingDown = playerAnimatorController:AddAnimation('MovingDown')
  stateMovingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-down'][1], 0.3)
  stateMovingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-down'][2], 0.3)
  stateMovingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-down'][3], 0.3)
  stateMovingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-down'][4], 0.3)
  stateMovingUp = playerAnimatorController:AddAnimation('MovingUp')
  stateMovingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-up'][1], 0.3)
  stateMovingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-up'][2], 0.3)
  stateMovingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-up'][3], 0.3)
  stateMovingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-up'][4], 0.3)
  stateMovingLeft = playerAnimatorController:AddAnimation('MovingLeft')
  stateMovingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-left'][1], 0.3)
  stateMovingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-left'][2], 0.3)
  stateMovingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-left'][3], 0.3)
  stateMovingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-left'][4], 0.3)
  stateMovingRight = playerAnimatorController:AddAnimation('MovingRight')
  stateMovingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-right'][1], 0.3)
  stateMovingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-right'][2], 0.3)
  stateMovingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-right'][3], 0.3)
  stateMovingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-right'][4], 0.3)
  stateAttackingDown = playerAnimatorController:AddAnimation('AttackingDown')
  stateAttackingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-down'][1], 0.15)
  stateAttackingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-down'][2], 0.15)
  stateAttackingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-down'][3], 0.15)
  stateAttackingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-down'][4], 0.15)
  stateAttackingUp = playerAnimatorController:AddAnimation('AttackingUp')
  stateAttackingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-up'][1], 0.15)
  stateAttackingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-up'][2], 0.15)
  stateAttackingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-up'][3], 0.15)
  stateAttackingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-up'][4], 0.15)
  stateAttackingRight = playerAnimatorController:AddAnimation('AttackingRight')
  stateAttackingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-right'][1], 0.15)
  stateAttackingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-right'][2], 0.15)
  stateAttackingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-right'][3], 0.15)
  stateAttackingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-right'][4], 0.15)
  stateAttackingLeft = playerAnimatorController:AddAnimation('AttackingLeft')
  stateAttackingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-left'][1], 0.15)
  stateAttackingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-left'][2], 0.15)
  stateAttackingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-left'][3], 0.15)
  stateAttackingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-left'][4], 0.15)

  -- animation states behaviours
  stateMovingLeft:AddStateMachineBehaviour('BehaviourMovingLeft')
  stateMovingRight:AddStateMachineBehaviour('BehaviourMovingRight')
  stateMovingUp:AddStateMachineBehaviour('BehaviourMovingUp')
  stateMovingDown:AddStateMachineBehaviour('BehaviourMovingDown')
  
  -- transitions
  idleDownToMovingDownTransition = playerAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateMovingDown)
  idleUpToMovingDownTransition = playerAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateMovingDown)
  idleLeftToMovingDownTransition = playerAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateMovingDown)
  idleRightToMovingDownTransition = playerAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateMovingDown)
  idleDownToMovingUpTransition = playerAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateMovingUp)
  idleUpToMovingUpTransition = playerAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateMovingUp)
  idleLeftToMovingUpTransition = playerAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateMovingUp)
  idleRightToMovingUpTransition = playerAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateMovingUp)
  idleDownToMovingLeftTransition = playerAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateMovingLeft)
  idleUpToMovingLeftTransition = playerAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateMovingLeft)
  idleLeftToMovingLeftTransition = playerAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateMovingLeft)
  idleRightToMovingLeftTransition = playerAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateMovingLeft)
  idleDownToMovingRightTransition = playerAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateMovingRight)
  idleUpToMovingRightTransition = playerAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateMovingRight)
  idleLeftToMovingRightTransition = playerAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateMovingRight)
  idleRightToMovingRightTransition = playerAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateMovingRight)
  movingDownToIdleDownTransition = playerAnimatorController.stateMachine.states[stateMovingDown.name]:AddTransition(stateIdleDown)
  movingUpToIdleUpTransition = playerAnimatorController.stateMachine.states[stateMovingUp.name]:AddTransition(stateIdleUp)
  movingLeftToIdleLeftTransition = playerAnimatorController.stateMachine.states[stateMovingLeft.name]:AddTransition(stateIdleLeft)
  movingRightToIdleRightTransition = playerAnimatorController.stateMachine.states[stateMovingRight.name]:AddTransition(stateIdleRight)
  idleDownToAttackingDownTransition = playerAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateAttackingDown)
  movingDownToAttackingDownTransition = playerAnimatorController.stateMachine.states[stateMovingDown.name]:AddTransition(stateAttackingDown)
  attackingDownToIdleDownTransition = playerAnimatorController.stateMachine.states[stateAttackingDown.name]:AddTransition(stateIdleDown)
  attackingDownToIdleDownTransition.exitTime = 1
  attackingDownToMovingDownTransition = playerAnimatorController.stateMachine.states[stateAttackingDown.name]:AddTransition(stateMovingDown)
  attackingDownToMovingDownTransition.exitTime = 1
  idleUpToAttackingUpTransition = playerAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateAttackingUp)
  movingUpToAttackingUpTransition = playerAnimatorController.stateMachine.states[stateMovingUp.name]:AddTransition(stateAttackingUp)
  attackingUpToIdleUpTransition = playerAnimatorController.stateMachine.states[stateAttackingUp.name]:AddTransition(stateIdleUp)
  attackingUpToIdleUpTransition.exitTime = 1
  attackingUpToMovingUpTransition = playerAnimatorController.stateMachine.states[stateAttackingUp.name]:AddTransition(stateMovingUp)
  attackingUpToMovingUpTransition.exitTime = 1
  idleRightToAttackingRightTransition = playerAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateAttackingRight)
  movingRightToAttackingRightTransition = playerAnimatorController.stateMachine.states[stateMovingRight.name]:AddTransition(stateAttackingRight)
  attackingRightToIdleRightTransition = playerAnimatorController.stateMachine.states[stateAttackingRight.name]:AddTransition(stateIdleRight)
  attackingRightToIdleRightTransition.exitTime = 1
  attackingRightToMovingRightTransition = playerAnimatorController.stateMachine.states[stateAttackingRight.name]:AddTransition(stateMovingRight)
  attackingRightToMovingRightTransition.exitTime = 1
  idleLeftToAttackingLeftTransition = playerAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateAttackingLeft)
  movingLeftToAttackingLeftTransition = playerAnimatorController.stateMachine.states[stateMovingLeft.name]:AddTransition(stateAttackingLeft)
  attackingLeftToIdleLeftTransition = playerAnimatorController.stateMachine.states[stateAttackingLeft.name]:AddTransition(stateIdleLeft)
  attackingLeftToIdleLeftTransition.exitTime = 1
  attackingLeftToMovingLeftTransition = playerAnimatorController.stateMachine.states[stateAttackingLeft.name]:AddTransition(stateMovingLeft)
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
  
  self.rooms = {}
  self.currentRoom = Room(self.player)
end

function SceneDungeon:update(dt)
  self.player:update(dt)
end

function SceneDungeon:render()
  self.currentRoom:render()
  self.player:render()
end