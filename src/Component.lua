Component = Class{}

function Component:init(def)
  self.enabled = def.enabled
  self.parent = def.parent
end

function Component:update(dt)
end
