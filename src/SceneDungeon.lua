SceneDungeon = Class{__includes = Scene}

function SceneDungeon:init()
  self.player = self:CreatePlayer()
  self.entities = self:GenerateEntities()
  
  self.rooms = {}
  self.currentRoom = Room(self.player)
end

function SceneDungeon:update(dt)
  self.player:update(dt)
  for k, entity in pairs(self.entities) do
    entity:update(dt)
  end
end

function SceneDungeon:render()
  self.currentRoom:render()
  self.player:render()
  for k, entity in pairs(self.entities) do
    entity:render()
  end
end

function SceneDungeon:CreatePlayer()
  local player = Entity(VIRTUAL_SIZE.x / 2, VIRTUAL_SIZE.y / 2)
  
  -- sprite component
  local playerSprite = Sprite(TEXTURES['player'], FRAMES['player-walk-down'][1])
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
  local stateIdleDown = playerAnimatorController:AddAnimation('IdleDown')
  stateIdleDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-down'][1])
  local stateIdleUp = playerAnimatorController:AddAnimation('IdleUp')
  stateIdleUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-up'][1])
  local stateIdleLeft = playerAnimatorController:AddAnimation('IdleLeft')
  stateIdleLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-left'][1])
  local stateIdleRight = playerAnimatorController:AddAnimation('IdleRight')
  stateIdleRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-right'][1])
  local stateMovingDown = playerAnimatorController:AddAnimation('MovingDown')
  stateMovingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-down'][1], 0.3)
  stateMovingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-down'][2], 0.3)
  stateMovingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-down'][3], 0.3)
  stateMovingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-down'][4], 0.3)
  local stateMovingUp = playerAnimatorController:AddAnimation('MovingUp')
  stateMovingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-up'][1], 0.3)
  stateMovingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-up'][2], 0.3)
  stateMovingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-up'][3], 0.3)
  stateMovingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-up'][4], 0.3)
  local stateMovingLeft = playerAnimatorController:AddAnimation('MovingLeft')
  stateMovingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-left'][1], 0.3)
  stateMovingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-left'][2], 0.3)
  stateMovingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-left'][3], 0.3)
  stateMovingLeft.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-left'][4], 0.3)
  local stateMovingRight = playerAnimatorController:AddAnimation('MovingRight')
  stateMovingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-right'][1], 0.3)
  stateMovingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-right'][2], 0.3)
  stateMovingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-right'][3], 0.3)
  stateMovingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-walk-right'][4], 0.3)
  local stateAttackingDown = playerAnimatorController:AddAnimation('AttackingDown')
  stateAttackingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-down'][1], 0.15)
  stateAttackingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-down'][2], 0.15)
  stateAttackingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-down'][3], 0.15)
  stateAttackingDown.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-down'][4], 0.15)
  local stateAttackingUp = playerAnimatorController:AddAnimation('AttackingUp')
  stateAttackingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-up'][1], 0.15)
  stateAttackingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-up'][2], 0.15)
  stateAttackingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-up'][3], 0.15)
  stateAttackingUp.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-up'][4], 0.15)
  local stateAttackingRight = playerAnimatorController:AddAnimation('AttackingRight')
  stateAttackingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-right'][1], 0.15)
  stateAttackingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-right'][2], 0.15)
  stateAttackingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-right'][3], 0.15)
  stateAttackingRight.animation:AddFrame(TEXTURES['player'], FRAMES['player-attack-right'][4], 0.15)
  local stateAttackingLeft = playerAnimatorController:AddAnimation('AttackingLeft')
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

  return player
end

