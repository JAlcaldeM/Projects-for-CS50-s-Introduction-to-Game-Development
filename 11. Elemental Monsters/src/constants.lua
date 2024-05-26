
VIRTUAL_WIDTH = 1920
VIRTUAL_HEIGHT = 1080

scale = 1

pause = false

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

offset = 5*scale
offsetBig = 10*scale

comboDiv = 5

delayMult = 0.3
recoveryMult = 1

buffMultipl = 0.6
debuffMultipl = 0.8

timerList = {}

regenRate = 0.4 -- SP regen rate

peacefulEnemy = false
deathAllowed = true



decisionTime = 5

charactersAllowed = true

dtMult = 1

encounterNumber = 1

instantClose = false

showFPS = false


instructionTemplates = { -- +100
  {0},
  {100},
  
  {250, 'trait'},
  {250, 'trait', 150},
  {250, 'trait', 300},
  
  {250, 'trait', 450, 'trait'},
  {250, 'trait', 450, 'trait', 200},
  {250, 'trait', 450, 'trait', 400},
  
  {250, 'trait', 450, 'trait', 600, 'trait'},
  {250, 'trait', 450, 'trait', 600, 'trait', 300},
  
  
}





soundType = {
  ok = 'effect',
  out = 'effect',
  battleTheme = 'music',
  pow = 'effect',
  clang = 'effect',
  clong = 'effect',
  powapo = 'effect',
  megaok = 'effect',
  plin = 'effect',
  plon = 'effect',
  menuMusic = 'music',
  defeat = 'music',
  victory = 'music',
  supremeVictory = 'music',
  mainTheme = 'music',
  protected = 'effect',
  steps = 'effect',
  hehehe = 'effect',
  prang = 'effect',
  prong = 'effect',
  chomp = 'effect',
  roar = 'effect',
  hit = 'effect',
  happy = 'effect',
  cut = 'effect',
  fire = 'effect',
  electro = 'effect',
  poison = 'effect',
  ice = 'effect',
  plant = 'effect',
  metal = 'effect',
  insect = 'effect',
  mineral = 'effect',
  

}


musicLoop = {
  battleTheme = true,
  menuMusic = true,
  mainTheme = true,
  }

volumeValues = {music = 5, effect = 5}

activeSounds = {}

gMovementSounds = {
  focus = 'prang',
  bite = 'chomp',
  roar = 'roar',
  strength = 'prang',
  tackle = 'hit',
  dance = 'happy',
  coordination = 'prang',
  scratch = 'cut',
  block = 'protected',
  agility = 'prang',
  kick = 'hit',
  dodge = 'steps',
  prepare = 'prang',
  tailStrike = 'hit',
  taunt = 'hehehe',
  
  infernalFlames = 'fire',
  burningAttack = 'fire',
  flameForm = 'fire',
  
  electrify = 'electro',
  discharge = 'electro',
  charge = 'electro',
  
  concentratedPoison = 'poison',
  targetedSting = 'poison',
  hallucinogen = 'poison',
  
  deepFreeze = 'ice',
  gelidHammer = 'ice',
  icySpikes = 'ice',
  
  photosynthesis = 'plant',
  vineWhip = 'plant',
  stemGrowth = 'plant',
  
  sharpenEdges = 'metal',
  bladeAttack = 'metal',
  liquidMetal = 'metal',
  
  resistantSilk = 'insect',
  lethalAttack = 'insect',
  stickyWeb = 'insect',
  
  
  cristallize = 'mineral',
  crushingAttack = 'mineral',
  rockyCrust = 'mineral',
}

colors = {
  white = {1,1,1,1},
  black = {0,0,0,1},
  grey = {0.5,0.5,0.5,1},
  lightgrey = {0.8,0.8,0.8,1},
  red = {1,0,0,1},
  green = {0,1,0,1},
  blue = {0,0,1,1},
  yellow = {1,1,0,1},
  magenta = {1,0,1,1},
  cyan = {0,1,1,1},
  purple = {0.65,0,0.8,1},
}

