Animation = Class{}

function Animation:init(name, frames, interval)
  self.name = name
  self.frames = frames
  self.interval = interval
  self.timer = 0
  self.currentFrame = 1
end

function Animation:update(dt)
  -- no need to update if animation is only one frame
  if #self.frames > 1 then
    self.timer = self.timer + dt
    if self.timer > self.interval then
      self.timer = self.timer % self.interval
      self.currentFrame = math.max(1, (self.currentFrame + 1) % (#self.frames + 1))
    end
  end
end
