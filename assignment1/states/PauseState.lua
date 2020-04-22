--[[
    State used to paused the game.
    On press of p key during a PlayState, this is state will be launched.
    On press of the same key, they PLayState will be resumed.
]]

PauseState = Class{__includes = BaseState}

function PauseState:enter(enterParams)
    self.currentGame = enterParams['currentGame']
    sounds['music']:pause()
end

function PauseState:update(dt)
    if love.keyboard.wasPressed("p") then
        gStateMachine:change('play', {['currentGame'] = self.currentGame})
    end
end

function PauseState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.currentGame['currentScore']), 8, 8)
    love.graphics.rectangle("fill", VIRTUAL_WIDTH/2 - 25, VIRTUAL_HEIGHT/2 - 50, 20, 50)
    love.graphics.rectangle("fill", VIRTUAL_WIDTH/2 + 5, VIRTUAL_HEIGHT/2 - 50, 20, 50)
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press p to resume', 0, VIRTUAL_HEIGHT/2 + 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press esc to rage quit', 0, VIRTUAL_HEIGHT/2 + 25, VIRTUAL_WIDTH, 'center')

end

function PauseState:exit()
    sounds['music']:play()
end