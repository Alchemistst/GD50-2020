--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Entity = Class{}

function Entity:init(def)
    -- in top-down games, there are four directions instead of two
    self.direction = 'down'

    self.animations = self:createAnimations(def.animations)

    -- dimensions
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height

    -- drawing offsets for padded sprites
    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0

    self.walkSpeed = def.walkSpeed

    self.health = def.health

    -- flags for flashing the entity when hit
    self.invulnerable = false
    self.invulnerableDuration = 0
    self.invulnerableTimer = 0
    self.flashTimer = 0

    self.dead = false

    --* whether or not the entity is hostile
    self.hostile = def.hostile

    -- *function triggered when entity dies
    self.onDie = function () end
    -- *function to kill the entity
    self.kill = function () 
        if not self.dead then
            self:changeState('die')
        end
    end
end

function Entity:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval,
            looping = animationDef.looping
        }
    end

    return animationsReturned
end

--[[
    AABB with some slight shrinkage of the box on the top side for perspective.
]]
function Entity:collides(target)
    --[[
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)

    ]]
    if target.solid then
        local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
        
        return not (self.x + self.width < target.x + 2 or self.x > target.x - 2 + target.width or
        selfY + selfHeight < target.y + 1.5 or selfY > target.y - 1.5 + target.height)
    elseif target.type == 'door' then
        return not (self.x + self.width < target.x + 1 or self.x > target.x -1 + target.width or
        self.y + self.height < target.y + 1 or self.y > target.y - 1 + target.height)
    else
        return not (self.x + self.width < target.x + 5 or self.x > target.x + target.width - 5 or
                self.y + self.height < target.y + 5 or self.y > target.y + target.height - 5)
    end
end

function Entity:damage(dmg)
    self.health = self.health - dmg
    if self.health == 0 then
        self:kill()
    end
end

function Entity:goInvulnerable(duration)
    self.invulnerable = true
    self.invulnerableDuration = duration
end

function Entity:changeState(name, params)
    
    self.stateMachine:change(name, params)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Entity:update(dt)
    if self.invulnerable then
        self.flashTimer = self.flashTimer + dt
        self.invulnerableTimer = self.invulnerableTimer + dt

        if self.invulnerableTimer > self.invulnerableDuration then
            self.invulnerable = false
            self.invulnerableTimer = 0
            self.invulnerableDuration = 0
            self.flashTimer = 0
        end
    end

    self.stateMachine:update(dt)

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

function Entity:processAI(params, dt)
    self.stateMachine:processAI(params, dt)
end

function Entity:render(adjacentOffsetX, adjacentOffsetY)
    -- draw sprite slightly transparent if invulnerable every 0.04 seconds
    if self.invulnerable and self.flashTimer > 0.06 then
        self.flashTimer = 0
        love.graphics.setColor(255, 255, 255, 64)
    end

    self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
    self.stateMachine:render()
    love.graphics.setColor(255, 255, 255, 255)
    self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end