local desaturationFactor = 0.25
for i, color in pairs(colors) do
  for j = 1, 3 do
    color[j] = (1-desaturationFactor)*color[j]
  end
end

colorsPure = {
  white = {1,1,1,1},
  black = {0,0,0,1},
  grey = {0.5,0.5,0.5,1},
  lightgrey = {0.8,0.8,0.8,1},
  red = {1,0,0,1},
  green = {0,1,0,1},
  blue = {0,0,1,1},
  yellow = {1,1,0,1},
  magenta = {1,0,1,1},
  cyan = {0,1,1,1},
  purple = {0.65,0,0.8,1},
}


statusIcon = {
  --attacking = 22,
  blocking = 206,
  dodging = 194,
  instructed = 190,
  deciding = 163,
  subconscious = 13,
  --recovering = 282,--232,
  recoveryhead = 281,
  recoverybody = 282,
  recoveryarms = 283,
  recoverylegs = 284,
  recoverytail = 285,
  --[[
  attack1 = 266,
  attack2 = 267,
  attack3 = 268,
  attack4 = 269,
  attack5 = 270,
  attack6 = 271,
  attack7 = 272,
  attack8 = 273,
  attack9 = 274,
  ]]

  scared = 188,
  chargeAttack = 234,
  feint = 66,
  taunted = 286,
  slowed = 288,
  weakened = 289,
  chargingAttack = 296,
  stunned = 30,
  confused = 193,
  bleeding = 299,
  motivated = 45,
  combo = 314,
  
  focused = 293,
  coordinated = 294,
  strengthened = 291,
  agilized = 292,
  prepared = 118,
  
  attack = 58,
  buff = 55,
  utility = 306, 
  
  attackCharge = 58,
  buffCharge = 55,
  utilityCharge = 306, 
  
  attackUse = 321,
  buffUse = 322,
  utilityUse = 323, 
  
  fire = 11,
  electro = 10,
  poison = 21,
  ice = 17,
  plant = 16,
  metal = 14,
  insect = 19,
  mineral = 170,
  
  firePlus = 366,
  electroPlus = 367,
  poisonPlus = 368,
  icePlus = 369,
  plantPlus = 370,
  metalPlus = 371,
  insectPlus = 372,
  mineralPlus = 373,
  
  burning = 11,
  poisoned = 21,
  webbed = 377,
  
  icySpikes = 374,
  rockyCrust = 378,
  liquidMetal = 376,
  hallucinogen = 379,
  
  instructionCD = 320,
  
}

elementPassives = {
  fire = [[Gain Fire charges periodically.
  Spend 1 Fire charge after hitting with and attack to deal damage over a short period of time.
  
  Stats: Metabolism, Intelligence
  Unlocks new movements]],
  electro = [[Gain Electro charges periodically.
  Spend 1 Electro charge after using a movement to recover 1 SP.
  
  
  Stats: Speed
  Unlocks new movements]],
  poison = [[Gain Poison charges periodically.
  Spend all your Poison charges after hitting with an attack to deal damage over a long period of time.
  
  Stats: Intelligence
  Unlocks new movements]],
  ice = [[Gain Ice charges periodically.
  Spend all your Ice charges before being hit by an attack to reducing its damage 10% for each.
  
  Stats: Size, Metabolism
  Unlocks new movements]],
  plant = [[Gain Plant charges periodically.
  Constantly heal a small amount of HP for each Plant charge.
  
  
  Stats: Metabolism
  Unlocks new movements]],
  metal = [[Gain Metal charges periodically.
  Spend 1 Metal charge before using a movement to increase 10% your Size and Speed for its power calculations.
  
  Stats: Speed, Size
  Unlocks new movements]],
  insect = [[Gain Insect charges periodically.
  Spend 1 Insect charge before using a movement to Web the opponent, reducing its Speed.
  
  Stats: Intelligence, Speed
  Unlocks new movements]],
  mineral = [[Gain Mineral charges periodically.
  Spend 1 Mineral charge before being hit by an attack to reducing its damage by 2% of your total power.
  
  Stats: Size
  Unlocks new movements]],
}

  traitStats = {
    fire = {'int', 'met'},
    electro = {'speed'},
    poison = {'int'},
    ice = {'size', 'met'},
    plant = {'met'},
    metal = {'size', 'speed'},
    insect = {'speed', 'int'},
    mineral = {'size'},
    }

