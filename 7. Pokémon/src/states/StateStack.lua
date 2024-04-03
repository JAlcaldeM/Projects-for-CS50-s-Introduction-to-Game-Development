--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

StateStack = Class{}

function StateStack:init()
    self.states = {}
end

function StateStack:update(dt)
    self.states[#self.states]:update(dt)
end

function StateStack:processAI(params, dt)
    self.states[#self.states]:processAI(params, dt)
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

-- custom function added to fix some problems with transitions so is not required to pop each state individually (which if not done correctly could make the game get locked in a state)
function StateStack:popUntil(type)
  
  local upperType = self.states[#self.states].type
  
  while not (upperType == type) do
    self.states[#self.states]:exit()
    table.remove(self.states)
    upperType = self.states[#self.states].type
  end
  
end