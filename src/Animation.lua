Animation = Class{}

function Animation:init(name)
  self.name = name
  self.frames = {}
  self.interval = interval
  self.timer = 0
  self.currentFrame = 1
end

function Animation:update(dt)
  -- no need to update if animation is only one frame
  if #self.frames > 1 then
    self.timer = self.timer + dt
    if self.timer > self.frames[self.currentFrame].duration then
      self.timer = self.timer % self.frames[self.currentFrame].duration
      self.currentFrame = math.max(1, (self.currentFrame + 1) % (#self.frames + 1))
    end
  end
end

function Animation:AddFrame(texture, quad, duration)
  local frame = AnimationFrame(texture, quad, duration)
  table.insert(self.frames, frame)
end