statusToStats = { --if good they are prolongued by the stat, if bad they are shortened. the BASE stat is used. 'dexterity', 'cognition', 'recovery'
  --attacking = 'neutral',
  blocking = 'recovery',
  dodging = 'recovery',
  instructed = 'neutral',
  deciding = 'neutral',
  subconscious = 'cognition',
  
  -- these are neutral for logs but debuffs for duration
  recoveryhead = 'recovery',
  recoverybody = 'recovery',
  recoveryarms = 'recovery',
  recoverylegs = 'recovery',
  recoverytail = 'recovery',
  --[[
  attack1 = 'neutral',
  attack2 = 'neutral',
  attack3 = 'neutral',
  attack4 = 'neutral',
  attack5 = 'neutral',
  attack6 = 'neutral',
  attack7 = 'neutral',
  attack8 = 'neutral',
  attack9 = 'neutral',
  
  attack = 'neutral',
  ]]
  
  scared = 'cognition',
  --chargeAttack = 'neutral',
  --feint = 'neutral',
  taunted = 'cognition',
  slowed = 'dexterity',
  weakened = 'dexterity',
  --chargingAttack = 'neutral',
  stunned = 'cognition',
  confused = 'cognition',
  bleeding = 'recovery',
  motivated = 'cognition',
  
  -- for combo, the power scales with the dex of the movement, but the duration is fixed, so neutral
  combo = 'neutral',
  
  -- the 5 main buffs scale with recovery
  focused = 'recovery',
  coordinated = 'recovery',
  strengthened = 'recovery',
  agilized = 'recovery',
  prepared = 'recovery',
  
  --[[
  attack = 'neutral',
  buff = 'neutral',
  utility = 'neutral',
  ]]
  
  -- the charge window is a debuff that scales down with dexterity
  attackCharge = 'dexterity',
  buffCharge = 'dexterity',
  utilityCharge = 'dexterity',
  
  -- the small window before movement has always the same duration
  attackUse = 'neutral',
  buffUse = 'neutral',
  utilityUse = 'neutral',
  
  burning = 'recovery',
  poisoned = 'recovery',
  
  
  fire = 'neutral',
  electro = 'neutral',
  poison = 'neutral',
  ice = 'neutral',
  plant = 'neutral',
  metal = 'neutral',
  insect = 'neutral',
  mineral = 'neutral',
  
  
  firePlus = 'neutral',
  electroPlus = 'neutral',
  poisonPlus = 'neutral',
  icePlus = 'neutral',
  plantPlus = 'neutral',
  metalPlus = 'neutral',
  insectPlus = 'neutral',
  mineralPlus = 'neutral',
  
  burning = 'recovery',
  poisoned = 'recovery',
  webbed = 'recovery',
  
  icySpikes = 'neutral',
  rockyCrust = 'neutral',
  liquidMetal = 'neutral',
  hallucinogen = 'neutral',
  
  
  
  instructionCD = 'neutral',
  }

