PlayerWalkingPotState = Class{__includes = EntityWalkState}

function PlayerWalkingPotState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerWalkingPotState:enter(params)
    self.objectHeld = params.object
end

function PlayerWalkingPotState:update(dt)

    -- *Update the coordinates of the object so it follows the player
    self.objectHeld.item.x = self.entity.x + self.entity.width / 2 - self.objectHeld.item.width / 2
    self.objectHeld.item.y = self.entity.y - self.objectHeld.item.height / 2 + 1

    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-pot-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-pot-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-pot-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-pot-down')
    else
        self.entity:changeState('idle-pot', {['object']= self.objectHeld})
    end

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)

    -- *Check for consumables in this state to avoid the object to be consumed when the sword swing, 
    -- *looking as if the object is not really being spawned
    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if self.entity:collides(object) then
            if object.consumable then
                object.onConsume(self.entity)
                table.remove(self.dungeon.currentRoom.objects, k)
            end
        end
    end
end