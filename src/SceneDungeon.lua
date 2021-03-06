SceneDungeon = Class{__includes = tiny.Scene}

function SceneDungeon:init()
  self.player = self:CreatePlayer()
  
  self.rooms = {}
  
  -- active room and next room, used when the player is shifting rooms
  self.currentRoom = Room(self.player)
  self.nextRoom = nil
  self.shifting = false
  self.camera = tiny.Vector2D(0, 0)
  
  -- trigger camera translation and adjustment of rooms whenever the player triggers a shift
  -- via a doorway collision, triggered in the respective BehaviourPlayerMoving scripts
  Event.on('shift-left', function()
    self:BeginShifting(-VIRTUAL_SIZE.x, 0)
  end)

  Event.on('shift-right', function()
    self:BeginShifting(VIRTUAL_SIZE.x, 0)
  end)

  Event.on('shift-up', function()
    self:BeginShifting(0, -VIRTUAL_SIZE.y)
  end)

  Event.on('shift-down', function()
    self:BeginShifting(0, VIRTUAL_SIZE.y)
  end)
end

function SceneDungeon:update(dt)
  Timer.update(dt)
  if not self.shifting then
    self.currentRoom:update(dt)
    self.player:update(dt)
  end
end

function SceneDungeon:render()
  -- translate the camera if we're actively shifting
  love.graphics.push()
  if self.shifting then
    love.graphics.translate(-math.floor(self.camera.x), -math.floor(self.camera.y))
  end
  self.currentRoom:render()
  if self.nextRoom then
    self.nextRoom:render()
  end
  love.graphics.pop()
end

--[[
    Prepares for the camera shifting process, kicking off a tween of the camera position.
]]
function SceneDungeon:BeginShifting(shiftX, shiftY)
  self.shifting = true
  self.nextRoom = Room(self.player, tiny.Vector2D(shiftX, shiftY))
  
  -- open the next room doorways until the shifting process ends
  for k, doorway in pairs(self.nextRoom.doorways) do
    doorway.isOpen = true
  end
  
  -- calculate player's ending position to tween it during the room shifting process
  local playerNewPosX, playerNewPosY = self.player.position.x, self.player.position.y
  if shiftX > 0 then
    playerNewPosX = VIRTUAL_SIZE.x + MAP_RENDER_OFFSET.x + TILE_SIZE + 6
  elseif shiftX < 0 then
    playerNewPosX = -MAP_RENDER_OFFSET.x - 6 - TILE_SIZE
  elseif shiftY > 0 then
    playerNewPosY = VIRTUAL_SIZE.y + MAP_RENDER_OFFSET.y + 13
  elseif shiftY < 0 then
    playerNewPosY = -MAP_RENDER_OFFSET.y - 11 - TILE_SIZE
  end
  
  -- tween the camera in whichever direction the new room is in, as well as the player to be
  -- at the opposite door in the next room, walking through the wall (which is stenciled)
  Timer.tween(1, {
    [self.camera] = { x = shiftX, y = shiftY },
    [self.player.position] = { x = playerNewPosX, y = playerNewPosY }
  }):finish(function()
    self:EndShifting()
  end)
end

--[[
    Restores regular values to the variables involved in the shifting process
]]
function SceneDungeon:EndShifting()
  self.shifting = false
  self.currentRoom = self.nextRoom
  self.nextRoom = nil
  
  -- close the doorways now that the shifting process ends
  for k, doorway in pairs(self.currentRoom.doorways) do
    doorway.isOpen = false
    doorway.gameObject.position = doorway.gameObject.position - self.currentRoom.shift
  end
  SOUNDS['door']:play()
  
  self.currentRoom.doorSwitch.position = self.currentRoom.doorSwitch.position - self.currentRoom.shift
  
  for k, entity in pairs(self.currentRoom.entities) do
    entity.position = entity.position - self.currentRoom.shift
  end
  
  self.player.position = self.player.position - self.currentRoom.shift
  
  self.currentRoom.shift = tiny.Vector2D(0, 0)
  self.camera = tiny.Vector2D(0, 0)
end