statusType = { -- buffs and debuffs are shown in combat logs while the effect is active
  --attacking = 'buff',
  blocking = 'buff',
  dodging = 'buff',
  instructed = 'neutral',
  deciding = 'neutral',
  subconscious = 'debuff-neutral',
  recoveryhead = 'debuff-neutral',
  recoverybody = 'debuff-neutral',
  recoveryarms = 'debuff-neutral',
  recoverylegs = 'debuff-neutral',
  recoverytail = 'debuff-neutral',
  --[[
  attack1 = 'buff',
  attack2 = 'buff',
  attack3 = 'buff',
  attack4 = 'buff',
  attack5 = 'buff',
  attack6 = 'buff',
  attack7 = 'buff',
  attack8 = 'buff',
  attack9 = 'buff',
  attack = 'buff',
  ]]
  scared = 'debuff',
  --chargeAttack = 'buff',
  --feint = 'buff',
  taunted = 'debuff',
  weakened = 'debuff',
  --chargingAttack = 'buff',
  stunned = 'debuff',
  confused = 'debuff',
  bleeding = 'debuff',
  motivated = 'buff',
  combo = 'neutral',
  
  focused = 'buff',
  coordinated = 'buff',
  strengthened = 'buff',
  agilized = 'buff',
  prepared = 'buff',
  
  --[[
  attack = 'buff',
  buff = 'buff',
  utility = 'buff',
  ]]
  
  attackCharge = 'debuff-neutral',
  buffCharge = 'debuff-neutral',
  utilityCharge = 'debuff-neutral',
  
  attackUse = 'neutral',
  buffUse = 'neutral',
  utilityUse = 'neutral',
  
  burning = 'debuff',
  poisoned = 'debuff',
  
  
  
  firePlus = 'neutral',
  electroPlus = 'neutral',
  poisonPlus = 'neutral',
  icePlus = 'neutral',
  plantPlus = 'neutral',
  metalPlus = 'neutral',
  insectPlus = 'neutral',
  mineralPlus = 'neutral',
  
  burning = 'debuff',
  poisoned = 'debuff',
  webbed = 'debuff',
  
  icySpikes = 'neutral',
  rockyCrust = 'neutral',
  liquidMetal = 'neutral',
  hallucinogen = 'neutral',
  
  
  
  
  
  
  instructionCD = 'neutral',
  }






approachNames = {'offensive', 'defensive', 'agile', 'tactical', 'elemental'}


approaches = {
  offensive = {color = colors.red},
  defensive = {color = colors.blue},
  agile = {color = colors.green},
  tactical = {color = colors.grey},
  elemental = {color = colors.purple},
}

approachesIcon = {
  offensive = 7,
  defensive = 8,
  agile = 113,
  tactical = 231,
  elemental = 135,
}

approachesTransparentIcon = {
  offensive = 301,
  defensive = 302,
  agile = 303,
  tactical = 304,
  elemental = 305,
}

statsIcon = {
  size = 121,
  speed = 201,
  int = 159,
  met = 62,
  }

moveTypeIcon = {
  attack = 58,
  buff = 55,
  utility = 306,
}

organIcon = {
  head = 276,
  body = 277,
  arms = 278,
  legs = 279,
  tail = 280,
}

traitIcon = {
  --[[
  legsTrait1 = 218,
  tailTrait1 = 218,
  tailTrait2 = 218,
  ]]
  maxi = 70,
  mini = 71,
  wings = 155,
  eyes = 12,
  blades = 57,
  spikes = 59,
  quills = 265,
  fire = 11,
  electro = 10,
  poison = 21,
  ice = 17,
  plant = 16,
  metal = 14,
  insect = 19,
  mineral = 170,
}

traitList = {'maxi', 'mini', 'wings', 'eyes', 'blades', 'spikes', 'quills', 'fire', 'electro', 'poison', 'ice', 'plant', 'metal', 'insect'}



--defaultMovements = {'punch', 'kick', 'block', 'dodge'}
defaultMovements = {'scratch', 'punch', 'kick'}

--[[
monsterParts = {}

startingParts =  {
  mammal = {
    upperLimbs = {simpleArms = 1, smallClawArms = 1, bigClawArms = 1, smallFingerArms = 1, bigFingerArms = 1, glovedArms = 1, hoofArms = 1, giantHands = 1},
    lowerLimbs = {simpleLegs = 1, smallClawLegs = 1, bigClawLegs = 1, smallFingerLegs = 1, bigFingerLegs = 1, hoofLegs = 1},
    skin = {fur = 1},
    tail = {normalTail = 1},
    mouth = {},
    ears = {},
    extra = {},
    },
  reptile = {head, torso, arms, legs, scales},
  bird = {head, },
  }


head, torso, upperLimbs, lowerLimbs, skin


--partsList = {}

]]

powerTypesList = {'size', 'speed', 'int', 'met'}
powerTypesInfo = {
  size = {key = 'size', name = 'Size', iconNumber = 121},
  speed = {key = 'speed', name = 'Speed', iconNumber = 201},
  int = {key = 'int', name = 'Intelligence', iconNumber = 159},
  met = {key = 'met', name = 'Metabolism', iconNumber = 62},
  }




