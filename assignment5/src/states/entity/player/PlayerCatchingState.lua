PlayerCatchingState = Class{__includes = BaseState}

function PlayerCatchingState:init(player)
    self.player = player
end

function PlayerCatchingState:enter(params)
    self.objectHeld = params.object
    self.objectHeld.item.solid = false
    self.objectHeld.item.state = "holding"
    self.player:changeAnimation('catch-' .. self.player.direction)
    
    -- *Tween the coordinates of the object so it looks as if it's being lifted
    Timer.tween( self.player.currentAnimation.interval,
    {[self.objectHeld.item] = { 
        x = self.player.x + self.player.width / 2 - self.objectHeld.item.width / 2, 
        y = self.player.y - self.objectHeld.item.height / 2 + 1
    }})
    
    self.player.currentAnimation:refresh()
end

function PlayerCatchingState:update(dt)
    
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle-pot', {['object'] = self.objectHeld})
    end
end

function PlayerCatchingState:render()
    local anim = self.player.currentAnimation
    --print(anim:getCurrentFrame()..', '..anim.timesPlayed)
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end