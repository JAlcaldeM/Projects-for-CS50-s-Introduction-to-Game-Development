--VIRTUAL_WIDTH = 640
--VIRTUAL_HEIGHT = 360

scale = 3

camSize = 2

renderShapes = false

VIRTUAL_WIDTH = 640*scale*camSize
VIRTUAL_HEIGHT = 360*scale*camSize

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

MAP_SCROLL_X_SPEED = 100*scale
BACKGROUND_SCROLL_X_SPEED = MAP_SCROLL_X_SPEED / 2

TILE_SIZE = 35*scale
ALIEN_SIZE = TILE_SIZE

DEGREES_TO_RADIANS = 0.0174532925199432957
RADIANS_TO_DEGREES = 57.295779513082320876

impulseLimitMaterials = {
  ['wood'] = 15000,
  ['glass'] = 10000,
  ['stone'] = 20000,
  ['metal'] = 25000,
  ['explosive'] = 10000,
}

densityMaterials = {
  ['wood'] = 15,
  ['glass'] = 10,
  ['stone'] = 20,
  ['metal'] = 25,
  ['explosive'] = 20,
}

materialsList = {'wood', 'glass', 'stone', 'metal', 'explosive'}

upgradeToShape = {
  [0] = 'circle',
  [1] = 'square',
  [2] = 'triangle',
  [3] = '21',
  [4] = '31',
  [5] = '32'
}

upgradeToMaterial = {
  [0] = 'wood',
  [1] = 'wood',
  [2] = 'stone',
  [3] = 'stone',
  [4] = 'metal',
}

upgradeToFrame = {
  [1] = 'stone',
  [3] = 'metal'
}




shapeToScore = {
  ['31'] = 3,
  ['13'] = 3,
  ['32'] = 6,
  ['23'] = 6,
  ['22'] = 4,
  ['21'] = 2,
  ['12'] = 2,
  ['triangle'] = 1,
  ['square'] = 1,
  ['circle'] = 1,
  ['balancer'] = 1,
}

materialToScore = {
  ['wood'] = 2,
  ['glass'] = 1,
  ['stone'] = 3,
  ['metal'] = 4,
  ['explosive'] = 5,

}


upgradesInfo = {
  material = {maxLevel = 4, cleanName = 'Better Material', description = 'Increase the density, mass and HP (variable)'},
  size = {maxLevel = 5, cleanName = 'Bigger Size', description = 'Increase the size (+20%)'},
  shape = {maxLevel = 5, cleanName = 'Better Shape', description = 'Increase the mass and change the shape (variable)'},
  numberDivision = {maxLevel = 3, cleanName = 'Additional Division', description = 'Increase the number of division projectiles (+1)'},
  sizeDivision = {maxLevel = 4, cleanName = 'Bigger Divisions', description = 'Increase the size of the division projectiles (+25%)'},
  explosiveDivision = {maxLevel = 5, cleanName = 'Explosive Divisions', description = 'Chance of divison projectiles being explosive (+20%)'},
  explosiveArea = {maxLevel = 5, cleanName = 'Bigger Explosions', description = 'Increase the size of your explosions (+50%)'},
  explosiveForce = {maxLevel = 5, cleanName = 'Stronger Explosions', description = 'Increase the force of your explosions (+50%)'},
  strengthThrow = {maxLevel = 4, cleanName = 'Stronger Throws', description = 'Increase the maximum initial throw speed (+50%)'},
  extraProjectile = {maxLevel = 4, cleanName = 'Extra Projectile', description = 'Gain an additional projectile to throw (+1)'}
}

tips = {
  [1] = 'You cannot divide the projectile after hitting another object or the ground.',
  [2] = 'The explosion that is created when dividing with SPACE pushes the new projectiles, and even other obstacles if they are close enough.',
  [3] = 'The strength of an explosion is proportional to the density of the object, and the range is proportional to its size.',
  [4] = 'The projectiles created after a division appear in the direciton the original projectile is moving.',
  [5] = 'The trajectory of the projectile changes with gravity. Some projectile shapes benefit greatly from changing the approach angle.',
  [6] = 'The upgrades that improve your explosions affect the division and the EXPLOSIVE DIVISIONS upgrade, but not the explosive charges already in the level.',
  [7] = 'Each level is procedurally generated. In higher levels, the difficulty is increased.',
  [8] = 'There are 10 different upgrades. Some of them are general-purpose, but others are highly sinergistic between them. Try all the possible combinations!',
  [9] = "If a squared alien is pushed too far from its initial position, it is destroyed. Don't worry from pushing them outside your reach!",
  [10] = 'After a level is cleared, each non-used projectile rewards you with 1000 extra points.',
  [11] = 'Upon destruction, each obstacle rewards points depending of its size and material. More destruction = high score.',
  [12] = 'Squared aliens always are worth 2000 points.',
  [13] = 'Each obstacle has 3 damage states: undamaged, damaged and nearly broken. The sprite changes to reflect the current state.',
  [14] = 'During an impact, each object receives damage proportional to the force of the impact and its relative density. Dense objects are harder to break, but weaker to gravity.',
  [15] = 'An obstacle needs to receive enough force from the same impact to advance to the next damage state. If the impact is too weak, it will remain undamaged.',
  [16] = 'After a division, the new projectiles are usually smaller and lighter than the original. Divide if you want to push a structure, but you will have a harder time breaking it.',
  [17] = "You can 'reroll' a level by pushing R, but you will have 1 less projectile to beat it.",
  [18] = 'Some upgrades are weaker on the first levels, but stronger in the long term. Be sure to try all the upgrade combinations to find new strategies.',
  [19] = 'Before a throw, you can move the camera with the directional arrows in your keyboard. During the throw, the camera moves to offer the best views for the imminent destruction.',
  [20] = 'If all the aliens have been killed but the upgrade screen does not appear, be patient and look up the sky. It is possible that a suprise is coming...',
  [21] = 'Some levels are taller, while others are wider. Be sure to plan your strategy accordingly before start throwing.',
  [22] = 'Gravity is the best ally of a thrown brick (or ball).',
  [23] = 'After you beat each level, be sure to read the tip below the upgrades. They usually help you discover new aspects of the game (except maybe this time).',
  [24] = 'This time, the projectiles are not angry. They are just happy to be thrown around.',
  [25] = 'The explosions push objects and aliens, but do not damage them. However, it is likely that this push results in damaging collisions with other objects.',
  [26] = 'If you get to level 20 and beat the game, be sure to remember your score and try to increase it with new upgrade combinations!',
  [27] = 'It was really necessary to add tips to this game? Sometimes, details are also part of the experience.',
  [28] = 'If aiming, you can cancel the throw by pressing the right mouse button.',
  [29] = 'Press P to pause the game.',
  [30] = 'The percentages shown during the upgrade screen are relative to the base values.'
  
  }