statList = {'currentHP', 'maxHP', 'dexterity', 'cognition', 'recovery'}
statsInfo = {
  currentHP = {key = 'currentHP', name = 'Current HP', iconNumber = nil},
  maxHP = {key = 'maxHP', name = 'HP', iconNumber = 69},
  dexterity = {key = 'dexterity', name = 'Dexterity', iconNumber = 196},
  cognition = {key = 'cognition', name = 'Cognition', iconNumber = 13},
  recovery = {key = 'recovery', name = 'Recovery', iconNumber = 232},
  }

organList = {'head', 'body', 'arms', 'legs', 'tail'}

organPowerPullInfo = {
  --[[
  head = {powerPull = 1, sizePull = 0.4, speedPull = 0.4, intPull = 0.2, metPull = 0},
  body = {powerPull = 1, sizePull = 0.8, speedPull = 0.2, intPull = 0, metPull = 0},
  arms = {powerPull = 1, sizePull = 0.3, speedPull = 0.7, intPull = 0, metPull = 0},
  legs = {powerPull = 1, sizePull = 0.4, speedPull = 0.6, intPull = 0, metPull = 0},
  tail = {powerPull = 1, sizePull = 0.2, speedPull = 0.8, intPull = 0, metPull = 0},
  ]]
  head = {powerPull = 1, sizePull = 0.25, speedPull = 0.25, intPull = 0.25, metPull = 0.25},
  body = {powerPull = 1, sizePull = 0.25, speedPull = 0.25, intPull = 0.25, metPull = 0.25},
  arms = {powerPull = 1, sizePull = 0.25, speedPull = 0.25, intPull = 0.25, metPull = 0.25},
  legs = {powerPull = 1, sizePull = 0.25, speedPull = 0.25, intPull = 0.25, metPull = 0.25},
  tail = {powerPull = 1, sizePull = 0.25, speedPull = 0.25, intPull = 0.25, metPull = 0.25},
}

traitPowerPullInfo = {
  --[[
  legsTrait1 = {key = 'legsTrait1', name = 'Trait 25', powerPull = 0.5, sizePull = 0.4, speedPull = 0.4, intPull = 0.2, metPull = 0},
  tailTrait1 = {key = 'tailTrait1', name = 'Trait 3', powerPull = 0.8, sizePull = 0.8, speedPull = 0.2, intPull = 0, metPull = 0},
  tailTrait2 = {key = 'tailTrait2', name = 'Trait 14', powerPull = 1, sizePull = 0.3, speedPull = 0.7, intPull = 0, metPull = 0},
  ]]  
  maxi = {key = 'maxi', name = 'Giant', powerPull = 0.5, sizePull = 0.8, speedPull = 0, intPull = 0, metPull = 0.2},
  mini = {key = 'mini', name = 'Reduced', powerPull = 0.5, sizePull = 0, speedPull = 0.8, intPull = 0, metPull = 0.2},
  wings = {key = 'wings', name = 'Wings', powerPull = 0.5, sizePull = 0.5, speedPull = 0.5, intPull = 0, metPull = 0},
  eyes = {key = 'eyes', name = 'Eyed', powerPull = 0.5, sizePull = 0, speedPull = 0, intPull = 1, metPull = 0},
  blades = {key = 'blades', name = 'Blades', powerPull = 0.5, sizePull = 0.2, speedPull = 0.6, intPull = 0.2, metPull = 0},
  spikes = {key = 'spikes', name = 'Spikes', powerPull = 0.5, sizePull = 0.25, speedPull = 0.25, intPull = 0.25, metPull = 0.25},
  quills = {key = 'quills', name = 'Quills', powerPull = 0.5, sizePull = 0.5, speedPull = 0, intPull = 0.25, metPull = 0.25},
  
  
  fire = {key = 'fire', name = 'Fire', powerPull = 0.5, sizePull = 0.1, speedPull = 0.1, intPull = 0.4, metPull = 0.4},
  electro = {key = 'electro', name = 'Electro', powerPull = 0.5, sizePull = 0.1, speedPull = 0.7, intPull = 0.1, metPull = 0.1},
  poison = {key = 'poison', name = 'Poison', powerPull = 0.5, sizePull = 0.1, speedPull = 0.1, intPull = 0.7, metPull = 0.1},
  ice = {key = 'ice', name = 'Ice', powerPull = 0.5, sizePull = 0.4, speedPull = 0.1, intPull = 0.1, metPull = 0.4},
  plant = {key = 'plant', name = 'Plant', powerPull = 0.5, sizePull = 0.1, speedPull = 0.1, intPull = 0.1, metPull = 0.7},
  metal = {key = 'metal', name = 'Metal', powerPull = 0.5, sizePull = 0.4, speedPull = 0.4, intPull = 0.1, metPull = 0.1},
  insect = {key = 'insect', name = 'Insect', powerPull = 0.5, sizePull = 0.1, speedPull = 0.4, intPull = 0.4, metPull = 0.1},
  mineral = {key = 'mineral', name = 'Mineral', powerPull = 0.5, sizePull = 0.7, speedPull = 0.1, intPull = 0.1, metPull = 0.1},
}


