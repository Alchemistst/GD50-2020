--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
    self.player = player

    self.animation = Animation {
        frames = {1},
        interval = 1
    }

    self.player.currentAnimation = self.animation
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        self.player:changeState('walking')
    end

    if love.keyboard.wasPressed('space') then
        self.player:changeState('jump')
    end

    local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y + self.player.height)

    -- temporarily shift player down a pixel to test for game objects beneath
    self.player.y = self.player.y + 1

    local collidedObjects = self.player:checkObjectCollisions()

    self.player.y = self.player.y - 1

    -- check to see whether there are any tiles beneath us
    if #collidedObjects == 0 and (tileBottomLeft and tileBottomRight) and (not tileBottomLeft:collidable() and not tileBottomRight:collidable()) then
        self.player.dy = 0
        self.player:changeState('falling')
    end
    
    -- check if we've collided with any entities and die if so
    for k, entity in pairs(self.player.level.entities) do
        if entity.isHostile then
            if entity:collides(self.player) then
                gSounds['death']:play()
                gStateMachine:change('start')
            end
        end
    end
end