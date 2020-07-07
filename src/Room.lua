Room = Class{}

function Room:init(player)
  self.size = MAP_SIZE
  self.tiles = self:GenerateTileset(MAP_SIZE.x, MAP_SIZE.y)
  self.entities = self:GenerateEntities(10)
  self.objects = {}
  self.doorways = self:GenerateDoorways()
  self.player = player
  self.renderOffset = MAP_RENDER_OFFSET
end

function Room:update(dt)
  for k, entity in pairs(self.entities) do
    entity:update(dt)
  end
  
  -- check for collisions between the player and the entities within the room
  if self.player.components['Collider'] then
    playerCollider = self.player.components['Collider'][1]
    for k, entity in pairs(self.entities) do
      if entity.components['Collider'] and playerCollider:collides(entity.components['Collider'][1]) then
        -- decrement player's health and apply cooldown to the player's vulnerability
        if self.player.components['Script']['PlayerController'] then
          playerController = self.player.components['Script']['PlayerController']
          if not playerController.invulnerable then
            playerController:damage(1)
            -- if the player dies, transition to game over scene
            if playerController.health <= 0 then
              sceneManager:change('GameOver')
            end
          end
        end
      end
    end
  end
end

function Room:render()
  for y = 1, self.size.y do
    for x = 1, self.size.x do
      local tile = self.tiles[y][x]
      love.graphics.draw(TEXTURES['tiles'], FRAMES['tiles'][tile.id],
        (x - 1) * TILE_SIZE + self.renderOffset.x,
        (y - 1) * TILE_SIZE + self.renderOffset.y)
    end
  end
  
  for k, doorway in pairs(self.doorways) do
    doorway:render()
  end
  
  for k, entity in pairs(self.entities) do
    entity:render()
  end
end

