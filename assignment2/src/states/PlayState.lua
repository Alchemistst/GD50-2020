--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.lockedBrick = params.lockedBrick
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.balls = {params.ball}
    self.level = params.level

    self.recoverPoints = 5000

    -- give ball random starting velocity
    self.balls[1].dx = math.random(-200, 200)
    self.balls[1].dy = math.random(-50, -60)
    
    --initialize table of powerups
    self.activePowerups = {}

    self.keyWasDropped = params.keyWasDropped or false
    self.keyAcquired = params.keyAcquired or false
    
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)

    for k, ball in pairs(self.balls) do
        ball:update(dt)

        if ball:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy

            --
            -- tweak angle of bounce based on where it hits the paddle
            --

            -- if we hit the paddle on its left side while moving left...
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
            
            -- else if we hit the paddle on its right side while moving right...
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end

            gSounds['paddle-hit']:play()
        end
    end
   
    

    -- detect collision across all bricks with the ball
    for k, brick in pairs(self.bricks) do
        for j, ball in pairs(self.balls) do
            -- only check collision if we're in play
            if brick.inPlay and ball:collides(brick) then

                -- add to score
                self.score = self.score + (brick.tier * 200 + brick.color * 25)
                
                local loot = function () self:unlonckedLoot() end
                
                -- trigger the brick's hit function, which removes it from play
                brick:hit(self.keyAcquired, loot)
                if not brick.inPlay then
                   table.remove(self.bricks, k ) 
                end
                
                -- spawn powerup
                if math.random(10) == 1 and (not brick.ISLOCKEDBRICK or brick.isUnlocked) then
                    self:spawnPowerup(brick.x +16, brick.y+8)
                end

                if self.lockedBrick and not self.keyWasDropped and (not brick.ISLOCKEDBRICK or brick.isUnlocked) then

                    if math.random(#self.bricks) <= 2 then --if math.random(#self.bricks) <= 2 then
                        self:spawnPowerup(brick.x +16, brick.y+8, true)
                        self.keyWasDropped = true
                    end
                end
                
                --[[

                -- if we have enough points, recover a point of health
                if self.score > self.recoverPoints then
                    -- can't go above 3 health
                    self.health = math.min(3, self.health + 1)

                    -- multiply recover points by 2
                    self.recoverPoints = math.min(100000, self.recoverPoints * 2)

                    -- play recover sound effect
                    gSounds['recover']:play()
                end

                ]]
                

                -- go to our victory screen if there are no more bricks left
                if self:checkVictory() then
                    gSounds['victory']:play()

                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        ball = ball,
                        recoverPoints = self.recoverPoints
                    })
                end

                --
                -- collision code for bricks
                --
                -- we check to see if the opposite side of our velocity is outside of the brick;
                -- if it is, we trigger a collision on that side. else we're within the X + width of
                -- the brick and should check to see if the top or bottom edge is outside of the brick,
                -- colliding on the top or bottom accordingly 
                --

                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                if ball.x + 2 < brick.x and ball.dx > 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x - 8
                
                -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
                
                -- top edge if no X collisions, always check
                elseif ball.y < brick.y then
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y - 8
                
                -- bottom edge if no X collisions or top collision, last possibility
                else
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end

                -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end

                -- only allow colliding with one brick, for corners
                break
            end
        end
    end

     -- filtering bricks which are not inPlay
     for k, brick in pairs(self.bricks) do
        if not brick.inPlay then
            table.remove( self.bricks, k)
        end
    end



    -- check balls going bellow bounds
        for k, ball in pairs(self.balls) do
            if ball.y >= VIRTUAL_HEIGHT then

                table.remove(self.balls, k) --Remove the ball from the table

                --Just revert state and apply consecuences if we lost all the balls
                if table.getn(self.balls) == 0 then 
                    self.health = self.health - 1
                    gSounds['hurt']:play()
            
                    --Also, if a powerup was augmenting the paddle, resize it to normal
                    self.paddle:setSize(2)
            
            
                    if self.health == 0 then
                        gStateMachine:change('game-over', {
                            score = self.score,
                            highScores = self.highScores
                        })
                    else
                        gStateMachine:change('serve', {
                            paddle = self.paddle,
                            bricks = self.bricks,
                            lockedBrick = self.lockedBrick,
                            health = self.health,
                            score = self.score,
                            highScores = self.highScores,
                            level = self.level,
                            recoverPoints = self.recoverPoints,
                            keyWasDropped = self.keyWasDropped,
                            keyAcquired = self.keyAcquired
                        })
                    end
                end
            end
        end

    

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    

    -- update powerups
    for k, powerup in pairs(self.activePowerups) do
        powerup:update(dt)

        --Check for collisions with paddle
        if powerup.y + 16 > self.paddle.y 
        and powerup.x + 16 > self.paddle.x 
        and powerup.x < self.paddle.x + self.paddle.width 
        and powerup.y < self.paddle.y + self.paddle.height
        then

            if powerup.type == 'growth' then
                self.paddle:setSize(math.min(self.paddle.size + 1, 4))
                gSounds['growth']:play()
            elseif powerup.type == 'doubleBall' then
                --Create new ball
                local newBall = Ball()
                newBall.skin = math.random(7) --Set skin
                --Set position
                newBall.x = self.paddle.x + (self.paddle.width / 2) - 4
                newBall.y = self.paddle.y - 8
                --Set speed
                newBall.dx = math.random(-200, 200)
                newBall.dy = math.random(-50, -60)
                table.insert(self.balls, newBall)
                gSounds['doubleBall']:play()
            elseif powerup.type == 'heart' then
                self.health = math.min(3, self.health + 1)
                gSounds['recover']:play()
            elseif powerup.type == 'key' then
                self.keyAcquired = true
                gSounds['key']:play()
            end

            table.remove(self.activePowerups, k)
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    --render powerups
    for k, powerup in pairs(self.activePowerups) do
        powerup:render()
    end

    self.paddle:render()
    for k, ball in pairs(self.balls) do
        ball:render()
    end

    renderScore(self.score)
    renderHealth(self.health)


    if self.keyAcquired then
       renderKey()
    end

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    --[[
            for k, brick in pairs(self.bricks) do
                    if brick.inPlay and (not brick.ISLOCKEDBRICK or brick.isUnlocked) then
                        return false
                    end 
                end
    ]]
    
    if #self.bricks == 0 or (self.lockedBrick and #self.bricks == 1 and not self.keyAcquired) then
        return true
    end

    return false
end



function PlayState:spawnPowerup(x, y, key)
    local p_type = key and "key" or POWERUP_LIST[math.random(3)]
    local p = Powerup(x, y, p_type) --So the powerup spawns in the middle of the block
    table.insert(self.activePowerups, p)
 
end

function PlayState:unlonckedLoot()
    self.score = self.score + 30000
end