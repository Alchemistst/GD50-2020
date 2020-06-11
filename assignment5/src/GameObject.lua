--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- default empty collision callback
    self.onCollide = function() end

    -- *whether an object is consumable and consume callback
    self.consumable = def.consumable
    self.onConsume = function() end
    
    -- *callback for when an object is hit by the player
    self.onDamaged = function() end
    
    -- *States for objects that are holdable
    self.holding = false

    --* Animation for objects that needed it
    self.animated = def.animated
    if self.animated then
        self.animations = self:createAnimations(def.states)
        self.currentAnimation = self.animations[self.state]
    end
    
end

function GameObject:update(dt)
    if self.animated then
        self.currentAnimation:update(dt)
    end
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    if self.animated then
        local anim = self.currentAnimation
    --print(anim:getCurrentFrame()..', '..anim.timesPlayed)
        love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
    else
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
            self.x + adjacentOffsetX, self.y + adjacentOffsetY)
    end
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end

function GameObject:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture,
            frames = animationDef.frames,
            interval = animationDef.interval,
            looping = animationDef.looping
        }
    end

    return animationsReturned
end

function GameObject:changeState(state)
    self.state = state
    self.currentAnimation = self.animations[self.state]
    self.currentAnimation:refresh()
end

function GameObject:replaceType(old, new)
    self.type = string.gsub(self.type, "-"..old, new)
    print(self.type)
end

