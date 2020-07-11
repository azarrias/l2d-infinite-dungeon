BehaviourPlayerMovingDown = Class{__includes = tiny.StateMachineBehaviour}

function BehaviourPlayerMovingDown:init()
  self.name = 'BehaviourPlayerMovingDown'
  tiny.StateMachineBehaviour.init(self)
end

function BehaviourPlayerMovingDown:OnStateEnter(dt, animatorController)
end

function BehaviourPlayerMovingDown:OnStateExit(dt, animatorController)
end

function BehaviourPlayerMovingDown:OnStateUpdate(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  local bounds = MAP_RENDER_OFFSET.y + MAP_SIZE.y * TILE_SIZE - TILE_SIZE
  
  entity.position.y = entity.position.y + playerController.speed * dt
  
  -- check if there is a collision with the doorway to this side (if it is open)
  -- doorway index is defined in Room:GenerateDoorways()
  -- {'left', 'right', 'top', 'bottom'}
  local doorway = playerController.dungeon.currentRoom.doorways[4]
  
  if playerController.bodyCollider then
    if doorway.gameObject.components['Collider'] and doorway.gameObject.components['Collider'][1] then
      -- temporary shift to check collision
      entity.position.y = entity.position.y + playerController.speed * dt
      if playerController.bodyCollider:collides(doorway.gameObject.components['Collider'][1]) then
        -- dispatch event to make a shift to a new room
        -- event will be triggered in Dungeon:init
        Event.dispatch('shift-down')
      end
      -- restore position after checking collision
      entity.position.y = entity.position.y - playerController.speed * dt
    end
  end  
  
  -- if there is no collision, make sure that player stays within bounds
  if entity.position.y + 11 >= bounds then
    entity.position.y = bounds - 11
  end
end