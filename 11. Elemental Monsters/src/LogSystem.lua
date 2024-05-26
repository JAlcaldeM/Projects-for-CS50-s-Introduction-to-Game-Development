LogSystem = Class{}

function LogSystem:init(def)
  
  --[[
  self.logx = def.logx
  self.log1y = def.log1y
  self.log2y = def.log2y
  self.logHeight = def.logHeight
  self.log1Width = def.log1Width
  self.log2Width = def.log2Width
  
  self.monster1 = def.monster1
  self.monster2 = def.monster2
  
  
  self.monster1.logValue = 1
  self.monster2.logValue = 2
  
  self.logTime = 1
  ]]
  
  logs = {}
  
  logsInfo = {
    logx = def.logx,
    log1y = def.log1y,
    log2y = def.log2y,
    logHeight = def.logHeight,
    log1Width = def.log1Width,
    log2Width = def.log2Width,
    
    monster1 = def.monster1,
    monster2 = def.monster2,
  }
  
  logTime = 1
  
  logsInfo.monster1.logValue = 1
  logsInfo.monster2.logValue = 2


end

function LogSystem:update(dt)
  for i, log in ipairs(logs) do
    if log.timer and tonumber(log.timer) then
      log.timer = log.timer - dt
      if log.timer < 0 then
        logs[i] = '-'
      end
    end
  end
end


function LogSystem:render()
  for i, log in ipairs(logs) do
    if log and log.timer then
      log:render()
    end
  end
end

function LogSystem:newLog(monster, text, color, timerType)

  local logPos = #logs + 1
  local timer = timerType or 'default'
  
  local panelColor = color
  if (not panelColor) or panelColor == 'default' then
    panelColor = palette[9]
  end
  
  
  local panelx = logsInfo.logx
  local panely
  local panelWidth
  local panelHeight = logsInfo.logHeight
  if monster.logValue == 1 then
    panely = logsInfo.log1y
    panelWidth = logsInfo.log1Width
  elseif monster.logValue == 2 then
    panely = logsInfo.log2y
    panelWidth = logsInfo.log2Width
  end
  
  local panel = Panel{
    x = panelx,
    y = panely,
    width = panelWidth,
    height = panelHeight,
    value = text or 'noLogTextProvided',
    font = gFonts['medium'],
    alignment = 'left',
    offset = 10*scale,
    fontOffset = 32*scale,
    color1 = panelColor,
    centered = false,
    
  }
  
  if timer == 'default' then
    panel.timer = logTime
  else
    panel.timer = true
  end
  

  logs[logPos] = panel
  
  return logPos

end
