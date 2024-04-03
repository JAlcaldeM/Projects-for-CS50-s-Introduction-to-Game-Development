--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        pickable = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    
    ['pot'] = {
        type = 'pot',
        texture = 'tiles',
        frame = 14,
        width = 16,
        height = 16,
        solid = true,
        pickable = true,

        defaultState = 'notbroken',
        states = {
            ['notbroken'] = {
                frame = 33
            },
            ['broken'] = {
                frame = 52
            }
        },
    },
    
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        pickable = false,
        defaultState = 'half',
        states = {
            ['half'] = {
                frame = 3
            },
            
            ['full'] = {
                frame = 5
            }
        },
    },
        
        ['miniheart'] = {
        type = 'miniheart',
        texture = 'miniheart',
        frame = 1,
        width = 8,
        height = 8,
        solid = false,
        pickable = false,
        magnetic = true,
        defaultState = 'full',
        states = {
            ['full'] = {
                frame = 1
            }
        }
    },
    
    ['minirupee'] = {
        type = 'minirupee',
        texture = 'minirupee',
        frame = 1,
        width = 8,
        height = 8,
        solid = false,
        pickable = false,
        magnetic = true,
        defaultState = 'full',
        states = {
            ['full'] = {
                frame = 1
            }
        }
    },
    
    ['rupee'] = {
        type = 'rupee',
        texture = 'rupee',
        frame = 1,
        width = 16,
        height = 16,
        solid = false,
        pickable = false,
        defaultState = 'full',
        states = {
            ['full'] = {
                frame = 1
            }
        }
    },
}