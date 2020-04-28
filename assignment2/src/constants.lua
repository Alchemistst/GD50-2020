--[[
    GD50 2018
    Breakout Remake

    -- constants --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Some global constants for our application.
]]

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- paddle movement speed
PADDLE_SPEED = 200

-- powerup falling speed
POWERUP_SPEED = 100

-- table of types of powerups
POWERUP_LIST = {'growth', 'doubleBall', 'heart'} --Key is not included as it only makes sense to spawn it if there's a locked brick