--[[
traitMovements = {
  maxi = {'embiggenOrgan', 'giantForm'},
  mini = {'miniatureForm', 'reduceOrgan'},
  wings = {'flapWings', 'fly'},
  eyes = {'activeObservation', 'hypnosis'},
  blades = {'extendClaws', 'multipleImpact'},
  spikes = {'prepareAttack', 'impale'},
  quills = {'createSpikes', 'damagingProtection'},
  fire = {'chargeFire', 'ardentFury', 'flameThrower'},
  electro = {'electrify', 'electricBalance'},
  poison = {'hallucinogen', 'concentratedPoison', 'reabsorbPoison'},
  ice = {'refrigerator', 'icyBreath', 'frozenStake'},
  plant = {'takeRoot', 'redirectEnergy'},
  metal = {'lightAlloy', 'hardening', 'fullMetalJacket'},
  insect = {'layWeb', 'lethalAttack'},
}
]]

traitMovements = {
  --[[
  maxi = {},
  mini = {},
  wings = {},
  eyes = {},
  blades = {},
  spikes = {},
  quills = {},
  ]]
  fire = {'infernalFlames', 'burningAttack', 'flameForm'},
  electro = {'electrify', 'discharge', 'charge'},
  poison = {'concentratedPoison', 'targetedSting', 'hallucinogen'},
  ice = {'deepFreeze', 'gelidHammer', 'icySpikes'},
  plant = {'photosynthesis', 'vineWhip', 'stemGrowth'},
  metal = {'sharpenEdges', 'bladeAttack', 'liquidMetal'},
  insect = {'resistantSilk', 'lethalAttack', 'stickyWeb'},
  mineral = {'cristallize', 'crushingAttack', 'rockyCrust'},
}

smallTraitList = {'fire', 'electro', 'poison', 'ice', 'plant', 'metal', 'insect', 'mineral'}

organMovements = {

  head = {'focus', 'bite', 'roar'},
  body = {'strength', 'tackle', 'dance'},
  arms = {'coordination', 'scratch', 'block'},
  legs = {'agility', 'kick', 'dodge'},
  tail = {'prepare', 'tailStrike', 'taunt'},
}


characterList = {'aggressive', 'impatient', 'cruel', 'cautious', 'shy', 'fearful', 'playful', 'ingenious', 'elusive', 'mischievous', 'strategist', 'manipulator', 'primal', 'lonely', 'eccentric'}

