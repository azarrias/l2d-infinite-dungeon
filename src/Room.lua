Room = Class{}

function Room:init(player, shift)
  self.size = MAP_SIZE
  self.tiles = self:GenerateTileset(MAP_SIZE.x, MAP_SIZE.y)
  -- shifting distance for transitioning between rooms
  self.shift = shift or tiny.Vector2D(0, 0)
  self.entities = self:GenerateEntities(10)
  self.doorSwitch = self:CreateDoorSwitch()
  self.doorways = self:GenerateDoorways()
  self.player = player
  self.renderOffset = MAP_RENDER_OFFSET
end

function Room:update(dt)
  for k, entity in pairs(self.entities) do
    entity:update(dt)
  end
  
  -- check for collisions between the player and the entities within the room
  if self.player.components['Script']['PlayerController'] then
    playerController = self.player.components['Script']['PlayerController']
    if playerController.bodyCollider then
      for k, entity in pairs(self.entities) do
        if entity.components['Collider'] and entity.components['Collider'][1] then
          -- decrement player's health and apply cooldown to the player's vulnerability
          if playerController.bodyCollider:Collides(entity.components['Collider'][1]) then
            if not playerController.invulnerable then
              playerController:damage(1)
              SOUNDS['hit-player']:play()
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
  
  -- check for collisions between the player's sword and the entities in the room
  if self.player.components['Script']['PlayerController'] then
    playerController = self.player.components['Script']['PlayerController']
    -- only check if there is an active attack collider
    if playerController.attackCollider then
      for k, entity in pairs(self.entities) do
        if entity.components['Collider'] and playerController.attackCollider:Collides(entity.components['Collider'][1]) then
          SOUNDS['hit-enemy']:play()
          table.remove(self.entities, k)
        end
      end
    end
  else
    error("Cannot find the PlayerController script component")
  end
  
  -- check for collisions between the player and the door switches in the room
  if self.player.components['Script']['PlayerController'] then
    playerController = self.player.components['Script']['PlayerController']
    if playerController.bodyCollider then
      if self.doorSwitch.components['Collider'] and self.doorSwitch.components['Collider'][1] then
        -- open doors if the switch has not been already used
        if playerController.bodyCollider:Collides(self.doorSwitch.components['Collider'][1]) then
          self:OpenDoors()
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
        (x - 1) * TILE_SIZE + self.renderOffset.x + self.shift.x,
        (y - 1) * TILE_SIZE + self.renderOffset.y + self.shift.y)
    end
  end
  
  for k, doorway in pairs(self.doorways) do
    doorway:render()
  end
  
  self.doorSwitch:render()
  
  for k, entity in pairs(self.entities) do
    entity:render()
  end
  
  -- stencil out the door arches so it looks like the player is going through
  love.graphics.stencil(function()
    -- left
    love.graphics.rectangle('fill', -TILE_SIZE - 4, VIRTUAL_SIZE.y / 2 - 2 * TILE_SIZE,
      TILE_SIZE * 2.5, TILE_SIZE * 3)  
    -- right  
    love.graphics.rectangle('fill', VIRTUAL_SIZE.x - TILE_SIZE - 4, VIRTUAL_SIZE.y / 2 - 2 * TILE_SIZE,
      TILE_SIZE * 2.5, TILE_SIZE * 3)  
    -- top
    love.graphics.rectangle('fill', VIRTUAL_SIZE.x / 2 - TILE_SIZE, -1.5 * TILE_SIZE,
      TILE_SIZE * 2, TILE_SIZE * 3)  
    -- bottom
    love.graphics.rectangle('fill', VIRTUAL_SIZE.x / 2 - TILE_SIZE, VIRTUAL_SIZE.y - 1.5 * TILE_SIZE,
      TILE_SIZE * 2, TILE_SIZE * 3)     
  end, 'replace', 1)

  love.graphics.setStencilTest('less', 1)
  
  if self.player then
      self.player:render()
  end

  love.graphics.setStencilTest()
end

