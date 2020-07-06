local current_folder = (...):gsub('%.AnimatorStateTransition$', '') -- "my package path"
local AnimatorCondition = require(current_folder .. '.AnimatorCondition')

local AnimatorStateTransition = Class{}

function AnimatorStateTransition:init(state)
  self.destinationState = state
  self.conditions = {}
  
  -- earliest time at which the transition can take effect
  -- represented in normalized time (current animation % played)
  self.exitTime = 0
end

function AnimatorStateTransition:AddCondition(parameter, operator, value)
  local condition = AnimatorCondition(parameter, operator, value)
  table.insert(self.conditions, condition)
end

return AnimatorStateTransition