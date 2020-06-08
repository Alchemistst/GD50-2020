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
        texture = 'tiles',
        frame = 14,
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'default',
        states = {
            ['default'] = {frame = 14},
            ['holding'] = {frame = 15}
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