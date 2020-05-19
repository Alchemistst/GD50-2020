--[[
    Flag is created as an entity so it can have a state, but without
    adding extra complexity to the project structure by creating another 
    type of game object with a state.
]]


Flag = Class{__includes = Entity}

function Flag:init(def)
    Entity.init(self, def)
end

function Flag:update(dt)
    Entity.update(self, dt)
end

function Flag:render()
    Entity.render(self)
end