characterInfo = {
  aggressive = {name = 'Aggressive', movType = 'attack', approach = 'offensive'},
  impatient = {name = 'Impatient', movType = 'buff', approach = 'offensive'},
  cruel = {name = 'Cruel', movType = 'utility', approach = 'offensive'},
  
  cautious = {name = 'Cautious', movType = 'attack', approach = 'defensive'},
  shy = {name = 'Shy', movType = 'buff', approach = 'defensive'},
  fearful = {name = 'Fearful', movType = 'utility', approach = 'defensive'},
  
  playful = {name = 'Playful', movType = 'attack', approach = 'agile'},
  ingenious = {name = 'Ingenious', movType = 'buff', approach = 'agile'},
  elusive = {name = 'Elusive', movType = 'utility', approach = 'agile'},
  
  mischievous = {name = 'Mischievous', movType = 'attack', approach = 'tactical'},
  strategist = {name = 'Strategist', movType = 'buff', approach = 'tactical'},
  manipulator = {name = 'Manipulator', movType = 'utility', approach = 'tactical'},
  
  primal = {name = 'Primal', movType = 'attack', approach = 'elemental'},
  lonely = {name = 'Lonely', movType = 'buff', approach = 'elemental'},
  eccentric = {name = 'Eccentric', movType = 'utility', approach = 'elemental'},
  
  
  
  }





palettes = {
  palette1 = {
    {0,0,0},
    {0.988,0.988,0.988},
    {0.973,0.973,0.973},
    {0.737,0.737,0.737},
    {0.486,0.486,0.486},
    {0.643,0.894,0.988},
    {0.235,0.737,0.988},
    {0,0.471,0.973},
    {0,0,988},
    {0.722,0.722,0.973},
    
    {0.408,0.533,0.988},
    {0,0.345,0.973},
    {0,0,0.737},
    {0.847,0.722,0.973},
    {0.596,0.471,0.973},
    {0.408,0.267,0.988},
    {0.267,0.157,0.737},
    {0.973,0.722,0.973},
    {0.973,0.471,0.973},
    {0.847,0,0.8},
    
    {0.580,0,0.518},
    {0.973,0.643,0.753},
    {0.973,0.345,0.596},
    {0.894,0,0.345},
    {0.659,0,0.125},
    {0.941,0.816,0.690},
    {0.973,0.471,0.345},
    {0.973,0.220,0},
    {0.659,0.063,0},
    {0.988,0.878,0.659},
    
    {0.988,0.627,0.267},
    {0.894,0.361,0.063},
    {0.533,0.078,0},
    {0.973,0.847,0.471},
    {0.973,0.722,0},
    {0.675,0.486,0},
    {0.314,0.188,0},
    {0.847,0.973,0.471},
    {0.722,0.973,0.094},
    {0,0.722,0},
    
    {0,0.471,0},
    {0.722,0.973,0.722},
    {0.345,0.847,0.329},
    {0,0.659,0},
    {0,0.408,0},
    {0.722,0.973,0.847},
    {0.345,0.973,0.596},
    {0,0.659,0.267},
    {0,0.345,0},
    {0,0.988,0.988},
    
    {0,0.910,0.847},
    {0,0.533,0.533},
    {0,0.251,0.345},
    {0.973,0.847,0.973},
    {0.471,0.471,0.471},
    
    {0.314,0.314,0.314}
  },
}

palette = palettes.palette1

traitColors = {
  --maxi = {color1 = palette[37], color2 = palette[36]},
  mini = {color1 = palette[53], color2 = palette[52]},
  wings = {color1 = palette[52], color2 = palette[51]},
  eyes = {color1 = palette[20], color2 = palette[19]},
  blades = {color1 = palette[48], color2 = palette[47]},
  spikes = {color1 = palette[25], color2 = palette[24]},
  quills = {color1 = palette[11], color2 = palette[10]},
  fire = {color1 = palette[33], color2 = palette[32]},
  electro = {color1 = palette[36], color2 = palette[35]},
  poison = {color1 = palette[21], color2 = palette[20]},
  ice = {color1 = palette[11], color2 = palette[10]},
  plant = {color1 = palette[41], color2 = palette[40]},
  metal = {color1 = palette[5], color2 = palette[4]},
  insect = {color1 = palette[49], color2 = palette[48]},
  mineral = {color1 = palette[37], color2 = palette[36]},
}

traitMonsterColors = {
  fire = 28,
  electro = 35,
  poison = 21,
  ice = 8,
  plant = 39,
  metal = 4,
  insect = 48,
  mineral = 37,
}

