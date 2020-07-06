local current_folder = (...):gsub('%.Script$', '') -- "my package path"
local Component = require(current_folder .. '.Component')

local Script = Class{__includes = Component}

function Script:init(name)
  Component.init(self)
  self.name = name
  self.componentType = 'Script'
end

function Script:update(dt)
  
end

return Script