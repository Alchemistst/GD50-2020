BotController = Class{}

--[[
    Controller class creates a new BotController. Param:
    player -> The paddle we want to control.
    ball -> The ball object, to track its position.
    SPEED -> The speed defined for the paddle.

]]--

function BotController:init(player, ball)
    self.player = player
    self.ball = ball
end

function BotController:control()
    if (self.player.y + self.player.height * 2/3) < self.ball.y then
        self.player:moveDown()
    elseif (self.player.y + self.player.height * 1/3) > (self.ball.y + self.ball.height) then
        self.player:moveUp()
    else
        self.player:stop()
    end
end