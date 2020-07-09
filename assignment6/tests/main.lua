require 'Dependencies'

function love.load()
world = love.physics.newWorld(0, 300, true)
world:setCallbacks(beginContact, endContact, preSolve, postSolve)



alienBodies = {}



title = 'GD50- ASSIGNMENT 6'
letterBodies = {}

for i=1, #title do
    Timer.after(i/6, function()
        -- table.insert(letterBodies, LetterBody(world, 50 + 32 * (i - 1)))
        local newLetterBody = LetterBody(world, love.graphics.getWidth() / 2 - 133 + 15 * (i - 1))
        
        table.insert(letterBodies, newLetterBody)
        for i, alien in pairs(alienBodies) do 
            alien.body:setLinearVelocity(math.random(400, 500), math.random(400, 500))
        end
    end)
end



--Start of ground
groundShape = love.physics.newEdgeShape(0, 0, 640 * 3, 0)
groundBody = love.physics.newBody(world, -640, 320, 'static')
groundFixture = love.physics.newFixture(groundBody, groundShape)
groundFixture:setFriction(0.7)
groundFixture:setUserData({type = "ground"})

--End of ground

Timer.after(8, function() 
        
    for i=0, 100 do 
        local newBody = AlienBody(world, 50)

        newBody.body:setLinearVelocity(100, 0)

        table.insert(alienBodies, newBody)
    end
    Timer.after(3, function()
        groundBody:destroy()
    end)
    
end)


end
 
function love.draw()
--love.graphics.rectangle( 'fill', letterBody.body:getX(), letterBody.body:getY(), 32, 32 )
    for i, body in pairs(letterBodies) do
        local c = title:sub(i,i)
        love.graphics.setFont(titleFont)
        love.graphics.printf(c, body.body:getX(), body.body:getY(), 200)
    end

    for i, body in pairs(alienBodies) do
        love.graphics.setColor(255,255,255)
        love.graphics.draw(gTextures['round_aliens'], body.sprite, body.body:getX(), body.body:getY())
    end
end
function love.update(dt)
    Timer.update(dt)
    world:update(dt)
end



function endContact(a, b, coll)
   local typeA = a:getUserData()['type']
   local typeB = b:getUserData()['type']

   if (typeA == "letter" and typeB == "ground") or (typeA == "ground" and typeB == "letter") then
        gSounds['bounce'..math.random(1,3)]:play()
   elseif not(typeA == "alien" and typeB == "alien") then
        gSounds['bounce']:play()
   end
end