LetterBody = Class{}

function LetterBody:init(world, x)
    self.body = love.physics.newBody( world, x, -30, 'dynamic')
    
    self.shape = love.physics.newRectangleShape( 12, 12 )
    
    self.fixture = love.physics.newFixture( 
        self.body, 
        self.shape, 
        199999)
    
    self.fixture:setRestitution(0.5)--math.random(1, 5)/10)

    self.fixture:setUserData({type = "letter"})
    
    self.body:setLinearVelocity(0, 30)
    
    self.body:setLinearDamping(0.2)

    self.type='letter'
end