function SceneDungeon:CreatePlayer()
  local player = tiny.Entity(VIRTUAL_SIZE.x / 2, VIRTUAL_SIZE.y / 2)
  
  -- sprite component
  local playerSprite = tiny.Sprite(TEXTURES['player'], FRAMES['player-walk-up'][1])
  player:AddComponent(playerSprite)
  player:AddScript('PlayerController')
  
  -- create animator controller and setup parameters
  local playerAnimatorController = tiny.AnimatorController('PlayerAnimatorController')
  player:AddComponent(playerAnimatorController)
  playerAnimatorController:AddParameter('MoveDown', tiny.AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter('MoveUp', tiny.AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter('MoveLeft', tiny.AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter('MoveRight', tiny.AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter("Attack", tiny.AnimatorControllerParameterType.Trigger)
  
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
  stateAttackingDown:AddStateMachineBehaviour('BehaviourPlayerAttackingDown')
  stateAttackingLeft:AddStateMachineBehaviour('BehaviourPlayerAttackingLeft')
  stateAttackingRight:AddStateMachineBehaviour('BehaviourPlayerAttackingRight')
  stateAttackingUp:AddStateMachineBehaviour('BehaviourPlayerAttackingUp')
  
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
  idleDownToMovingDownTransition:AddCondition('MoveDown', tiny.AnimatorConditionOperatorType.Equals, true)
  idleUpToMovingDownTransition:AddCondition('MoveDown', tiny.AnimatorConditionOperatorType.Equals, true)
  idleLeftToMovingDownTransition:AddCondition('MoveDown', tiny.AnimatorConditionOperatorType.Equals, true)
  idleRightToMovingDownTransition:AddCondition('MoveDown', tiny.AnimatorConditionOperatorType.Equals, true)
  idleDownToMovingUpTransition:AddCondition('MoveUp', tiny.AnimatorConditionOperatorType.Equals, true)
  idleUpToMovingUpTransition:AddCondition('MoveUp', tiny.AnimatorConditionOperatorType.Equals, true)
  idleLeftToMovingUpTransition:AddCondition('MoveUp', tiny.AnimatorConditionOperatorType.Equals, true)
  idleRightToMovingUpTransition:AddCondition('MoveUp', tiny.AnimatorConditionOperatorType.Equals, true)
  idleDownToMovingLeftTransition:AddCondition('MoveLeft', tiny.AnimatorConditionOperatorType.Equals, true)
  idleUpToMovingLeftTransition:AddCondition('MoveLeft', tiny.AnimatorConditionOperatorType.Equals, true)
  idleLeftToMovingLeftTransition:AddCondition('MoveLeft', tiny.AnimatorConditionOperatorType.Equals, true)
  idleRightToMovingLeftTransition:AddCondition('MoveLeft', tiny.AnimatorConditionOperatorType.Equals, true)
  idleDownToMovingRightTransition:AddCondition('MoveRight', tiny.AnimatorConditionOperatorType.Equals, true)
  idleUpToMovingRightTransition:AddCondition('MoveRight', tiny.AnimatorConditionOperatorType.Equals, true)
  idleLeftToMovingRightTransition:AddCondition('MoveRight', tiny.AnimatorConditionOperatorType.Equals, true)
  idleRightToMovingRightTransition:AddCondition('MoveRight', tiny.AnimatorConditionOperatorType.Equals, true)
  movingDownToIdleDownTransition:AddCondition('MoveDown', tiny.AnimatorConditionOperatorType.Equals, false)
  movingUpToIdleUpTransition:AddCondition('MoveUp', tiny.AnimatorConditionOperatorType.Equals, false)
  movingLeftToIdleLeftTransition:AddCondition('MoveLeft', tiny.AnimatorConditionOperatorType.Equals, false)
  movingRightToIdleRightTransition:AddCondition('MoveRight', tiny.AnimatorConditionOperatorType.Equals, false)
  idleDownToAttackingDownTransition:AddCondition('Attack', tiny.AnimatorConditionOperatorType.Equals, true)
  movingDownToAttackingDownTransition:AddCondition('Attack', tiny.AnimatorConditionOperatorType.Equals, true)
  attackingDownToIdleDownTransition:AddCondition('MoveDown', tiny.AnimatorConditionOperatorType.Equals, false)
  attackingDownToMovingDownTransition:AddCondition('MoveDown', tiny.AnimatorConditionOperatorType.Equals, true)
  idleUpToAttackingUpTransition:AddCondition('Attack', tiny.AnimatorConditionOperatorType.Equals, true)
  movingUpToAttackingUpTransition:AddCondition('Attack', tiny.AnimatorConditionOperatorType.Equals, true)
  attackingUpToIdleUpTransition:AddCondition('MoveUp', tiny.AnimatorConditionOperatorType.Equals, false)
  attackingUpToMovingUpTransition:AddCondition('MoveUp', tiny.AnimatorConditionOperatorType.Equals, true)
  idleRightToAttackingRightTransition:AddCondition('Attack', tiny.AnimatorConditionOperatorType.Equals, true)
  movingRightToAttackingRightTransition:AddCondition('Attack', tiny.AnimatorConditionOperatorType.Equals, true)
  attackingRightToIdleRightTransition:AddCondition('MoveRight', tiny.AnimatorConditionOperatorType.Equals, false)
  attackingRightToMovingRightTransition:AddCondition('MoveRight', tiny.AnimatorConditionOperatorType.Equals, true)
  idleLeftToAttackingLeftTransition:AddCondition('Attack', tiny.AnimatorConditionOperatorType.Equals, true)
  movingLeftToAttackingLeftTransition:AddCondition('Attack', tiny.AnimatorConditionOperatorType.Equals, true)
  attackingLeftToIdleLeftTransition:AddCondition('MoveLeft', tiny.AnimatorConditionOperatorType.Equals, false)
  attackingLeftToMovingLeftTransition:AddCondition('MoveLeft', tiny.AnimatorConditionOperatorType.Equals, true)

  -- add collider and set it in the player controller script as the player's body collider
  local bodyCollider = tiny.Collider(tiny.Vector2D(0, 1), PLAYER_WALK_SIZE - tiny.Vector2D(8, 12))
  player:AddComponent(bodyCollider)
  if player.components['Script']['PlayerController'] then
    playerController = player.components['Script']['PlayerController']
    playerController.bodyCollider = bodyCollider
    playerController.dungeon = self
  end

  -- add collider and set it in the player controller script as the player's feet collider
  local feetCollider = tiny.Collider(tiny.Vector2D(0, 7), PLAYER_WALK_SIZE - tiny.Vector2D(8, 24))
  player:AddComponent(feetCollider)
  if player.components['Script']['PlayerController'] then
    playerController = player.components['Script']['PlayerController']
    playerController.feetCollider = feetCollider
    playerController.dungeon = self
  end

  return player
end
