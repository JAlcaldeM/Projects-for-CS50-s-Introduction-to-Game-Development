

-- 1-3 SP = 2 approach; 4-6 SP = 3 approach; 7-9 SP = 4 approach
MOV_DEFS = {
  
  default = {
    name = 'default',
    key = 'default',
    SPRequirement = 1,
    potency = 1,
    speed = 1,
    approachRequirements = {
      offensive = 1,
      defensive = 1,
      agile = 1,
      tactical = 1,
      elemental = 1,
    },
    description = '',
    element = '',
    type = 'attack',
    source = 'head',
    stat1 = 'int',
    stat2 = 'met',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      
      end
  },

  
  focus = {
    name = 'Focus',
    key = 'focus',
    SPRequirement = 2,
    potency = 2,
    speed = 2,
    approachRequirements = {
      tactical = 2,
    },
    description = 'Increase the Intelligence. Cannot receive orders.',
    element = '',
    type = 'buff',
    source = 'head',
    stat1 = 'int',
    stat2 = 'met',
    tags = {},
    status = {'focused'},
    onUse = function(user, objective, power1, power2)
        changeStatValue(user, power1, 'int')
        local onEnd = function() changeStatValue(user, -power1, 'int') end
        gainStatus(user, 'focused', power2, onEnd)
      end
  },

  bite = {
      name = 'Bite',
      key = 'bite',
      SPRequirement = 4,
      potency = 4,
      speed = 4,
      approachRequirements = {
        offensive = 2,
        agile = 1,
      },
      description = 'Deal damage and gain Combo.',
      element = '',
      type = 'attack',
      source = 'head',
      stat1 = 'size',
      stat2 = 'speed',
      tags = {},
      status = {},
      onUse = function(user, objective, power1, power2)
        dealDamage(user, objective, power1)
        gainStatus(user, 'combo', user.totalPower/comboDiv, nil, {power = power2})
      end
    },

  roar = {
    name = 'Roar',
    key = 'roar',
    SPRequirement = 4,
    potency = 4,
    speed = 4,
    approachRequirements = {
      defensive = 1,
      tactical = 2,
    },
    description ='Scares the enemy. Reduces damage of enemy attacks. Complete.',
    element = '',
    type = 'utility',
    source = 'head',
    stat1 = 'int',
    stat2 = 'size',
    complete = true,
    tags = {'protection'},
    status = {'scared'},
    onUse = function(user, objective, power1, power2)
        gainStatus(objective, 'scared', power1)
        if objective.status.attacking then
          objective.status.attacking.power = objective.status.attacking.power - power2
          if objective.status.attacking.power <= 0 then
            objective.status.attacking.power = 0
          end
        end
      end
  },
  strength = {
    name = 'Strength',
    key = 'strength',
    SPRequirement = 2,
    potency = 2,
    speed = 2,
    approachRequirements = {
      offensive = 1,
      tactical = 1,
    },
    description = 'Increases the Size. Can only gain Offensive approaches.',
    element = '',
    type = 'buff',
    source = 'body',
    stat1 = 'size',
    stat2 = 'met',
    tags = {},
    status = {'strengthened'},
    onUse = function(user, objective, power1, power2)
        changeStatValue(user, power1, 'size')
        local onEnd = function() changeStatValue(user, -power1, 'size') end
        gainStatus(user, 'strengthened', power2, onEnd)
      end
  },
  tackle = {
    name = 'Tackle',
    key = 'tackle',
    SPRequirement = 7,
    potency = 7,
    speed = 7,
    approachRequirements = {
      offensive = 3,
      agile = 1,
    },
    description = 'Deal damage. Gain Combo. Complete (uses stats from the whole body).',
    element = '',
    type = 'attack',
    source = 'body',
    stat1 = 'size',
    stat2 = 'speed',
    complete = true,
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
        dealDamage(user, objective, power1)
        gainStatus(user, 'combo', user.totalPower/comboDiv, nil, {power = power2})
      end
  },
  dance = {
    name = 'Dance',
    key = 'dance',
    SPRequirement = 3,
    potency = 3,
    speed = 3,
    approachRequirements = {
      agile = 1,
      tactical = 1,
    },
    description = 'Confuses the enemy and gain Combo.',
    element = '',
    type = 'utility',
    source = 'body',
    stat1 = 'int',
    stat2 = 'speed',
    tags = {},
    status = {'confused'},
    onUse = function(user, objective, power1, power2)
        gainStatus(objective, 'confused', power1)
        gainStatus(user, 'combo', user.totalPower/comboDiv, nil, {power = power2})
      end
  },
  coordination = {
    name = 'Coordination',
    key = 'coordination',
    SPRequirement = 2,
    potency = 2,
    speed = 2,
    approachRequirements = {
      tactical = 2,
    },
    description = 'Increases Metabolism. Cannot repeat mov. type. Complete. Uses all stats.',
    element = '',
    type = 'buff',
    source = 'arms',
    stat1 = 'met',
    stat2 = 'met',
    complete = true,
    mixed = true,
    tags = {},
    status = {'coordinated'},
    onUse = function(user, objective, power1, power2)
        changeStatValue(user, power1, 'met')
        local onEnd = function() changeStatValue(user, -power1, 'met') end
        gainStatus(user, 'coordinated', power2, onEnd)
      end
  },
  scratch = {
    name = 'Scratch',
    key = 'scratch',
    SPRequirement = 2,
    potency = 2,
    speed = 2,
    approachRequirements = {
      offensive = 1,
      agile = 1,
    },
    description = 'Deal damage, cause Bleeding and gain Combo.',
    element = '',
    type = 'attack',
    source = 'arms',
    stat1 = 'int',
    stat2 = 'speed',
    tags = {},
    status = {'bleeding'},
    onUse = function(user, objective, power1, power2)
        dealDamage(user, objective, power1/2 + power2/2)
        gainStatus(objective, 'bleeding', power1/2)
        gainStatus(user, 'combo', user.totalPower/comboDiv, nil, {power = power2/2})
      end
  },
  block = {
    name = 'Block',
    key = 'block',
    SPRequirement = 3,
    potency = 3,
    speed = 3,
    approachRequirements = {
      defensive = 1,
      tactical = 1,
    },
    description = 'Mitigate damage. and block negative status effects.',
    element = '',
    type = 'utility',
    source = 'arms',
    stat1 = 'size',
    stat2 = 'met',
    tags = {'protection'},
    status = {'blocking'},
    onUse = function(user, objective, power1, power2)
      gainStatus(user, 'blocking', power2/2, nil, {power = power1})
      end
  },
  agility = {
    name = 'Agility',
    key = 'agility',
    SPRequirement = 2,
    potency = 2,
    speed = 2,
    approachRequirements = {
      agile = 1,
      tactical = 1,
    },
    description = 'Increases the Speed. -20% SP Regen.',
    element = '',
    type = 'buff',
    source = 'legs',
    stat1 = 'speed',
    stat2 = 'met',
    tags = {},
    status = {'agilized'},
    onUse = function(user, objective, power1, power2)
        changeStatValue(user, power1, 'speed')
        
        local onEnd = function()
          changeStatValue(user, -power1, 'speed')
          user.regenSP = user.regenSP / 0.8
          end
        user.regenSP = user.regenSP * 0.8
        gainStatus(user, 'agilized', power2, onEnd)
      end
  },
  kick = {
    name = 'Kick',
    key = 'kick',
    SPRequirement = 4,
    potency = 4,
    speed = 4,
    approachRequirements = {
      offensive = 2,
      agile = 1,
    },
    description = 'Deal damage and slows the enemy.',
    element = '',
    type = 'attack',
    source = 'legs',
    stat1 = 'size',
    stat2 = 'int',
    tags = {},
    status = {'slowed'},
    onUse = function(user, objective, power1, power2)
        dealDamage(user, objective, power1)
        local onEnd = function() changeStatValue(user, 2, 'speed', 'mixed', 'mult') end
        gainStatus(objective, 'slowed', power2, onEnd)
        if checkStatus(objective, 'name', 'slowed') then
          changeStatValue(user, 0.5, 'speed', 'mixed', 'mult')
        end
      end
  },
  dodge = {
    name = 'Dodge',
    key = 'dodge',
    SPRequirement = 2,
    potency = 2,
    speed = 2,
    approachRequirements = {
      defensive = 1,
      agile = 1,
    },
    description ='Evade damage and status effects. Gain Combo. Complete.',
    element = '',
    type = 'utility',
    source = 'legs',
    stat1 = 'met',
    stat2 = 'speed',
    complete = true,
    tags = {'protection'},
    status = {'dodging'},
    onUse = function(user, objective, power1, power2)
        gainStatus(user, 'dodging', power1/4)
        gainStatus(user, 'combo', user.totalPower/comboDiv, nil, {power = power2})
      end
  },
  prepare = {
    name = 'Prepare',
    key = 'prepare',
    SPRequirement = 4,
    potency = 4,
    speed = 4,
    approachRequirements = {
      tactical = 3,
    },
    description = 'Gain Decision when the opponent starts a move. Complete.',
    element = '',
    type = 'buff',
    source = 'tail',
    stat1 = 'int',
    stat2 = 'met',
    complete = true,
    tags = {'reaction'},
    status = {'prepared'},
    onUse = function(user, objective, power1, power2)
        user.statusMultiplyers.subconscious = user.statusMultiplyers.subconscious * 2
        onEnd = function() user.statusMultiplyers.subconscious = user.statusMultiplyers.subconscious * 0.5 end
        gainStatus(user, 'prepared', power2, onEnd, {power = power1})
      end
  },
  tailStrike = {
    name = 'Tail Strike',
    key = 'tailStrike',
    SPRequirement = 5,
    potency = 5,
    speed = 5,
    approachRequirements = {
      offensive = 2,
      tactical = 1,
    },
    description = 'Deal damage. Gain Motivation.',
    element = '',
    type = 'attack',
    source = 'tail',
    stat1 = 'size',
    stat2 = 'met',
    tags = {},
    status = {},
    --status = {'motivated'},
    onUse = function(user, objective, power1, power2)
        dealDamage(user, objective, power1)
        local extraValue = user.totalPower/100
        local onEnd = function() changeStatValue(user, -extraValue, 'mixed', 'complete') end
        gainStatus(user, 'motivated', power2)
        changeStatValue(user, extraValue, 'mixed', 'complete')
      end
      
  },
  taunt = {
    name = 'Taunt',
    key = 'taunt',
    SPRequirement = 3,
    potency = 3,
    speed = 3,
    approachRequirements = {
      agile = 1,
      tactical = 1,
    },
    description = 'Taunts the enemy (cannot gain Defensive approaches). Gain Combo.',
    element = '',
    type = 'utility',
    source = 'tail',
    stat1 = 'int',
    stat2 = 'speed',
    tags = {'reaction'},
    status = {'taunt'},
    onUse = function(user, objective, power1, power2)
        gainStatus(objective, 'taunted', power1)
        gainStatus(user, 'combo', user.totalPower/comboDiv, nil, {power = power2})
      end
  },










  
  -- elemental attacks
  
  -- fire
  infernalFlames = {
    name = 'Infernal Flames',
    key = 'infernalFlames',
    SPRequirement = 4,
    potency = 4,
    speed = 4,
    approachRequirements = {
      tactical = 1,
      elemental = 2,
    },
    description = 'Increase by 50% the power of your Fire charges.',
    element = 'fire',
    type = 'buff',
    source = 'trait',
    stat1 = 'int',
    stat2 = 'met',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
        gainStatus(user, 'firePlus', power)
      end
  },
  burningAttack = {
    name = 'Burning Attack',
    key = 'burningAttack',
    SPRequirement = 3,
    potency = 3,
    speed = 3,
    approachRequirements = {
      offensive = 1,
      elemental = 1,
    },
    description = 'Deal damage and trigger all your Fire charges.',
    element = 'fire',
    type = 'attack',
    source = 'trait',
    stat1 = 'int',
    stat2 = 'met',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      local fireCounters = nElementalCounters(user, 'fire')
      local statusPrev = {plus = false}
      if user.status.firePlus then
        statusPrev = {plus = true}
      end
      gainStatus(objective, 'burning', fireCounters*objective.totalPower/100, nil, statusPrev)
      user.status.fire.counter = 0
      dealDamage(user, objective, power)
      end
  },
  flameForm = {
    name = 'Flame Form',
    key = 'flameForm',
    SPRequirement = 4,
    potency = 4,
    speed = 4,
    approachRequirements = {
      defensive = 1,
      agile = 1,
      elemental = 1,
    },
    description = 'Consume all your Fire charges to dodge for prolonged time.',
    element = 'fire',
    type = 'utility',
    source = 'trait',
    stat1 = 'int',
    stat2 = 'met',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      if user.status.firePlus then
        power = power*1.5
      end
      local fireCounters = nElementalCounters(user, 'fire')
      gainStatus(user, 'dodging', fireCounters*power/6)
      user.status.fire.counter = 0
      end
  },
  
  -- ice
  deepFreeze = {
    name = 'Deep Freeze',
    key = 'deepFreeze',
    SPRequirement = 4,
    potency = 4,
    speed = 4,
    approachRequirements = {
      defensive = 1,
      elemental = 2,
    },
    description = 'When your Ice charges are spent, you only lose 1 Ice charge.',
    element = 'ice',
    type = 'buff',
    source = 'trait',
    stat1 = 'met',
    stat2 = 'size',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      gainStatus(user, 'icePlus', power)
      end
  },
  gelidHammer = {
    name = 'Gelid Hammer',
    key = 'gelidHammer',
    SPRequirement = 5,
    potency = 5,
    speed = 5,
    approachRequirements = {
      offensive = 2,
      elemental = 1,
    },
    description = 'Spend all your Ice charges to deal damage for each.',
    element = 'ice',
    type = 'attack',
    source = 'trait',
    stat1 = 'met',
    stat2 = 'size',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      local iceCounters = nElementalCounters(user, 'ice')
      dealDamage(user, objective, iceCounters*power)
      if user.status.icySpikes then
        dealDamage(user, objective, (0.5 + 0.5*iceCounters)*user.totalPower/50, 'blockLog')
      end
      if user.status.icePlus then
        user.status.ice.counter = iceCounters - 1
      else
        user.status.ice.counter = 0
      end
    end
  },
  icySpikes = {
    name = 'Icy Spikes',
    key = 'icySpikes',
    SPRequirement = 4,
    potency = 4,
    speed = 4,
    approachRequirements = {
      agile = 1,
      tactical = 1,
      elemental = 1,
    },
    description = 'Your Ice charges deal damage when spent.',
    element = 'ice',
    type = 'utility',
    source = 'trait',
    stat1 = 'met',
    stat2 = 'size',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      gainStatus(user, 'icySpikes', power)
      end
  },
  
  -- plant
  photosynthesis = {
    name = 'Photosynthesis',
    key = 'photosynthesis',
    SPRequirement = 5,
    potency = 5,
    speed = 5,
    approachRequirements = {
      defensive = 1,
      elemental = 2,
    },
    description = 'Spend 1 plant charge to double the healing from your Plant charges.',
    element = 'plant',
    type = 'buff',
    source = 'trait',
    stat1 = 'met',
    stat2 = 'int',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local plantCounters = nElementalCounters(user, 'plant')
      if plantCounters > 0 then
        local power = (power1 + power2)/2
        gainStatus(user, 'plantPlus', power)
        user.status.plant.counter = plantCounters - 1
      end
    end
  },
  vineWhip = {
    name = 'Vine Whip',
    key = 'vineWhip',
    SPRequirement = 4,
    potency = 4,
    speed = 4,
    approachRequirements = {
      offensive = 1,
      agile = 1,
      elemental = 1,
    },
    description = 'Spend 1 Plant charge to deal damage proportional to your Plant charges.',
    element = 'plant',
    type = 'attack',
    source = 'trait',
    stat1 = 'met',
    stat2 = 'speed',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local plantCounters = nElementalCounters(user, 'plant')
      if plantCounters > 0 then
        local power = (power1 + power2)/2
        dealDamage(user, objective, 0.5*plantCounters*power)
        user.status.plant.counter = plantCounters - 1
      end
    end
  },
  stemGrowth = {
    name = 'Stem Growth',
    key = 'stemGrowth',
    SPRequirement = 2,
    potency = 2,
    speed = 2,
    approachRequirements = {
      tactical = 1,
      elemental = 1,
    },
    description = 'Spend 1 Plant charge to increase your charge limit by 1 (max. 6).',
    element = 'plant',
    type = 'utility',
    source = 'trait',
    stat1 = 'met',
    stat2 = 'size',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local plantCounters = nElementalCounters(user, 'plant')
      if plantCounters > 0 then
        local power = (power1 + power2)/2
        user.counterLimit = math.min(6, user.counterLimit + 1)
        user.status.plant.counter = plantCounters - 1
      end
    end
  },
  
  -- insect
  resistantSilk = {
    name = 'Resistant Silk',
    key = 'resistantSilk',
    SPRequirement = 2,
    potency = 2,
    speed = 2,
    approachRequirements = {
      tactical = 1,
      elemental = 1,
    },
    description = 'Your Web lasts 50% longer.',
    element = 'insect',
    type = 'buff',
    source = 'trait',
    stat1 = 'speed',
    stat2 = 'int',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      gainStatus(user, 'insectPlus', power)
      end
  },
  lethalAttack = {
    name = 'Lethal Attack',
    key = 'lethalAttack',
    SPRequirement = 5,
    potency = 5,
    speed = 5,
    approachRequirements = {
      offensive = 1,
      agile = 1,
      elemental = 1,
    },
    description = 'Deal extra damage if faster than the opponent.',
    element = 'insect',
    type = 'attack',
    source = 'trait',
    stat1 = 'speed',
    stat2 = 'int',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      local speedRate = math.min(1.5, user.powerValues.speed.value / objective.powerValues.speed.value)
      dealDamage(user, objective, speedRate*power)
      end
  },
  stickyWeb = {
    name = 'Sticky Web',
    key = 'stickyWeb',
    SPRequirement = 2,
    potency = 2,
    speed = 2,
    approachRequirements = {
      defensive = 1,
      elemental = 1,
    },
    description = 'Spend all your Insect charges. Increase the Web duration and slow.',
    element = 'insect',
    type = 'utility',
    source = 'trait',
    stat1 = 'speed',
    stat2 = 'int',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
        changeStatValue(user, 1/1.5, 'speed', 'mixed', 'mult')
        local onEnd = function() changeStatValue(user, 1.5, 'speed', 'mixed', 'mult') end
        local duration = power
        if user.status.insectPlus then
          duration = 2*duration
        end
        gainStatus(objective, 'webbed', duration, onEnd) 
        user.status.insect.counter = 0
      end
  },

  -- mineral
  cristallize = {
    name = 'Cristallize',
    key = 'cristallize',
    SPRequirement = 5,
    potency = 5,
    speed = 5,
    approachRequirements = {
      defensive = 1,
      agile = 1,
      elemental = 1,
    },
    description = 'Your Mineral charges trigger twice and regenerate 50% faster.',
    element = 'mineral',
    type = 'buff',
    source = 'trait',
    stat1 = 'size',
    stat2 = 'met',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      gainStatus(user, 'mineralPlus', power)
      end
  },
  crushingAttack = {
    name = 'Crushing Attack',
    key = 'crushingAttack',
    SPRequirement = 7,
    potency = 7,
    speed = 7,
    approachRequirements = {
      offensive = 3,
      elemental = 1,
    },
    description = 'Potent attack that makes you take damage from the objective.',
    element = 'mineral',
    type = 'attack',
    source = 'trait',
    stat1 = 'size',
    stat2 = 'speed',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      dealDamage(user, objective, 1.5*power)
      dealDamage(objective, user, 0.3*power)
      end
  },
  rockyCrust = {
    name = 'Rocky Crust',
    key = 'rockyCrust',
    SPRequirement = 4,
    potency = 4,
    speed = 4,
    approachRequirements = {
      offensive = 1,
      tactical = 1,
      elemental = 1,
    },
    description = 'Your attacks spend 1 Mineral charge, but deal 20% extra damage.',
    element = 'mineral',
    type = 'utility',
    source = 'trait',
    stat1 = 'size',
    stat2 = 'int',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      gainStatus(user, 'rockyCrust', power)
      end
  },
  
  -- metal
  sharpenEdges = {
    name = 'Sharpen Edges',
    key = 'sharpenEdges',
    SPRequirement = 4,
    potency = 4,
    speed = 4,
    approachRequirements = {
      defensive = 1,
      elemental = 2,
    },
    description = 'Double the stat bonus from Metal charges from 10% to 20%.',
    element = 'metal',
    type = 'buff',
    source = 'trait',
    stat1 = 'size',
    stat2 = 'speed',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      gainStatus(user, 'metalPlus', power)
      end
  },
  bladeAttack = {
    name = 'Blade Attack',
    key = 'bladeAttack',
    SPRequirement = 4,
    potency = 4,
    speed = 4,
    approachRequirements = {
      offensive = 1,
      agile = 1,
      elemental = 1,
    },
    description = 'Attack that uses all your Metal charges.',
    element = 'metal',
    type = 'attack',
    source = 'trait',
    stat1 = 'size',
    stat2 = 'speed',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      dealDamage(user, objective, power)
      end
  },
  liquidMetal = {
    name = 'Liquid Metal',
    key = 'liquidMetal',
    SPRequirement = 3,
    potency = 3,
    speed = 3,
    approachRequirements = {
      tactical = 1,
      elemental = 1,
    },
    description = 'Your Metal charges also increase Intelligence and Metabolism.',
    element = 'metal',
    type = 'utility',
    source = 'trait',
    stat1 = 'size',
    stat2 = 'speed',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      gainStatus(user, 'liquidMetal', power)
      end
  },
  
  -- electro
  electrify = {
    name = 'Electrify',
    key = 'electrify',
    SPRequirement = 2,
    potency = 2,
    speed = 2,
    approachRequirements = {
      defensive = 1,
      agile = 1,
      elemental = 1,
    },
    description = 'When attacked, deal damage and trigger your Electro charges.',
    element = 'electro',
    type = 'buff',
    source = 'trait',
    stat1 = 'speed',
    stat2 = 'int',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      gainStatus(user, 'electroPlus', power)
      end
  },
  discharge = {
    name = 'Discharge',
    key = 'discharge',
    SPRequirement = 2,
    potency = 2,
    speed = 2,
    approachRequirements = {
      offensive = 1,
      agile = 1,
      elemental = 1,
    },
    description = 'Deal damage proportional to your Electric charges, then trigger them.',
    element = 'electro',
    type = 'attack',
    source = 'trait',
    stat1 = 'speed',
    stat2 = 'size',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      local electroCounters = nElementalCounters(user, 'electro')
        if electroCounters > 0 then
          dealDamage(user, objective, (0.5 + 0.5*electroCounters)*power)
          user.currentSP = math.min(10, user.currentSP + electroCounters)
          user.SPbar.value = user.currentSP
          user.SPbarb.value = user.currentSP
          user.status.electro.counter = 0
        end
      end
  },
  charge = {
    name = 'Charge',
    key = 'charge',
    SPRequirement = 1,
    potency = 1,
    speed = 1,
    approachRequirements = {
      agile = 1,
      tactical = 1,
      elemental = 1,
    },
    description = 'Trigger your Electro charges, then set them to the charge limit.',
    element = 'electro',
    type = 'utility',
    source = 'trait',
    stat1 = 'speed',
    stat2 = 'met',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local electroCounters = nElementalCounters(user, 'electro')
      if electroCounters > 0 then
        user.currentSP = math.min(10, user.currentSP + electroCounters)
        user.SPbar.value = user.currentSP
        user.SPbarb.value = user.currentSP
        user.status.electro.counter = user.counterLimit
      end
      end
  },
  
  -- poison
  concentratedPoison = {
    name = 'Concentr. Poison',
    key = 'concentratedPoison',
    SPRequirement = 4,
    potency = 4,
    speed = 4,
    approachRequirements = {
      elemental = 3,
    },
    description = 'Increase by 20% the Posion damage and charge generation.',
    element = 'poison',
    type = 'buff',
    source = 'trait',
    stat1 = 'int',
    stat2 = 'size',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      gainStatus(user, 'poisonPlus', power)
      end
  },
  targetedSting = {
    name = 'Targeted Sting',
    key = 'targetedSting',
    SPRequirement = 1,
    potency = 1,
    speed = 1,
    approachRequirements = {
      offensive = 1,
      agile = 1,
      tactical = 1,
      elemental = 1,
    },
    description = 'Fast attack that makes its Poison damage faster.',
    element = 'poison',
    type = 'attack',
    source = 'trait',
    stat1 = 'int',
    stat2 = 'speed',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      local poisonCounters = nElementalCounters(user, 'poison')
      local statusPrev = {fastPoison = true, plus = false}
      if user.status.poisonPlus then
        statusPrev = {fastPoison = true, plus = true}
      end
        gainStatus(objective, 'poisoned', poisonCounters*objective.totalPower/40, nil, statusPrev)
        user.status.poison.counter = 0
        dealDamage(user, objective, power)
        if user.status.hallucinogen then
          gainStatus(objective, 'scared', poisonCounters*objective.totalPower/20)
        end
      end
  },
  hallucinogen = {
    name = 'Hallucinogen',
    key = 'hallucinogen',
    SPRequirement = 3,
    potency = 3,
    speed = 3,
    approachRequirements = {
      defensive = 1,
      elemental = 1,
    },
    description = 'Your Poison also scares the enemy (cannot gain Offensive approach).',
    element = 'poison',
    type = 'utility',
    source = 'trait',
    stat1 = 'int',
    stat2 = 'met',
    tags = {},
    status = {},
    onUse = function(user, objective, power1, power2)
      local power = (power1 + power2)/2
      gainStatus(user, 'hallucinogen', power)
      end
  },
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  --[[
    miniatureForm = {
    name = 'Miniature form',
    SPRequirement = 4,
    approachRequirements = {
      agile = 2,
      tactical = 1,
    },
    description = 'Miniaturice all your organs',
    type = 'buff',
    source = 'trait',
    stats = {'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
    reduceOrgan = {
    name = 'Reduce Organ',
    SPRequirement = 2,
    approachRequirements = {
      offensive = 1,
      agile = 1,
    },
    description = 'Reduce the size of your miniature organs',
    type = 'buff',
    source = 'trait',
    stats = {'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
    embiggenOrgan = {
    name = 'Embiggen Organ',
    SPRequirement = 3,
    approachRequirements = {
      tactical = 1,
      elemental = 1,
    },
    description = 'Increase the size of your embiggened organs',
    type = 'buff',
    source = 'trait',
    stats = {'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
    giantForm = {
    name = 'Giant Form',
    SPRequirement = 6,
    approachRequirements = {
      offensive = 2,
      defensive = 2,
      elemental = 1,
    },
    description = 'Embiggen all your organs',
    type = 'buff',
    source = 'trait',
    stats = {'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
    flapWings = {
    name = 'Flap Wings',
    SPRequirement = 3,
    approachRequirements = {
      agile = 2,
      tactical = 1,
    },
    description = 'Increase the speed of all your winged organs',
    type = 'buff',
    source = 'trait',
    stats = {'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
    fly = {
    name = 'Fly',
    SPRequirement = 5,
    approachRequirements = {
      defensive = 2,
      agile = 1,
      tactical = 1,
    },
    description = 'Evade all attacks. Add the speed of your winged organs to your next attack.',
    type = 'buff',
    source = 'trait',
    stats = {'speed', 'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
    activeObservation = {
    name = 'Active Observation',
    SPRequirement = 2,
    approachRequirements = {
      tactical = 2,
    },
    description = 'Increase the intelligence of all your eyed organs',
    type = 'buff',
    source = 'trait',
    stats = {'int', 'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
    hypnosis = {
    name = 'Hypnosis',
    SPRequirement = 5,
    approachRequirements = {
      tactical = 3,
      elemental = 1,
    },
    description = 'Puts the enemy to sleep',
    type = 'debuff',
    source = 'trait',
    stats = {'int', 'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
    extendClaws = {
    name = 'Extend Claws',
    SPRequirement = 4,
    approachRequirements = {
      offensive = 2,
      tactical = 1,
    },
    description = 'Add additional damage to speed attacks from your arms and legs',
    type = 'buff',
    source = 'trait',
    stats = {'size', 'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
    multipleImpact = {
    name = 'Multiple Impact',
    SPRequirement = 6,
    approachRequirements = {
      offensive = 3,
      agile = 1,
    },
    description = 'Deal damage 3 consecutive times',
    type = 'attack',
    potency = 2,
    source = 'trait',
    stats = {'size', 'speed'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
    prepareAttack = {
    name = 'Prepare Attack',
    SPRequirement = 4,
    approachRequirements = {
      offensive = 2,
      tactical = 2,
    },
    description = 'The next attack with this organ scales with stats from all organs',
    type = 'buff',
    potency = 2,
    source = 'trait',
    stats = {'int', 'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
    impale = {
    name = 'Impale',
    SPRequirement = 7,
    approachRequirements = {
      offensive = 3,
      elemental = 1,
    },
    description = 'Powerful attack that scales with all the stat types',
    type = 'attack',
    potency = 4,
    source = 'trait',
    stats = {'size', 'speed'}, -- only 2 places for power scaling in icon placements
    --stats = {'size', 'speed', 'int', 'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
    createSpikes = {
    name = 'Create Spikes',
    SPRequirement = 2,
    approachRequirements = {
      offensive = 1,
      defensive = 1,
      tactical = 1,
    },
    description = 'Gain 1 Spike charge',
    type = 'buff',
    source = 'trait',
    stats = {'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
    damagingProtection = {
    name = 'Damaging Protection',
    SPRequirement = 3,
    approachRequirements = {
      offensive = 1,
      defensive = 2,
    },
    description = 'Block. Your spikes hit twice.',
    type = 'buff',
    source = 'trait',
    stats = {'size', 'int'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  
  
  chargeFire = {
    name = 'Charge Fire',
    SPRequirement = 3,
    approachRequirements = {
      elemental = 1,
    },
    description = 'Gain 2 fire charges',
    type = 'buff',
    source = 'trait',
    stats = {'size', 'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  ardentFury = {
    name = 'Ardent Fury',
    SPRequirement = 4,
    approachRequirements = {
      offensive = 3,
      tactical = 1,
      elemental = 1,
    },
    description = 'Consume fire charges to increase attack damage.',
    type = 'buff',
    source = 'trait',
    stats = {'size', 'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  flameThrower = {
    name = 'Flame Thrower',
    SPRequirement = 3,
    approachRequirements = {
      offensive = 2,
      elemental = 2,
    },
    description = 'Consume all your fire charges to deal damage.',
    type = 'attack',
    potency = 4,
    source = 'trait',
    stats = {'size', 'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  electrify = {
    name = 'Electrify',
    SPRequirement = 2,
    approachRequirements = {
      offensive = 1,
      tactical = 1,
      elemental = 1,
    },
    description = 'Your next attack deals additional damage for each electric charge, and consumes 1 of them.',
    type = 'buff',
    source = 'trait',
    stats = {'size', 'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  electricBalance = {
    name = 'Electric Balance',
    SPRequirement = 4,
    approachRequirements = {
      agile = 1,
      elemental = 1,
    },
    description = 'Set your electric charge to 3. If at least 1 charge is consumed. Recover SP for each consumed charge.',
    type = 'buff',
    source = 'trait',
    stats = {'speed', 'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  weakeningPoison = {
    name = 'Weakening Poison',
    SPRequirement = 2,
    approachRequirements = {
      tactical = 1,
      elemental = 1,
    },
    description = 'Your poison reduces enemy SP recovery.',
    type = 'buff',
    source = 'trait',
    stats = {'int', 'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  concentratedPoison = {
    name = 'Concentrated Poison',
    SPRequirement = 3,
    approachRequirements = {
      offensive = 1,
      elemental = 1,
    },
    description = 'Your poison deals more damage.',
    type = 'buff',
    source = 'trait',
    stats = {'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  reabsorbPoison = {
    name = 'Reabsorb Poison',
    SPRequirement = 4,
    approachRequirements = {
      defensive = 1,
      elemental = 1,
    },
    description = 'Consume poison charges to recover health.',
    type = 'buff',
    source = 'trait',
    stats = {'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  refrigerator = {
    name = 'Refrigerator',
    SPRequirement = 4,
    approachRequirements = {
      defensive = 1,
      elemental = 1,
    },
    description = 'Increase the rate of ice generation',
    type = 'buff',
    source = 'trait',
    stats = {'size', 'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  icyBreath = {
    name = 'Icy Breath',
    SPRequirement = 4,
    approachRequirements = {
      tactical = 1,
      elemental = 1,
    },
    description = 'Slows the enemy',
    type = 'debuff',
    source = 'trait',
    stats = {'size', 'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  frozenStake = {
    name = 'Frozen Stake',
    SPRequirement = 4,
    approachRequirements = {
      offensive = 2,
      elemental = 2,
    },
    description = 'Consume all your ice charges to deal damage. Duplicate the damage for each charge consumed.',
    type = 'attack',
    potency = 1,
    source = 'trait',
    stats = {'size'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  takeRoot = {
    name = 'Take Root',
    SPRequirement = 3,
    approachRequirements = {
      elemental = 2,
    },
    description = 'Increase the metabolism, reduce the speed. Stackable.',
    type = 'buff',
    source = 'trait',
    stats = {'size'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  redirectEnergy = {
    name = 'Redirect Energy',
    SPRequirement = 2,
    approachRequirements = {
      tactical = 1,
      elemental = 1,
    },
    description = 'Change from Stamina form to Healing form and viceversa',
    type = 'buff',
    source = 'trait',
    stats = {'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  lightAlloy = {
    name = 'Light Alloy',
    SPRequirement = 3,
    approachRequirements = {
      agile = 1,
      elemental = 1,
    },
    description = 'Nullify the speed reduction from your metal organs',
    type = 'buff',
    source = 'trait',
    stats = {'speed', 'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  hardening = {
    name = 'Hardening',
    SPRequirement = 4,
    approachRequirements = {
      tactical = 1,
      elemental = 1,
    },
    description = 'Increase the size scaling of your metal organs',
    type = 'buff',
    source = 'trait',
    stats = {'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  fullMetalJacket = {
    name = 'Full Metal Jacket',
    SPRequirement = 6,
    approachRequirements = {
      offensive = 1,
      defensive = 1,
      tactical = 1,
      elemental = 1,
    },
    description = 'All your organs become metallic',
    type = 'buff',
    source = 'trait',
    stats = {'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  layWeb = {
    name = 'Lay Web',
    SPRequirement = 3,
    approachRequirements = {
      defensive = 1,
      tactical = 2,
    },
    description = 'Lay a web that ensnares attacking enemies.',
    type = 'debuff',
    source = 'trait',
    stats = {'int', 'met'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  lethalAttack = {
    name = 'Lethal attack',
    SPRequirement = 5,
    approachRequirements = {
      offensive = 3,
      tactical = 2,
    },
    description = 'Powerful attack that scales with the attacker/defender speed ratio.',
    type = 'attack',
    potency = 2,
    source = 'trait',
    stats = {'int'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
]]









  --[[
  default = {
    name = 'name',
    SPRequirement = 1,
    approachRequirements = {
      offensive = 1,
      defensive = 1,
      agile = 1,
      tactical = 1,
      elemental = 1,
    },
    description = 'description',
    type = 'attack',
    potency = 2,
    source = 'arms',
    stats = {'size', 'speed'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local onEnd = function()
      end
      gainStatus(user, 'attacking', delay, onEnd)
    end
  },
  scratch = {
    name = 'Scratch',
    SPRequirement = 2,
    approachRequirements = {
      offensive = 1,
    },
    description = 'Deal 2 x attack damage',
    type = 'attack',
    potency = 2,
    source = 'arms',
    stats = {'speed'},
    onUse = function(user, objective, movInfo, organName, recovery)
      onUseDefault(user, objective, movInfo, organName, recovery)
    end
  },
  punch = {
    name = 'Punch',
    SPRequirement = 3,
    approachRequirements = {
      offensive = 2,
    },
    description = 'Deal 3 x attack damage',
    type = 'attack',
    potency = 3,
    source = 'arms',
    stats = {'size', 'speed'},
    onUse = function(user, objective, movInfo, organName, recovery)
      onUseDefault(user, objective, movInfo, organName, recovery)
    end
  },
  kick = {
    name = 'Kick',
    SPRequirement = 5,
    approachRequirements = {
      offensive = 3,
    },
    description = 'Deal 5 x attack damage',
    type = 'attack',
    potency = 4,
    source = 'legs',
    stats = {'size', 'speed'},
    onUse = function(user, objective, movInfo, organName, recovery)
      onUseDefault(user, objective, movInfo, organName, recovery)
    end
  },
  block = {
    name = 'Block',
    SPRequirement = 3,
    approachRequirements = {
      defensive = 3,
    },
    description = 'Block for 5 seconds',
    type = 'buff',
    source = 'arms',
    stats = {'size'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local buffType = 'blocking'
      local durationMult = 5
      onUseDefault(user, objective, movInfo, organName, recovery, buffType, durationMult)
    end
  },
  dodge = {
    name = 'Dodge',
    SPRequirement = 4,
    approachRequirements = {
      defensive = 1,
      tactical = 1,
    },
    description ='Dodge for 2 seconds',
    type = 'buff',
    source = 'legs',
    stats = {'speed'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local buffType = 'dodging'
      local durationMult = 2
      onUseDefault(user, objective, movInfo, organName, recovery, buffType, durationMult)
    end
  },
  
  
  headbutt = {
    name = 'Headbutt',
    SPRequirement = 4,
    approachRequirements = {
      defensive = 1,
      tactical = 1,
    },
    description ='Dodge for 2 seconds',
    type = 'attack',
    potency = 5,
    source = 'head',
    stats = {'size'},
    onUse = function(user, objective, movInfo, organName, recovery)
      onUseDefault(user, objective, movInfo, organName, recovery)
    end
  },
  focus = {
    name = 'Focus',
    SPRequirement = 4,
    approachRequirements = {
      defensive = 1,
      tactical = 1,
    },
    description ='Dodge for 2 seconds',
    type = 'buff',
    source = 'head',
    stats = {'int'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local buffType = 'focus'
      local durationMult = 3
      onUseDefault(user, objective, movInfo, organName, recovery, buffType, durationMult)
    end
  },
  bite = {
    name = 'Bite',
    SPRequirement = 4,
    approachRequirements = {
      defensive = 1,
      tactical = 1,
    },
    description ='Dodge for 2 seconds',
    type = 'attack',
    potency = 5,
    source = 'head',
    stats = {'size', 'speed'},
    onUse = function(user, objective, movInfo, organName, recovery)
      onUseDefault(user, objective, movInfo, organName, recovery)
    end
  },
  roar = {
    name = 'Roar',
    SPRequirement = 4,
    approachRequirements = {
      defensive = 1,
      tactical = 1,
    },
    description ='Dodge for 2 seconds',
    type = 'debuff',
    source = 'head',
    stats = {'size', 'int'},
    onUse = function(user, objective, movInfo, organName, recovery)
      gainStatus(user, 'dodging', 2)
    end
  },
  tackle = {
    name = 'Tackle',
    SPRequirement = 4,
    approachRequirements = {
      defensive = 1,
      tactical = 1,
    },
    description ='Dodge for 2 seconds',
    type = 'attack',
    potency = 6,
    source = 'body',
    stats = {'size', 'speed'},
    onUse = function(user, objective, movInfo, organName, recovery)
      onUseDefault(user, objective, movInfo, organName, recovery)
    end
  },
  battleStance = {
    name = 'Battle Stance',
    SPRequirement = 4,
    approachRequirements = {
      defensive = 1,
      tactical = 1,
    },
    description ='Dodge for 2 seconds',
    type = 'buff',
    source = 'body',
    stats = {'size'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local buffType = 'battleStance'
      local durationMult = 3
      onUseDefault(user, objective, movInfo, organName, recovery, buffType, durationMult)
    end
  },
  movementStance = {
    name = 'Movement Stance',
    SPRequirement = 4,
    approachRequirements = {
      defensive = 1,
      tactical = 1,
    },
    description ='Dodge for 2 seconds',
    type = 'buff',
    source = 'arms',
    stats = {'speed'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local buffType = 'movementStance'
      local durationMult = 3
      onUseDefault(user, objective, movInfo, organName, recovery, buffType, durationMult)
    end
  },
  agility = {
    name = 'Agility',
    SPRequirement = 4,
    approachRequirements = {
      defensive = 1,
      tactical = 1,
    },
    description ='Dodge for 2 seconds',
    type = 'buff',
    source = 'legs',
    stats = {'speed'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local buffType = 'agility'
      local durationMult = 4
      onUseDefault(user, objective, movInfo, organName, recovery, buffType, durationMult)
    end
  },
  tailStrike = {
    name = 'Tail Strike',
    SPRequirement = 4,
    approachRequirements = {
      defensive = 1,
      tactical = 1,
    },
    description ='Dodge for 2 seconds',
    type = 'buff',
    source = 'tail',
    stats = {'speed'},
    onUse = function(user, objective, movInfo, organName, recovery)
      onUseDefault(user, objective, movInfo, organName, recovery)
    end
  },
  balanceStance = {
    name = 'Balance Stance',
    SPRequirement = 4,
    approachRequirements = {
      defensive = 1,
      tactical = 1,
    },
    description ='Dodge for 2 seconds',
    type = 'buff',
    source = 'tail',
    stats = {'speed'},
    onUse = function(user, objective, movInfo, organName, recovery)
      local buffType = 'balanceStance'
      local durationMult = 3
      onUseDefault(user, objective, movInfo, organName, recovery, buffType, durationMult)
    end
  },
  ]]
}