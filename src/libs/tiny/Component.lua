local Component = Class{}

function Component:init()
  self.enabled = true
  self.entity = nil
end

function Component:update(dt)
end

return Component