FlagDownState = Class{__includes = BaseState}

function FlagDownState:init(flag, player)
    self.flag = flag
    self.player = player
    self.animation = Animation {
        frames = {3},
        interval = 0.25
    }
    self.flag.currentAnimation = self.animation
end

function FlagDownState:update(dt)
    self.flag.currentAnimation:update(dt)
end