function SceneDungeon:GenerateEntities()
  local entityTypes = {'skeleton', 'slime', 'bat', 'ghost', 'spider'}
  local entities = {}
  
  for i = 1, 10 do
    local entityType = entityTypes[math.random(#entityTypes)]
    local entity = self:CreateEntity(entityType)
    table.insert(entities, entity)
  end
  
  return entities
end

function SceneDungeon:CreateEntity(entityType)
  local posX = math.random(MAP_RENDER_OFFSET.x + TILE_SIZE + 8, MAP_RENDER_OFFSET.x + MAP_SIZE.x * TILE_SIZE - TILE_SIZE - 8)
  local posY = math.random(MAP_RENDER_OFFSET.y + TILE_SIZE + 8, MAP_RENDER_OFFSET.y + MAP_SIZE.y * TILE_SIZE - TILE_SIZE - 8)
  local entity = Entity(posX, posY)
  local entitySprite
  
  -- sprite component
  if entityType == 'skeleton' then
    entitySprite = Sprite(TEXTURES['entities'], FRAMES['skeleton-move-down'][2])
  elseif entityType == 'slime' then
    entitySprite = Sprite(TEXTURES['entities'], FRAMES['slime-move-down'][2])
  elseif entityType == 'bat' then
    entitySprite = Sprite(TEXTURES['entities'], FRAMES['bat-move-down'][2])
  elseif entityType == 'ghost' then
    entitySprite = Sprite(TEXTURES['entities'], FRAMES['ghost-move-down'][2])
  elseif entityType == 'spider' then
    entitySprite = Sprite(TEXTURES['entities'], FRAMES['spider-move-down'][2])
  end
  entitySprite = Sprite(TEXTURES['entities'], FRAMES[entityType .. '-move-down'][2])
  entity:AddComponent(entitySprite)
  
  entity:AddScript('EntityController')
  
  -- create animator controller and setup parameters
  local entityAnimatorController = AnimatorController('EntityAnimatorController')
  entity:AddComponent(entityAnimatorController)
  entityAnimatorController:AddParameter('MoveDown', AnimatorControllerParameterType.Bool)
  entityAnimatorController:AddParameter('MoveUp', AnimatorControllerParameterType.Bool)
  entityAnimatorController:AddParameter('MoveLeft', AnimatorControllerParameterType.Bool)
  entityAnimatorController:AddParameter('MoveRight', AnimatorControllerParameterType.Bool)
  
  -- create state machine states (first state to be created will be the default state)
  local stateIdleDown = entityAnimatorController:AddAnimation('IdleDown')
  local stateIdleUp = entityAnimatorController:AddAnimation('IdleUp')
  local stateIdleLeft = entityAnimatorController:AddAnimation('IdleLeft')
  local stateIdleRight = entityAnimatorController:AddAnimation('IdleRight')
  local stateMovingDown = entityAnimatorController:AddAnimation('MovingDown')
  local stateMovingUp = entityAnimatorController:AddAnimation('MovingUp')
  local stateMovingLeft = entityAnimatorController:AddAnimation('MovingLeft')
  local stateMovingRight = entityAnimatorController:AddAnimation('MovingRight')
  
  stateIdleDown.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-down'][2])
  stateIdleUp.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-up'][2])
  stateIdleLeft.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-left'][2])
  stateIdleRight.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-right'][2])

  stateMovingDown.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-down'][1], 0.3)
  stateMovingDown.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-down'][2], 0.3)
  stateMovingDown.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-down'][3], 0.3)
  stateMovingDown.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-down'][2], 0.3)

  stateMovingUp.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-up'][1], 0.3)
  stateMovingUp.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-up'][2], 0.3)
  stateMovingUp.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-up'][3], 0.3)
  stateMovingUp.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-up'][2], 0.3)

  stateMovingLeft.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-left'][1], 0.3)
  stateMovingLeft.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-left'][2], 0.3)
  stateMovingLeft.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-left'][3], 0.3)
  stateMovingLeft.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-left'][2], 0.3)

  stateMovingRight.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-right'][1], 0.3)
  stateMovingRight.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-right'][2], 0.3)
  stateMovingRight.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-right'][3], 0.3)
  stateMovingRight.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-right'][2], 0.3)
  
  -- animation states behaviours
  stateIdleDown:AddStateMachineBehaviour('BehaviourEntityIdle')
  stateIdleUp:AddStateMachineBehaviour('BehaviourEntityIdle')
  stateIdleLeft:AddStateMachineBehaviour('BehaviourEntityIdle')
  stateIdleRight:AddStateMachineBehaviour('BehaviourEntityIdle')
  stateMovingLeft:AddStateMachineBehaviour('BehaviourEntityMovingLeft')
  stateMovingRight:AddStateMachineBehaviour('BehaviourEntityMovingRight')
  stateMovingUp:AddStateMachineBehaviour('BehaviourEntityMovingUp')
  stateMovingDown:AddStateMachineBehaviour('BehaviourEntityMovingDown')
  
  -- transitions
  local idleDownToMovingDownTransition = entityAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateMovingDown)
  local idleUpToMovingDownTransition = entityAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateMovingDown)
  local idleLeftToMovingDownTransition = entityAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateMovingDown)
  local idleRightToMovingDownTransition = entityAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateMovingDown)
  local idleDownToMovingUpTransition = entityAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateMovingUp)
  local idleUpToMovingUpTransition = entityAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateMovingUp)
  local idleLeftToMovingUpTransition = entityAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateMovingUp)
  local idleRightToMovingUpTransition = entityAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateMovingUp)
  local idleDownToMovingLeftTransition = entityAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateMovingLeft)
  local idleUpToMovingLeftTransition = entityAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateMovingLeft)
  local idleLeftToMovingLeftTransition = entityAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateMovingLeft)
  local idleRightToMovingLeftTransition = entityAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateMovingLeft)
  local idleDownToMovingRightTransition = entityAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateMovingRight)
  local idleUpToMovingRightTransition = entityAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateMovingRight)
  local idleLeftToMovingRightTransition = entityAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateMovingRight)
  local idleRightToMovingRightTransition = entityAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateMovingRight)
  local movingDownToIdleDownTransition = entityAnimatorController.stateMachine.states[stateMovingDown.name]:AddTransition(stateIdleDown)
  local movingUpToIdleUpTransition = entityAnimatorController.stateMachine.states[stateMovingUp.name]:AddTransition(stateIdleUp)
  local movingLeftToIdleLeftTransition = entityAnimatorController.stateMachine.states[stateMovingLeft.name]:AddTransition(stateIdleLeft)
  local movingRightToIdleRightTransition = entityAnimatorController.stateMachine.states[stateMovingRight.name]:AddTransition(stateIdleRight)

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

  return entity
end