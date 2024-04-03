
LevelupStatsState = Class{__includes = BaseState}

function LevelupStatsState:init(text, callback)
  self.type = 'LevelupStats'
    self.textbox = Textbox(VIRTUAL_WIDTH - 120, VIRTUAL_HEIGHT - 60, 120, 60, text, gFonts['small'])
    self.callback = callback or function() end
end

function LevelupStatsState:update(dt)
    self.textbox:update(dt)

    if self.textbox:isClosed() then
        self.callback()
        gStateStack:pop()
    end
end

function LevelupStatsState:render()
    self.textbox:render()
end