PlayerIdlePotState = Class{__includes = EntityIdleState}
function PlayerIdlePotState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    self.entity:changeAnimation('idle-pot-' .. self.entity.direction)
end

function PlayerIdlePotState:enter(params)
    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0

    self.objectHeld = params.object
    self.objectHeld.item.solid = false

    -- *Create a Holdbox to check for holdable objects in front of the player
    local direction = self.entity.direction
    
    local holdboxX, holdboxY, holdboxWidth, holdboxHeight

    if direction == 'left' then
        holdboxWidth = 3
        holdboxHeight = 3
        holdboxX = self.entity.x - holdboxWidth
        holdboxY = self.entity.y + self.entity.height/2 - holdboxHeight/2
    elseif direction == 'right' then
        holdboxWidth = 3
        holdboxHeight = 3
        holdboxX = self.entity.x + self.entity.width
        holdboxY = self.entity.y + self.entity.height/2 - holdboxHeight/2
    elseif direction == 'up' then
        holdboxWidth = 3
        holdboxHeight = 3
        holdboxX = self.entity.x + self.entity.width/2 - holdboxWidth/2
        holdboxY = self.entity.y - holdboxHeight
    else
        holdboxWidth = 3
        holdboxHeight = 3
        holdboxX = self.entity.x + self.entity.width/2 - holdboxWidth/2
        holdboxY = self.entity.y + self.entity.height
    end

    self.holdbox = Hitbox(holdboxX, holdboxY, holdboxWidth, holdboxHeight)
end

function PlayerIdlePotState:update(dt)

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walking-pot', {['object']= self.objectHeld})
    end

    if love.keyboard.wasPressed('q') then
        --self.entity:changeState('swing-sword')
        self.entity:changeState('throwing', {['object'] = self.objectHeld})
    end
end