--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
    self.medal = nil
    if(self.score >= 1 and self.score <= 2) then self.medal = love.graphics.newImage("bronzemedal.png")
    elseif(self.score >= 3 and self.score <= 4) then self.medal = love.graphics.newImage("silvermedal.png")
    elseif(self.score >= 5 and self.score <= 6) then self.medal = love.graphics.newImage("goldmedal.png")
    elseif(self.score >= 7) then self.medal = love.graphics.newImage("rainbowmedal.png") end
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end

end

    
    

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 55, VIRTUAL_WIDTH, 'center')

    
    love.graphics.setColor(69,40,60)
    love.graphics.rectangle("fill", VIRTUAL_WIDTH/2 - 100, VIRTUAL_HEIGHT/2 - 60, 200, 120, 5, 5)
    love.graphics.setColor(238,195,154)
    love.graphics.rectangle("fill", VIRTUAL_WIDTH/2 - 98, VIRTUAL_HEIGHT/2 - 58, 196, 116, 5, 5)
    love.graphics.setColor(255,255,255)

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Medal', VIRTUAL_WIDTH/2 - 80, VIRTUAL_HEIGHT/2 - 45, 100)
    love.graphics.setColor(223, 176, 131)
    love.graphics.circle("fill", VIRTUAL_WIDTH/2 - 60, VIRTUAL_HEIGHT/2 - 10, 20)
    love.graphics.setColor(255, 255, 255)
    if self.medal then love.graphics.draw(self.medal, VIRTUAL_WIDTH/2 - 80, VIRTUAL_HEIGHT/2 - 30) end
    love.graphics.setColor(255,255,255)
    love.graphics.printf('Score: ' .. tostring(self.score), VIRTUAL_WIDTH/2 + 20, VIRTUAL_HEIGHT/2 - 45, 60)
    love.graphics.printf('Press Enter to Play Again!', 0, VIRTUAL_HEIGHT/2 + 35, VIRTUAL_WIDTH, 'center')

end