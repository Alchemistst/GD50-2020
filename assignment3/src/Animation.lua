--[[
    Helper class that creates sprite based animations.
        Params:
            spritesheet => texture for the quads
            quads => quads to use for the animation
            x & y => coords to place animation
            duration => duration of the animation
]]

Animation = Class{}

function Animation:init(spriteSheet, quads, x, y, duration)
    self.spriteSheet = spriteSheet
    -- Get the Quads for the animation
    self.quads = quads
    -- Duration constraints how fast our animation will itearate over each quad
    self.duration = duration
    -- Tracks which frame of the animation we draw
    self.counter = 1
    -- The current Quad tha will be drawn
    self.quadToDraw = self.quads[self.counter]
    -- Timer to update the animation. 
    self.timer = Timer.every(self.duration/#self.quads , function () 
        
        self.counter = self.counter + 1  

        if self.counter > #self.quads then
            self.counter = 1
        end

        self.quadToDraw = self.quads[self.counter]
    end)
    -- Coords to place animation
    self.x = x
    self.y = y
end

function Animation:render(x, y)
    love.graphics.draw(self.spriteSheet, self.quadToDraw, x, y)
end

