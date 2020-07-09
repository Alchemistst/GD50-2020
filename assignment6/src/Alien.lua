--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Alien = Class{}

function Alien:init(world, type, x, y, userData)
    self.rotation = 0

    self.world = world
    self.type = type or 'square'

    self.body = love.physics.newBody(self.world, 
        x or math.random(VIRTUAL_WIDTH), y or math.random(VIRTUAL_HEIGHT - 35),
        'dynamic')

    -- different shape and sprite based on type passed in
    if self.type == 'square' then
        self.shape = love.physics.newRectangleShape(35, 35)
        self.sprite = math.random(5)
    else
        self.shape = love.physics.newCircleShape(17.5)
        self.sprite = userData['type'] 
        --* alien's speciall ability
        self.specialAbility = setSpecialAbility(userData['type'])
    end

    self.fixture = love.physics.newFixture(self.body, self.shape)

    self.fixture:setUserData(userData)

    -- used to keep track of despawning the Alien and flinging it
    self.launched = false

    --* flag for detecting the first collision, after which special abilities are disabled.
    self.firstCollision = false

    --* For adding some NOICE effects
    self.particleSystem = love.graphics.newParticleSystem( gTextures['particles'], 64 )
    self.particleSystem:setParticleLifetime(0.2, 0.5)
    self.particleSystem:setLinearAcceleration(-20, -20, 20, 20)
    self.particleSystem:setAreaSpread('normal', 10, 10)
    
end

function Alien:render()
    if not self.body:isDestroyed() then
        love.graphics.draw(gTextures[self.type..'_aliens'], gFrames[self.type..'_aliens'][self.sprite],
            math.floor(self.body:getX()), math.floor(self.body:getY()), self.body:getAngle(),
            1, 1, 17.5, 17.5)
    end
end

--* Set alien's special ability based on the type of alien that we are rendering
function setSpecialAbility(alienType)
    if alienType == TYPES_OF_ALIEN[2] then
        return function (alienLaunchMarker)
            for i=1, 2 do
                local extraAlien = Alien(alienLaunchMarker.world, 'round', alienLaunchMarker.alien.body:getX(), alienLaunchMarker.alien.body:getY(), {['group']='Player', ['type']=alienLaunchMarker.alienType})
                local vx, vy = alienLaunchMarker.alien.body:getLinearVelocity()
                if i==1 then extraAlien.body:setLinearVelocity(vx+5, vy+30) else extraAlien.body:setLinearVelocity(vx+5, vy-30) end
                extraAlien.body:setLinearDamping(0.4)
                table.insert(
                    alienLaunchMarker.extraAliens,
                    extraAlien
                )
            end
        end
    else
        return function()
        end
    end
end