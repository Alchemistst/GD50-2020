HumanController = Class{}

--[[
    Controller class creates a new HumanController. Param:
    player -> The paddle we want to control.
    whichPlayer -> Sets where the controls of the player are.
                -> 1 for wasd
                -> 2 for up, left, down, right

]]--

function HumanController:init(player, whichPlayer)
    self.player = player
    self.whichPlayer= whichPlayer
end

function HumanController:control()
    if (self.whichPlayer == 1) then
        if love.keyboard.isDown('s') then
            self.player:moveDown()
        elseif love.keyboard.isDown('w') then
            self.player:moveUp()
        else
            self.player:stop()
        end
    else
        if love.keyboard.isDown('down') then
            self.player:moveDown()
        elseif love.keyboard.isDown('up') then
            self.player:moveUp()
        else
            self.player:stop()
        end
    end
    
end