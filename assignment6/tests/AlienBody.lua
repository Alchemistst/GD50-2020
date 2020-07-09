AlienBody = Class{}

function AlienBody:init(world)
    self.body = love.physics.newBody( world, math.random(-30,640), math.random(-80,-2000), 'dynamic' )
    
    self.shape = love.physics.newCircleShape(17.5)

    self.sprite = gFrames['round_aliens'][math.random(1, #gFrames['round_aliens'])]
    
    self.fixture = love.physics.newFixture( 
        self.body, 
        self.shape, 
        1)
    
    self.fixture:setRestitution(math.random(1, 5)/10)

    self.fixture:setUserData({type = "alien"})
    
    self.body:setLinearVelocity(0, 30)
    
    self.body:setLinearDamping(0.2)

    self.type = 'alien'
end