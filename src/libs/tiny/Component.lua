local Component = Class{}

function Component:init(parent)
  self.enabled = true
  self.entity = nil
end

function Component:update(dt)
end

return Component