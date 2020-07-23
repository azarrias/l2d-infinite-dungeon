BehaviourPlayerMovingLeft = Class{__includes = tiny.StateMachineBehaviour}

function BehaviourPlayerMovingLeft:init()
  self.name = 'BehaviourPlayerMovingLeft'
  tiny.StateMachineBehaviour.init(self)
end

function BehaviourPlayerMovingLeft:OnStateEnter(dt, animatorController)
end

function BehaviourPlayerMovingLeft:OnStateExit(dt, animatorController)
end

function BehaviourPlayerMovingLeft:OnStateUpdate(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  local bounds = MAP_RENDER_OFFSET.x + TILE_SIZE
      
  entity.position.x = entity.position.x - playerController.speed * dt
  
  -- check if there is a collision with the doorway to this side (if it is open)
  -- doorway index is defined in Room:GenerateDoorways()
  --local directions = {'left', 'right', 'top', 'bottom'}
  local doorway = playerController.dungeon.currentRoom.doorways[1]
  
  if playerController.feetCollider then
    if doorway.gameObject.components['Collider'] and doorway.gameObject.components['Collider'][1] then
      -- temporary shift to check collision
      entity.position.x = entity.position.x - playerController.speed * dt
      if playerController.feetCollider:Collides(doorway.gameObject.components['Collider'][1]) then
        -- dispatch event to make a shift to a new room
        -- event will be triggered in Dungeon:init        
        Event.dispatch('shift-left')
      end
      -- restore position after checking collision
      entity.position.x = entity.position.x + playerController.speed * dt
    end
  end  
  
  -- if there is no collision, make sure that player stays within bounds
  if entity.position.x - 6 <= bounds then
    entity.position.x = bounds + 6
  end
end