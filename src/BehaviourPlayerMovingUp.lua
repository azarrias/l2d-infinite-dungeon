BehaviourPlayerMovingUp = Class{__includes = tiny.StateMachineBehaviour}

function BehaviourPlayerMovingUp:init()
  self.name = 'BehaviourPlayerMovingUp'
  tiny.StateMachineBehaviour.init(self)
end

function BehaviourPlayerMovingUp:OnStateEnter(dt, animatorController)
end

function BehaviourPlayerMovingUp:OnStateExit(dt, animatorController)
end

function BehaviourPlayerMovingUp:OnStateUpdate(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  local bounds = MAP_RENDER_OFFSET.y + TILE_SIZE
  
  entity.position.y = entity.position.y - playerController.speed * dt
  
  -- check if there is a collision with the doorway to this side (if it is open)
  -- doorway index is defined in Room:GenerateDoorways()
  -- {'left', 'right', 'top', 'bottom'}
  local doorway = playerController.dungeon.currentRoom.doorways[3]
  
  if playerController.feetCollider then
    if doorway.gameObject.components['Collider'] and doorway.gameObject.components['Collider'][1] then
      -- temporary shift to check collision
      entity.position.y = entity.position.y - playerController.speed * dt
      if playerController.feetCollider:collides(doorway.gameObject.components['Collider'][1]) then
        -- dispatch event to make a shift to a new room
        -- event will be triggered in Dungeon:init
        Event.dispatch('shift-up')
      end
      -- restore position after checking collision
      entity.position.y = entity.position.y + playerController.speed * dt
    end
  end  
  
  -- if there is no collision, make sure that player stays within bounds
  if entity.position.y <= bounds then
    entity.position.y = bounds
  end
end