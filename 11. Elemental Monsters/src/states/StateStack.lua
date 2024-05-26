StateStack = Class{}

function StateStack:init()
    self.states = {}
end

function StateStack:update(dt)
    self.states[#self.states]:update(dt)
end

function StateStack:render()
    for i, state in ipairs(self.states) do
        state:render()
    end
end

function StateStack:clear()
    self.states = {}
end

function StateStack:push(state)
    table.insert(self.states, state)
    state:enter()
end

function StateStack:pop()
    self.states[#self.states]:exit()
    table.remove(self.states)
end

function StateStack:popUntil(type)
  
  local upperType = self.states[#self.states].type
  
  while not (upperType == type) do
    self.states[#self.states]:exit()
    table.remove(self.states)
    upperType = self.states[#self.states].type
  end
  
end

function StateStack:popPrevious()
  self.states[#self.states-1]:exit()
    table.remove(self.states, #self.states-1)
  
end

function StateStack:currentType()
  return self.states[#self.states].type
end

