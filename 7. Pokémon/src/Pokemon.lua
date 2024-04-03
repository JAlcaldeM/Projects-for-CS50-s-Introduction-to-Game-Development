--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Pokemon = Class{}

function Pokemon:init(def, level)
  
  if random then
    
    
    self.name = self:generateName()
    
    self.seed = math.random(1, 2^40)

    self.baseHP = math.random(10,15)
    self.baseAttack = math.random(5,10)
    self.baseDefense = math.random(3,5)
    self.baseSpeed = math.random(5,10)

    self.HPIV = math.random(2,5)
    self.attackIV = math.random(2,5)
    self.defenseIV = math.random(2,5)
    self.speedIV = math.random(2,5)
    
  else
    self.name = def.name

    self.battleSpriteFront = def.battleSpriteFront
    self.battleSpriteBack = def.battleSpriteBack

    self.baseHP = def.baseHP
    self.baseAttack = def.baseAttack
    self.baseDefense = def.baseDefense
    self.baseSpeed = def.baseSpeed

    self.HPIV = def.HPIV
    self.attackIV = def.attackIV
    self.defenseIV = def.defenseIV
    self.speedIV = def.speedIV

end

  self.HP = self.baseHP
  self.attack = self.baseAttack
  self.defense = self.baseDefense
  self.speed = self.baseSpeed
  
  self.level = level
  self.currentExp = 0
  self.expToLevel = self.level * self.level * 5 * 0.75

  self:calculateStats()

  self.currentHP = self.HP
 
end

function Pokemon:calculateStats()
    for i = 1, self.level do
        self:statsLevelUp()
    end
end

function Pokemon.getRandomDef()
    return POKEMON_DEFS[POKEMON_IDS[math.random(#POKEMON_IDS)]]
end

--[[
    Takes the IV (individual value) for each stat into consideration and rolls
    the dice 3 times to see if that number is less than or equal to the IV (capped at 5).
    The dice is capped at 6 just so no stat ever increases by 3 each time, but
    higher IVs will on average give higher stat increases per level. Returns all of
    the increases so they can be displayed in the TakeTurnState on level up.
]]
function Pokemon:statsLevelUp()
    local HPIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.HPIV then
            self.HP = self.HP + 1
            if self.currentHP then
              self.currentHP = self.currentHP + 1
            end
            HPIncrease = HPIncrease + 1
        end
    end

    local attackIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.attackIV then
            self.attack = self.attack + 1
            attackIncrease = attackIncrease + 1
        end
    end

    local defenseIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.defenseIV then
            self.defense = self.defense + 1
            defenseIncrease = defenseIncrease + 1
        end
    end

    local speedIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.speedIV then
            self.speed = self.speed + 1
            speedIncrease = speedIncrease + 1
        end
    end

    return HPIncrease, attackIncrease, defenseIncrease, speedIncrease
end

function Pokemon:levelUp()
    self.level = self.level + 1
    self.currentExp = 0
    self.expToLevel = self.level * self.level * 5 * 0.75

    return self:statsLevelUp()
end

function Pokemon:generateName()
  
  local syllabNumber = 1 + math.floor((math.random(2)+math.random(2))/2)
  
  local consonants = {"b", "b", "c", "c", "c", "d", "d", "d", "f", "g", "h", "j", "k", "l", "l", "l", "m", "m", "n", "n", "n", "p", "p", "p", "q", "r", "r", "r", "s", "s", "s", "t", "t", "t", "v", "w", "x", "y", "z"}
  local vowels = {"a","a","a", "e", "e", "e", "i", "i", "o", "o", "u"}
  
  local name = ''
  
  for i = 1, syllabNumber do
    local syllab = ''
    if math.random() < 0.5 then
        syllab = syllab .. vowels[math.random(#vowels)]
    end
    syllab = syllab .. consonants[math.random(#consonants)]
    syllab = syllab .. vowels[math.random(#vowels)]
    if math.random() < 0.5 then
        syllab = syllab .. consonants[math.random(#consonants)]
    end
    name = name .. syllab
  end
  
  name = string.upper(string.sub(name, 1, 1)) .. string.sub(name, 2)

  return name
  
end
