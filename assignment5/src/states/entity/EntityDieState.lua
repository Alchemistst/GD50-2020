EntityDieState = Class{__includes = BaseState}

function EntityDieState:init(entity)
    self.entity = entity
end

function EntityDieState:enter()
    self.entity:changeAnimation('die-' .. self.entity.direction)
    print('die'.. os.clock())
   
end

function EntityDieState:update(dt)
    print('afsdf')
    print(self.entity.currentAnimation.currentFrame)
    if self.entity.currentAnimation.timesPlayed > 0 then
        print('finished')
        self.entity.dead = true
        self.entity:onDie()
    end
end

function EntityDieState:render()
    local anim = self.entity.currentAnimation
    print(anim.texture)
    
love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
    
   
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end

function EntityDieState:processAI()
end