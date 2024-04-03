--[[
    GD50
    Super Mario Bros. Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Helper functions for writing Match-3.
]]

--[[
    Given an "atlas" (a texture with multiple sprites), as well as a
    width and a height for the tiles therein, split the texture into
    all of the quads by simply dividing it evenly.
]]
function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

function stencilClear()
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end


function updateResolution(lowresModifier)
      sizeFactor = lowresModifier*sizeFactor
      VIRTUAL_WIDTH = lowresModifier*VIRTUAL_WIDTH
      VIRTUAL_HEIGHT = lowresModifier*VIRTUAL_HEIGHT
      shadowDistance = sizeFactor/5
end

function reverseParts(chimera)
  local newParts = {}
  for i = #chimera.parts, 1, -1 do
    local cell = chimera.parts[i]
    
    if not cell.reversed then
      cell.x = -cell.x
      cell.x0 = -cell.x0
      if cell.shadowX then
        cell.shadowX = -cell.shadowX
      end
      cell.ang = - cell.ang
      cell.startAng = - cell.startAng
      
      cell.reversed = true
    end

    table.insert(newParts, cell)
  end
  chimera.parts = newParts
  
  for _, cell in pairs(chimera.parts) do
    reverseParts(cell)
  end
  
end

function changeAnimation(chimera, animation)
  
  if animation == 'default' then
    for _, cell in pairs(chimera.parts) do
      cell.ang = cell.startAng
    end
  else
    local newAnimation = animations[animation]
    for _, cell in pairs(chimera.parts) do
      cell.ang = newAnimation[cell.name]
      if cell.ang == nil then
        cell.ang = cell.startAng
      elseif not cell.chimera.frontalCamera then
        cell.ang = -cell.ang
      end
    end
  end

end

function changeMouth(chimera)
  for _, cell in pairs(chimera.parts) do
    if cell.name == 'mouth' then
      local mouthSizeRatio = 0.8
      if not cell.open then
        cell.rx = cell.rx*mouthSizeRatio 
        cell.ry = cell.ry*mouthSizeRatio 
        cell.snout.ry = cell.snout.ry * 1/5
        cell.snout.yCenter = cell.snout.yCenter * 1/5
        cell.open = true
      else
        cell.rx = cell.rx/mouthSizeRatio 
        cell.ry = cell.ry/mouthSizeRatio 
        cell.snout.ry = cell.snout.ry * 5
        cell.snout.yCenter = cell.snout.yCenter * 5
        cell.open = false
      end
    end
  end
end
