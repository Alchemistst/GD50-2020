PlayerThrowingState = Class{__includes = BaseState}

function PlayerThrowingState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon
end

function PlayerThrowingState:enter(params)
    self.objectHeld = params.object
    self.objectHeld.item.solid = false
    
    self.player:changeAnimation('throw-' .. self.player.direction)

    --* Transform object into projectile
    table.insert(self.dungeon.currentRoom.projectiles, Projectile(
        {
            ["object"] = self.objectHeld.item,
            ["speed"] = 180,
            ["direction"] = self.player.direction,
            ["pos"] = self.objectHeld.pos
        }
    ))
    self.objectHeld.state = "default"
    self.player.currentAnimation:refresh()
end

function PlayerThrowingState:update(dt)
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
        self.player.objectHeld = nil
    end
end

function PlayerThrowingState:render()
    local anim = self.player.currentAnimation
    --print(anim:getCurrentFrame()..', '..anim.timesPlayed)
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end