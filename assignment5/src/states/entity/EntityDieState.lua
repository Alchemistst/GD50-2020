EntityDieState = Class{__includes = BaseState}

function EntityDieState:init(entity)
    self.entity = entity
end

function EntityDieState:enter()
    self.entity:changeAnimation('die-' .. self.entity.direction)
    self.entity.hostile = false
end

function EntityDieState:update(dt)
    if self.entity.currentAnimation.timesPlayed > 0 then
        self.entity.dead = true
        self.entity:onDie()
    end
end

function EntityDieState:render()
    local anim = self.entity.currentAnimation
    
love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end

function EntityDieState:processAI()
end