local current_folder = (...):gsub('%.Entity$', '') -- "my package path"
local Vector2D = require(current_folder .. '.Vector2D')

local Entity = Class{}

function Entity:init(posX, posY, rotation, scaleX, scaleY)
  self.parent = nil
  self.enabled = true
  
  -- transforms in local space
  self.position = Vector2D(posX, posY)
  self.rotation = rotation or 0
  self.scale = scaleX and scaleY and Vector2D(scaleX, scaleY) or Vector2D(1, 1)
  
  self.components = {}
end

function Entity:update(dt)
  for k, componentType in pairs(self.components) do
    if k == 'AnimatorController' or k == 'Sprite' then
      componentType:update(dt)
    else
      for i, component in pairs(componentType) do
        component:update(dt)
      end
    end
  end
end

function Entity:render()
  if self.components['Sprite'] and self.enabled then
    self.components['Sprite']:render()
  end
  
  if DEBUG_MODE and self.components['Collider'] then
    for k, collider in pairs(self.components['Collider']) do
      collider:render()
    end
  end
end

function Entity:AddComponent(component)
  component.entity = self
  -- overwrite components if their type only allows one instance per entity
  if component.componentType == 'AnimatorController' or
    component.componentType == 'Sprite' then
    self.components[component.componentType] = component
  else
    if self.components[component.componentType] == nil or next(self.components[component.componentType]) == nil then
      self.components[component.componentType] = {}
    end
    if component.name then
      self.components[component.componentType][component.name] = component
    else
      table.insert(self.components[component.componentType], component)
    end
  end
  
  return component
end

function Entity:AddScript(scriptName)
  -- generates anonymous function that returns an instance of the script subclass
  local f = loadstring("return " .. scriptName .. "()")
  if f then
    local script = f()
    self:AddComponent(script)
    return script
  else
    error("Object '"..scriptName.."' does not exist or is not accessible.")
  end
end

function Entity:GetComponentIndex(component)
  if self.components[component.componentType] then
    for idx, comp in pairs(self.components[component.componentType]) do
      if comp == component then
        return idx
      end
    end
  end
  error("Component '"..component.."' does not exist or is not accessible.")
end

function Entity:RemoveComponent(component)
  if component.componentType == 'AnimatorController' or component.componentType == 'Sprite' then
    self.components[component.componentType] = nil
  else
    local index = self:GetComponentIndex(component)
    if index then
      table.remove(self.components[component.componentType], index)
    end
  end
end

return Entity
