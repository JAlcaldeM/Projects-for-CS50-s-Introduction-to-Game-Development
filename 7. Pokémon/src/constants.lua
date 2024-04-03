--[[
    GD50
    Pokemon

    -- constants --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

TILE_SIZE = 16




-- variables for sprite generation

random = true

sizeFactor = 12

lowres = true

shadowColor = {0,0,0,0.5}
white = {1,1,1,1}
black = {0,0,0,1}
black05 = {0,0,0,0.5}
black075 = {0,0,0,0.75}
shadowDistance = sizeFactor/5

visible = true
lines = false
points = false

shadowsActive = true
directionalShadow = true
frontalCamera = true
mouthOpen = false

asymmetricAngle = true

