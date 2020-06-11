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
        type = 'throwable-breakable-holdable',
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'default',
        animated = true,
        states = {
            ['default'] = {
                frames = {14},
                texture = 'tiles'
            },
            ['holding'] = {
                frames = {15},
                texture = 'tiles'
            },
            ['break'] = {
                frames = {1, 2, 3, 4, 5, 6},
                interval = 0.08,
                looping = false,
                texture = 'breaking_pot'
            }
        }
    },
    ['heart_consumable'] = {
        type = 'consumable',
        texture = 'hearts_consumable',
        frame = 1,
        width = 7,
        height = 7,
        solid = false,
        consumable = true,
        defaultState = 'default',
        states = {
            ['default'] = {frame = 1}
        }
    }
}