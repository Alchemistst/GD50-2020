--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{}

function Projectile:init(def)
    self.projectile = def.object
    -- self.projectile.solid = true
    -- self.projectile.type = "projectile"
    self.speed = def.speed
    self.direction = def.direction
    self.pos = def.pos
    
    if self.direction == 'left' then
        self.travelLimitX = self.projectile.x - 4 * TILE_SIZE
        self.travelLimitY = self.projectile.y
    elseif self.direction == 'right' then
        self.travelLimitX = self.projectile.x + self.projectile.width + 4 * TILE_SIZE
        self.travelLimitY = self.projectile.y
    elseif self.direction == 'up' then
        self.travelLimitX = self.projectile.x
        self.travelLimitY = self.projectile.y - 4 * TILE_SIZE
    elseif self.direction == 'down' then
        self.travelLimitX = self.projectile.x
        self.travelLimitY = self.projectile.y + self.projectile.height + 4 * TILE_SIZE
    end

    self.onCollideWithObject = function () end
    self.onCollideWithEntity = function () end

end

function Projectile:update(dt)
    --*Move projectile accordingly
    if self.direction == 'left' then
        self.projectile.x = self.projectile.x - self.speed * dt
    elseif self.direction == 'right' then
        self.projectile.x = self.projectile.x + self.speed * dt
    elseif self.direction == 'up' then 
        self.projectile.y = self.projectile.y - self.speed * dt
    elseif self.direction == 'down' then 
        self.projectile.y = self.projectile.y + self.speed * dt
    end

    --*Check for collisions with objects
    --*Check for collisions with entities
end

--* Check for projectile travelling farther than 4 tiles or out bounds
function Projectile:checkTravelLimit(direction)
    if self.projectile.x + self.projectile.width >= MAP_WIDTH * TILE_SIZE + MAP_RENDER_OFFSET_X 
    or self.projectile.x <= MAP_RENDER_OFFSET_X
    or self.projectile.y + self.projectile.height >= MAP_HEIGHT * TILE_SIZE + MAP_RENDER_OFFSET_Y
    or (self.projectile.y <= MAP_RENDER_OFFSET_Y and direction == "up" )then
        return true
    end
    if self.direction == 'left' then
        return self.travelLimitX > self.projectile.x
    elseif self.direction == 'right' then
        return self.travelLimitX < self.projectile.x + self.projectile.width 
    elseif self.direction == 'up' then
        return self.travelLimitY > self.projectile.y
    elseif self.direction == 'down' then
        return self.travelLimitY < self.projectile.y + self.projectile.height
    end
end

--* Collision detection for the projectile
function Projectile:collides(target)
    return not (self.projectile.x + self.projectile.width < target.x or self.projectile.x > target.x + target.width or
                self.projectile.y + self.projectile.height < target.y or self.projectile.y > target.y + target.height)
end