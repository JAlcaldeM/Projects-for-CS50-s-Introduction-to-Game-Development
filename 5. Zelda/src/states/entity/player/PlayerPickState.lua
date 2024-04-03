PlayerPickState = Class{__includes = PlayerIdleState}

function PlayerPickState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon
    
    self.player.objectPicked = false
    
    self.timeFrame = 0.1

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

    -- create hitbox based on where the player is and facing
    local direction = self.player.direction
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    if direction == 'left' then
        hitboxWidth = 4
        hitboxHeight = 12
        hitboxX = self.player.x - hitboxWidth
        hitboxY = self.player.y + self.player.height - hitboxHeight
    elseif direction == 'right' then
        hitboxWidth = 4
        hitboxHeight = 12
        hitboxX = self.player.x + self.player.width
        hitboxY = self.player.y + self.player.height - hitboxHeight
    elseif direction == 'up' then
        hitboxWidth = 12
        hitboxHeight = 4
        hitboxX = self.player.x + self.player.width/2 - hitboxWidth/2
        hitboxY = self.player.y - hitboxHeight
    else
        hitboxWidth = 12
        hitboxHeight = 4
        hitboxX = self.player.x + self.player.width/2 - hitboxWidth/2
        hitboxY = self.player.y + self.player.height
    end

    self.pickHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)

    self.player:changeAnimation('pick-' .. self.player.direction)
    
    local somethingPicked = false

    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object.pickable and (not object.destroyed) and object:collides(self.pickHitbox) and not somethingPicked then
          self.player.objectPicked = object
          somethingPicked = true
        end
    end
    
    if somethingPicked then
      self.player.objectPicked.solid = false
      self:pickObjectAnimation()
    else
      Timer.after(self.timeFrame,
        function ()
          self.player:changeState('idle')
        end)
    end

end

function PlayerPickState:enter(params)

    gSounds['pick']:stop()
    gSounds['pick']:play()

    self.player.currentAnimation:refresh()
end

function PlayerPickState:update(dt)

    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('pickidle')
        
    end
    
end

function PlayerPickState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))


    --[[
    love.graphics.setColor(255, 0, 255, 255)
    love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    love.graphics.rectangle('line', self.pickHitbox.x, self.pickHitbox.y,
        self.pickHitbox.width, self.pickHitbox.height)
    love.graphics.setColor(255, 255, 255, 255)
    ]]
end

function PlayerPickState:pickObjectAnimation()
  
  local player = self.player
  local object = player.objectPicked
  local direction = player.direction
  
  local x1, x2, x3, y1, y2, y3 = 0, 0, 0, 0, 0, 0
  
  if direction == 'up' then
    x1, x2, x3, y1, y2, y3 = player.x, player.x, player.x, player.y + 7, player.y + 4, player.y + 1
  elseif direction == 'down' then
    object.picking = true
    x1, x2, x3, y1, y2, y3 = player.x, player.x, player.x, player.y + 23, player.y + 11, player.y - 1 
  elseif direction == 'left' then
    x1, x2, x3, y1, y2, y3 = player.x - 8, player.x - 11, player.x, player.y + 12, player.y + 7, player.y + 3
  elseif direction == 'right' then
    x1, x2, x3, y1, y2, y3 = player.x + 8, player.x + 11, player.x, player.y + 12, player.y + 7, player.y + 3 
  end
  
  object.x = x1
  object.y = y1
  Timer.after(self.timeFrame,
    function ()
      object.x = x2
      object.y = y2
      Timer.after(self.timeFrame,
        function ()
          object.x = x3
          object.y = y3
          self.player.objectPicked.picked = true
        end)
    end)
  
end

