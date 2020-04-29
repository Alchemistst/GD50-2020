LockedBrick = Class{__includes = Brick}

function LockedBrick:init(brick)
    self.x = brick.x
    self.y = brick.y
    self.width = 32
    self.height = 16

    -- once is unlocked, the block will behave has a normal brick
    self.brick = brick
    
    -- used to determine whether this brick should be rendered
    self.inPlay = true

    -- determines wether the block will behave has a normal brick and give the player all the juicy points
    self.unlocked = false

    

    self.tier = 0
    self.color = 0
end

function LockedBrick:hit(key)
    if self.unlocked then
        self.brick:hit()
    else
        if key then
            self.unlocked = true
        end
    end
end

function LockedBrick:render()
    if self.unlocked then
        self.brick:render()
    else
        if self.inPlay then
            love.graphics.draw(gTextures['main'],
                gFrames['lockedBrick'],
                self.x, self.y)
        end
    end
end

function LockedBrick:update(dt)
    if self.unlocked then
        self.brick:update(dt)
        self.inPlay = self.brick.inPlay
    else

    end
end

function LockedBrick:renderParticles()
    if self.unlocked then
        self.brick:renderParticles()
    else

    end
end