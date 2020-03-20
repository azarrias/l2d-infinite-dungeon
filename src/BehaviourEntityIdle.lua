BehaviourEntityIdle = Class{__includes = StateMachineBehaviour}

function BehaviourEntityIdle:init()
  self.name = 'BehaviourEntityIdle'
  StateMachineBehaviour.init(self)
  
  -- used for AI waiting
  self.waitDuration = 0
  self.waitTimer = 0  
end

function BehaviourEntityIdle:OnStateUpdate(dt, animatorController)
  if self.waitDuration == 0 then
    self.waitDuration = math.random(5)
  else
    self.waitTimer = self.waitTimer + dt
    
    if self.waitTimer > self.waitDuration then
      local parameters = { 'MoveDown', 'MoveUp', 'MoveLeft', 'MoveRight' }
      animatorController:SetValue(parameters[math.random(#parameters)], true)
    end
  end
end
