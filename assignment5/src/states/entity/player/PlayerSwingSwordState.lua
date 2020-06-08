--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerSwingSwordState = Class{__includes = BaseState}

function PlayerSwingSwordState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 8

    -- create hitbox based on where the player is and facing
    local direction = self.player.direction
    
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    if direction == 'left' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x - hitboxWidth
        hitboxY = self.player.y + self.player.height/2 - hitboxHeight/2
    elseif direction == 'right' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x + self.player.width
        hitboxY = self.player.y + self.player.height/2 - hitboxHeight/2
    elseif direction == 'up' then
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x + self.player.width/2 - hitboxWidth/2
        hitboxY = self.player.y - hitboxHeight
    else
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x + self.player.width/2 - hitboxWidth/2
        hitboxY = self.player.y + self.player.height
    end

    self.swordHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)
    self.player:changeAnimation('sword-' .. self.player.direction)
end

function PlayerSwingSwordState:enter(params)
    gSounds['sword']:stop()
    gSounds['sword']:play()

    -- restart sword swing animation
    self.player.currentAnimation:refresh()
end

function PlayerSwingSwordState:update(dt)
    -- check if hitbox collides with any entities in the scene
    for k, entity in pairs(self.dungeon.currentRoom.entities) do
        if entity:collides(self.swordHitbox) then
            entity:damage(1)
            gSounds['hit-enemy']:play()
        end
    end
    -- *Check if hitbox collides with any breakable object
    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if string.find(object.type, "breakable") 
        and not (self.swordHitbox.x + self.swordHitbox.width < object.x 
        or self.swordHitbox.y + self.swordHitbox.height < object.y 
        or self.swordHitbox.x > object.x + object.width 
        or self.swordHitbox.y > object.y + object.height)then
            -- *Break the object
            table.remove( self.dungeon.currentRoom.objects, k )
        end
    end

    if self.player.currentAnimation.timesPlayed > 0 then
        --self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end

    if love.keyboard.wasPressed('space') then
        self.player:changeState('swing-sword')
    end
end

function PlayerSwingSwordState:render()
    local anim = self.player.currentAnimation
    --print(anim:getCurrentFrame()..', '..anim.timesPlayed)
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    -- debug for player and hurtbox collision rects
    love.graphics.setColor(255, 0, 255, 255)
    love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    love.graphics.rectangle('line', self.swordHitbox.x, self.swordHitbox.y,
        self.swordHitbox.width, self.swordHitbox.height)
    love.graphics.setColor(255, 255, 255, 255)
end