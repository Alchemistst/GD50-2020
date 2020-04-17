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
    --This function moves the paddle to make sure the ball always stays within range of the paddle.
    --If the ball is above the paddle it moves up, and if bellow, down.
    --I reduced the range to activate the movement (those 2/3 and 1/3 coeficients) to make it a bit more
    --acurate. Also, it's not just hitting it right on the edge of the paddle.
    if (self.player.y + self.player.height*2/3) < (self.ball.y + self.ball.height) then
        self.player:moveDown()
    elseif (self.player.y + self.player.height*1/3) > self.ball.y then
        self.player:moveUp()
    else
        self.player:stop()
    end
end