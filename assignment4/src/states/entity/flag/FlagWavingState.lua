FlagWavingState = Class{__includes = BaseState}

function FlagWavingState:init(flag, player)
    self.flag = flag
    self.player = player
    self.animation = Animation {
        frames = {1,2},
        interval = 0.25
    }
    self.flag.currentAnimation = self.animation
end

function FlagWavingState:update(dt)
    self.flag.currentAnimation:update(dt)
end