function Room:CreateDoorSwitch()
  local posX = math.random(MAP_RENDER_OFFSET.x + TILE_SIZE + 8, MAP_RENDER_OFFSET.x + MAP_SIZE.x * TILE_SIZE - TILE_SIZE - 8)
  local posY = math.random(MAP_RENDER_OFFSET.y + TILE_SIZE + 8, MAP_RENDER_OFFSET.y + MAP_SIZE.y * TILE_SIZE - TILE_SIZE - 8)
  local doorSwitch = tiny.Entity(posX + self.shift.x, posY + self.shift.y)
  
  local switchSprite = tiny.Sprite(TEXTURES['switches'], FRAMES['switches'][2])
  doorSwitch:AddComponent(switchSprite)
  
  local collider = tiny.Collider(tiny.Vector2D(0, 0), SWITCH_SIZE)
  doorSwitch:AddComponent(collider)
  
  return doorSwitch
end

function Room:CreateEntity(entityType)
  local posX = math.random(MAP_RENDER_OFFSET.x + TILE_SIZE + 8, MAP_RENDER_OFFSET.x + MAP_SIZE.x * TILE_SIZE - TILE_SIZE - 8)
  local posY = math.random(MAP_RENDER_OFFSET.y + TILE_SIZE + 8, MAP_RENDER_OFFSET.y + MAP_SIZE.y * TILE_SIZE - TILE_SIZE - 8)
  local entity = tiny.Entity(posX + self.shift.x, posY + self.shift.y)
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
  entityAnimatorController:AddParameter('MoveDown', tiny.AnimatorControllerParameterType.Bool)
  entityAnimatorController:AddParameter('MoveUp', tiny.AnimatorControllerParameterType.Bool)
  entityAnimatorController:AddParameter('MoveLeft', tiny.AnimatorControllerParameterType.Bool)
  entityAnimatorController:AddParameter('MoveRight', tiny.AnimatorControllerParameterType.Bool)
  
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

  -- add collider
  local collider
  if entityType == 'skeleton' then
    collider = tiny.Collider(tiny.Vector2D(0, 1), ENTITY_SIZE - tiny.Vector2D(8, 1))
  elseif entityType == 'slime' then
    collider = tiny.Collider(tiny.Vector2D(0, 2), ENTITY_SIZE - tiny.Vector2D(2, 6))
  elseif entityType == 'bat' then
    collider = tiny.Collider(tiny.Vector2D(0, -2), ENTITY_SIZE - tiny.Vector2D(6, 6))
  elseif entityType == 'ghost' then
    collider = tiny.Collider(tiny.Vector2D(0, -1), ENTITY_SIZE - tiny.Vector2D(6, 4))
  elseif entityType == 'spider' then
    collider = tiny.Collider(tiny.Vector2D(0, 3), ENTITY_SIZE - tiny.Vector2D(6, 6))
  end
  entity:AddComponent(collider)

  return entity
end

function Room:GenerateDoorways()
  local directions = {'left', 'right', 'top', 'bottom'}
  local doorways = {}
  
  for k, direction in pairs(directions) do
    local doorway
    table.insert(doorways, Doorway(direction, self.shift))
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

function Room:OpenDoors()
  for i, doorway in pairs(self.doorways) do
    doorway.isOpen = true
    -- add a collider for the doorway's game object
    local pos
    if i == 1 then --left
      pos = tiny.Vector2D(15 * TILE_SIZE / 8, 5 * TILE_SIZE / 4)
    elseif i == 2 then --right
      pos = tiny.Vector2D(TILE_SIZE / 8, 5 * TILE_SIZE / 4)
    elseif i == 3 then --top
      pos = tiny.Vector2D(TILE_SIZE, 31 * TILE_SIZE / 16)
    elseif i == 4 then --bottom
      pos = tiny.Vector2D(TILE_SIZE, TILE_SIZE / 8)
    end
    local collider = tiny.Collider(pos, tiny.Vector2D(TILE_SIZE / 4, TILE_SIZE / 4))
    doorway.gameObject:AddComponent(collider)
  end
  local sprite = self.doorSwitch.components['Sprite']
  if sprite then
    self.doorSwitch:RemoveComponent(sprite)
  end
  -- remove the switch collider and 'closed switch' sprite and add the 'opened switch' sprite
  self.doorSwitch:RemoveComponent(self.doorSwitch.components['Collider'][1])
  sprite = tiny.Sprite(TEXTURES['switches'], FRAMES['switches'][1])
  self.doorSwitch:AddComponent(sprite)
  SOUNDS['door']:play()
end