function Room:CreateEntity(entityType)
  local posX = math.random(MAP_RENDER_OFFSET.x + TILE_SIZE + 8, MAP_RENDER_OFFSET.x + MAP_SIZE.x * TILE_SIZE - TILE_SIZE - 8)
  local posY = math.random(MAP_RENDER_OFFSET.y + TILE_SIZE + 8, MAP_RENDER_OFFSET.y + MAP_SIZE.y * TILE_SIZE - TILE_SIZE - 8)
  local entity = tiny.Entity(posX, posY)
  local entitySprite
  
  -- sprite component
  if entityType == 'skeleton' then
    entitySprite = tiny.Sprite(TEXTURES['entities'], FRAMES['skeleton-move-down'][2])
  elseif entityType == 'slime' then
    entitySprite = tiny.Sprite(TEXTURES['entities'], FRAMES['slime-move-down'][2])
  elseif entityType == 'bat' then
    entitySprite = tiny.Sprite(TEXTURES['entities'], FRAMES['bat-move-down'][2])
  elseif entityType == 'ghost' then
    entitySprite = tiny.Sprite(TEXTURES['entities'], FRAMES['ghost-move-down'][2])
  elseif entityType == 'spider' then
    entitySprite = tiny.Sprite(TEXTURES['entities'], FRAMES['spider-move-down'][2])
  end
  entitySprite = tiny.Sprite(TEXTURES['entities'], FRAMES[entityType .. '-move-down'][2])
  entity:AddComponent(entitySprite)
  
  -- setup entity speed depending on its type
  local speedSkeleton = 25
  local speedSlime = 35
  local speedBat = 45
  local speedGhost = 50
  local speedSpider = 60
  
  entityController = entity:AddScript('EntityController')
  if entityType == 'skeleton' then
    entityController.speed = math.random() + math.random(4) + speedSkeleton
  elseif entityType == 'slime' then
    entityController.speed = math.random() + math.random(4) + speedSlime
  elseif entityType == 'bat' then
    entityController.speed = math.random() + math.random(4) + speedBat
  elseif entityType == 'ghost' then
    entityController.speed = math.random() + math.random(4) + speedGhost
  elseif entityType == 'spider' then
    entityController.speed = math.random() + math.random(4) + speedSpider
  end
  
  -- create animator controller and setup parameters
  local entityAnimatorController = tiny.AnimatorController('EntityAnimatorController')
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
  
  local movingFrameDuration = 0.3
  
  stateIdleDown.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-down'][2])
  stateIdleUp.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-up'][2])
  stateIdleLeft.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-left'][2])
  stateIdleRight.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-right'][2])

  stateMovingDown.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-down'][1], movingFrameDuration)
  stateMovingDown.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-down'][2], movingFrameDuration)
  stateMovingDown.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-down'][3], movingFrameDuration)
  stateMovingDown.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-down'][2], movingFrameDuration)

  stateMovingUp.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-up'][1], movingFrameDuration)
  stateMovingUp.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-up'][2], movingFrameDuration)
  stateMovingUp.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-up'][3], movingFrameDuration)
  stateMovingUp.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-up'][2], movingFrameDuration)

  stateMovingLeft.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-left'][1], movingFrameDuration)
  stateMovingLeft.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-left'][2], movingFrameDuration)
  stateMovingLeft.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-left'][3], movingFrameDuration)
  stateMovingLeft.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-left'][2], movingFrameDuration)

  stateMovingRight.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-right'][1], movingFrameDuration)
  stateMovingRight.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-right'][2], movingFrameDuration)
  stateMovingRight.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-right'][3], movingFrameDuration)
  stateMovingRight.animation:AddFrame(TEXTURES['entities'], FRAMES[entityType .. '-move-right'][2], movingFrameDuration)
  
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

  -- add collider
  local collider
  if entityType == 'skeleton' then
    collider = tiny.Collider { center = tiny.Vector2D(0, 1), size = ENTITY_SIZE - tiny.Vector2D(8, 1) }
  elseif entityType == 'slime' then
    collider = tiny.Collider { center = tiny.Vector2D(0, 2), size = ENTITY_SIZE - tiny.Vector2D(2, 6) }
  elseif entityType == 'bat' then
    collider = tiny.Collider { center = tiny.Vector2D(0, -2), size = ENTITY_SIZE - tiny.Vector2D(6, 6) }
  elseif entityType == 'ghost' then
    collider = tiny.Collider { center = tiny.Vector2D(0, -1), size = ENTITY_SIZE - tiny.Vector2D(6, 4) }
  elseif entityType == 'spider' then
    collider = tiny.Collider { center = tiny.Vector2D(0, 3), size = ENTITY_SIZE - tiny.Vector2D(6, 6) }
  end
  entity:AddComponent(collider)

  return entity
end

function Room:GenerateDoorways()
  local directions = {'left', 'right', 'top', 'bottom'}
  local doorways = {}
  
  for k, direction in pairs(directions) do
    local doorway
    table.insert(doorways, Doorway(direction, false))
  end
  
  return doorways
end

function Room:GenerateEntities(n)
  local entityTypes = {'skeleton', 'slime', 'bat', 'ghost', 'spider'}
  local entities = {}
  
  for i = 1, n do
    local entityType = entityTypes[math.random(#entityTypes)]
    local entity = self:CreateEntity(entityType)
    table.insert(entities, entity)
  end
  
  return entities
end

function Room:GenerateObjects()
end

function Room:GenerateTileset(width, height)
  local tiles = {}
  
  for y = 1, height do
    table.insert(tiles, {})
    
    for x = 1, width do
      local id = TILE_EMPTY
      
      if x == 1 and y == 1 then
        id = TILE_TOP_LEFT_CORNER
      elseif x == 1 and y == height then
        id = TILE_BOTTOM_LEFT_CORNER
      elseif x == width and y == 1 then
        id = TILE_TOP_RIGHT_CORNER
      elseif x == width and y == height then
        id = TILE_BOTTOM_RIGHT_CORNER
      elseif x == 1 then
        id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
      elseif x == width then
        id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
      elseif y == 1 then
        id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
      elseif y == height then
        id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
      else
        id = TILE_FLOORS[math.random(#TILE_FLOORS)]
      end
      
      table.insert(tiles[y], { id = id })
    end
  end
  
  return tiles
end