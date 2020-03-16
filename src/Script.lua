Script = Class{__includes = Component}

function Script:init(name)
  Component.init(self)
  self.name = name
  self.componentType = 'Script'
end

function Script:update(dt)
  
end