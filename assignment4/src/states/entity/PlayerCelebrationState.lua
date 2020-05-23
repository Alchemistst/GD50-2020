PlayerCelebrationState = Class{__includes = BaseState}

function PlayerCelebrationState:init(player)
    self.player = player
    self.animation = Animation {
        frames = {12, 13, 14, 15, 16, 17},
        interval = 0.1
    }
    self.player.currentAnimation = self.animation
end

function PlayerCelebrationState:update(dt)
    self.player.currentAnimation:update(dt)
end