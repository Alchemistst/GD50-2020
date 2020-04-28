--[[
    The powerup class is responsible for creating powerups.
    A powerup is spawned when a brick is hit, randomly.

]]

Powerup = Class{}

function Powerup:init(x, y, type)
    self.x = x
    self.y = y
    self.type = type 
end

function Powerup:update(dt)
    self.y = self.y + POWERUP_SPEED * dt
end

function Powerup:render()
    love.graphics.draw(gTextures['main'], gFrames['powerups'][self.type], self.x, self.y) 
end
