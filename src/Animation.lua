Animation = Class{}

function Animation:init(name)
  self.name = name
  self.frames = {}
  --self.interval = 0
  self.timer = 0
  self.frameTimer = 0
  self.currentFrame = 1
  self.duration = 0
end

function Animation:update(dt)
  -- no need to update if animation is only one frame
  if #self.frames > 1 then
    self.timer = self.timer + dt
    self.frameTimer = self.frameTimer + dt
    if self.frameTimer > self.frames[self.currentFrame].duration then
      self.frameTimer = self.frameTimer % self.frames[self.currentFrame].duration
      self.currentFrame = math.max(1, (self.currentFrame + 1) % (#self.frames + 1))
    end
  end
end

function Animation:AddFrame(texture, quad, duration)
  local frame = AnimationFrame(texture, quad, duration)
  if duration then
    self.duration = self.duration + duration
  end
  table.insert(self.frames, frame)
end

function Animation:Reset()
  self.timer = 0
  self.frameTimer = 0
  self.currentFrame = 1
end