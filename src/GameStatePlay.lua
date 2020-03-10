GameStatePlay = Class{__includes = BaseState}

function GameStatePlay:init()
  self.player = Entity {
    position = Vector2D(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2),
    texture = TEXTURES['player'],
    frame = FRAMES['player-walk-down'][1]
  }
  -- create animator controller and setup parameters
  playerAnimatorController = AnimatorController('PlayerAnimatorController')
  self.player:AddComponent(playerAnimatorController)
  playerAnimatorController:AddParameter('MoveDown', AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter('MoveUp', AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter('MoveLeft', AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter('MoveRight', AnimatorControllerParameterType.Bool)
  -- create state machine states (first state to be created will be the default state)
  stateIdle = playerAnimatorController.stateMachine:AddState('Idle')
  stateMovingDown = playerAnimatorController.stateMachine:AddState('MovingDown')
  stateMovingUp = playerAnimatorController.stateMachine:AddState('MovingUp')
  stateMovingLeft = playerAnimatorController.stateMachine:AddState('MovingLeft')
  stateMovingRight = playerAnimatorController.stateMachine:AddState('MovingRight')
  -- transitions
  idleToMovingDownTransition = playerAnimatorController.stateMachine.states[stateIdle.name]:AddTransition(stateMovingDown)
  idleToMovingUpTransition = playerAnimatorController.stateMachine.states[stateIdle.name]:AddTransition(stateMovingUp)
  idleToMovingLeftTransition = playerAnimatorController.stateMachine.states[stateIdle.name]:AddTransition(stateMovingLeft)
  idleToMovingRightTransition = playerAnimatorController.stateMachine.states[stateIdle.name]:AddTransition(stateMovingRight)
  movingDownToIdleTransition = playerAnimatorController.stateMachine.states[stateMovingDown.name]:AddTransition(stateIdle)
  movingUpToIdleTransition = playerAnimatorController.stateMachine.states[stateMovingUp.name]:AddTransition(stateIdle)
  movingLeftToIdleTransition = playerAnimatorController.stateMachine.states[stateMovingLeft.name]:AddTransition(stateIdle)
  movingRightToIdleTransition = playerAnimatorController.stateMachine.states[stateMovingRight.name]:AddTransition(stateIdle)
  -- transition conditions
  idleToMovingDownTransition:AddCondition('MoveDown', AnimatorConditionOperatorType.Equals, true)
  idleToMovingUpTransition:AddCondition('MoveUp', AnimatorConditionOperatorType.Equals, true)
  idleToMovingLeftTransition:AddCondition('MoveLeft', AnimatorConditionOperatorType.Equals, true)
  idleToMovingRightTransition:AddCondition('MoveRight', AnimatorConditionOperatorType.Equals, true)
  movingDownToIdleTransition:AddCondition('MoveDown', AnimatorConditionOperatorType.Equals, false)
  movingUpToIdleTransition:AddCondition('MoveUp', AnimatorConditionOperatorType.Equals, false)
  movingLeftToIdleTransition:AddCondition('MoveLeft', AnimatorConditionOperatorType.Equals, false)
  movingRightToIdleTransition:AddCondition('MoveRight', AnimatorConditionOperatorType.Equals, false)
end

function GameStatePlay:update(dt)
  local isDownDown = love.keyboard.isDown('down')
  local isDownUp = love.keyboard.isDown('up')
  local isDownLeft = love.keyboard.isDown('left')
  local isDownRight = love.keyboard.isDown('right')
  playerAnimatorController:SetValue('MoveDown', isDownDown)
  playerAnimatorController:SetValue('MoveUp', isDownUp)
  playerAnimatorController:SetValue('MoveLeft', isDownLeft)
  playerAnimatorController:SetValue('MoveRight', isDownRight)
  playerAnimatorController:update(dt)
end

function GameStatePlay:render()
  self.player:render()
end