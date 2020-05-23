--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerWalkingState = Class{__includes = BaseState}

function PlayerWalkingState:init(player)
    self.player = player
    self.animation = Animation {
        frames = {10, 11},
        interval = 0.1
    }
    self.player.currentAnimation = self.animation
end

function PlayerWalkingState:update(dt)
    self.player.currentAnimation:update(dt)

    -- idle if we're not pressing anything at all
    if not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
        self.player:changeState('idle')
    else
        local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
        local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y + self.player.height)

        -- temporarily shift player down a pixel to test for game objects beneath
        self.player.y = self.player.y + 1

        local collidedObjects = self.player:checkObjectCollisions()

        self.player.y = self.player.y - 1

        -- check to see whether there are any tiles beneath us
        if #collidedObjects == 0 and (tileBottomLeft and tileBottomRight) and (not tileBottomLeft:collidable() and not tileBottomRight:collidable()) then
            self.player.dy = 0
            -- *Shift the player 1px down so it falls if it walks over a 1 tile chasm.
            self.player.y = self.player.y + 1
            self.player:changeState('falling')
        end
        if love.keyboard.isDown('left') then
            self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
            self.player.direction = 'left'
            self.player:checkLeftCollisions(dt)
        end
        if love.keyboard.isDown('right') then
            self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
            self.player.direction = 'right'
            self.player:checkRightCollisions(dt)
        end
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

    -- *check if we've collided with any game objects
    for k, object in pairs(self.player.level.objects) do
        if object:collides(self.player) then
            if object.triggerable then
                object.onCollide(object, self.player)
            end
        end
    end

    if love.keyboard.wasPressed('space') then
        self.player:changeState('jump')
    end
end