maxElementalValues = {
  fire = 3,
  electro = 3,
  poison = 3,
  ice = 3,
  plant = 3,
  metal = 3,
  insect = 3,
  mineral = 3,
  }

approachColors = {
  offensive = {color1 = palette[28], color2 = palette[29]},
  defensive = {color1 = palette[12], color2 = palette[13]},
  agile = {color1 = palette[44], color2 = palette[45]},
  tactical = {color1 = palette[5], color2 = palette[56]},
  elemental = {color1 = palette[20], color2 = palette[21]},
}

movTypeColors = {
  attack = palette[29],
  buff = palette[45],
  utility = palette[13],
}


-- sprite gen parameters
  sprites = true

  sizeFactor0 = 10
  rescaleFactor0 = 8
  
  shadowColor = {0,0,0,0.5}
  white = {1,1,1,1}
  black = {0,0,0,1}
  black05 = {0,0,0,0.5}

  visible = true
  lines = false
  points = false

  shadowsActive = true
  directionalShadow = true
  frontalCamera = true
  mouthOpen = false

  asymmetricAngle = true
  
  
  chimeras = {}
  
  spawnX = 0.5*VIRTUAL_WIDTH
  spawnY = 0.65*VIRTUAL_HEIGHT

instructions = {
  [[Welcome to Elemental Monsters! In this game, you are a trainer with a completely unique monster and use it to fight up to 10 combats against wild monsters. After each combat your monster will grow, and it is also possible that gets an elemental trait!
  
  Here are the basic instructions:]],
  [[Your monster has 5 organs (head, body, arms, legs, tail), each with values for 4 different stats (size, speed, intelligence, metabolism). These stats determine the power of movements performed with that organ. After using an organ it needs some time to recover.]],
  [[There are 3 different types of movements: attacks (deal damage to the opponent), buffs (increase your own stats) and utility (defense and disruption). From a list of known movements, up to 6 can be equipped.]],
  [[The monsters periodically gain stamina points (SP) and approaches. Approaches (offensive, defensive, agile, tactical, elemental) represent part of the mental state of the monster. Each movement has a set of SP and approach requeriments.]],
  [[After gaining an approach, the automatic movements (marked yellow) are checked for requirements in descending order, and the monster tries to use each of them if able.]],
  [[Each monster has 2 of 15 possible personality traits, each giving a different approach when a movement of a specific type is performed.]],
  [[As a trainer, your instructions give an approach of your chosing to your monster. This can trigger all the equipped movements, not only the automatics ones.]],
  [[When your monster receives an elemental trait, it must be equipped in an organ slot. This organ gains power in some of its stats and can perform new movements.]],
  [[Controls:
  - Left Click: Assign orders, change equipped movements, move between menus
  - Escape: Options menu
  - Space: Pause (during combat)
  - F: Activate/deactivate fast forward x2 (during combat)]],
  [[These are just the basics, so the rest is for you to discover. Have fun!]],
  }


gAnimations = {
  attack = {
    ['body'] = -0.125*math.pi,
    ['belly'] = nil,
    ['head'] = nil,
    ['arm'] = -0.25*math.pi,
    ['leg'] = 0.875*math.pi,
    ['wing'] = nil,
    ['tail'] = nil,
    ['eye'] = nil,
    ['ear'] = nil,
    ['mouth'] = nil,
    ['hand'] = nil,
    ['feet'] = nil,
    ['snout'] = nil,
    ['pupil'] = nil,
    ['claw'] = nil,
  },

  defend = {
    ['body'] = 0.125*math.pi,
    ['belly'] = nil,
    ['head'] = 0.125*math.pi,
    ['arm'] = -0.125*math.pi,
    ['leg'] = 1.375*math.pi,
    ['wing'] = nil,
    ['tail'] = nil,
    ['eye'] = nil,
    ['ear'] = nil,
    ['mouth'] = nil,
    ['hand'] = nil,
    ['feet'] = nil,
    ['snout'] = nil,
    ['pupil'] = nil,
    ['claw'] = nil,
    },


  
  }












