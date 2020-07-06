BehaviourEntityIdle = Class{__includes = tiny.StateMachineBehaviour}

function BehaviourEntityIdle:init()
  self.name = 'BehaviourEntityIdle'
  tiny.StateMachineBehaviour.init(self)
  
  -- used for AI waiting
  self.waitDuration = 0
  self.waitTimer = 0  
end

function BehaviourEntityIdle:OnStateEnter(dt, animatorController)
  self.waitDuration = math.random() + math.random(4)
  self.waitTimer = 0
end

function BehaviourEntityIdle:OnStateExit(dt, animatorController)
end

function BehaviourEntityIdle:OnStateUpdate(dt, animatorController)
  if self.waitTimer > self.waitDuration then
    local parameters = { 'MoveDown', 'MoveUp', 'MoveLeft', 'MoveRight' }
    animatorController:SetValue(parameters[math.random(#parameters)], true)
  end
  self.waitTimer = self.waitTimer + dt
end
