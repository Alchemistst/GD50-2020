--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    self.MAX_HEALTH = def.MAX_HEALTH

    Entity.init(self, def)
end

function Player:update(dt)
    Entity.update(self, dt)
end


function Player:render()
    Entity.render(self)
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end

-- *Adds health to the player not exceeding its MAX_HEALTH
function Player:heal(half_hearts) 
    self.health = math.min(self.health + half_hearts, self.MAX_HEALTH)
end