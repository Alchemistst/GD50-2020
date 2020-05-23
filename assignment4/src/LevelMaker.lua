--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}
    local map

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- *Flag to check if we had already spawn a key
    local keyWasSpawn = false
    -- *Flag to check if we had already spawn a locked block
    local lockedBlockWasSpawn = false

    local outline

    local accessible = false

while not keyWasSpawn or not lockedBlockWasSpawn or not accessible do
    
    tiles = {}
    entities = {}
    objects = {}
    keyWasSpawn = false
    lockedBlockWasSpawn = false

    -- *To prevent unaccessible blocks to spwan, we create an outline of the level 
    -- * pilar = 1, block = 2, anything else = 0
    -- * if 1,2,2,...,2,1 is found, then there are unaccessible blocks
    outline = {}
    
    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        -- *Changed so on the first and 3 last columns there's never a chasm
        if (x ~= 1 and x <= width - 3) and math.random(math.random(3,7)) == 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
            -- *Add flat to outline
            table.insert(outline, x, 0)
        else
            tileID = TILE_ID_GROUND

            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            table.insert(outline, x, 0)

            -- !CHANCE TO GENERATE PILLAR
            -- chance to generate a pillar
            if math.random(8) == 1 then
                -- *Add pillar to outline
                outline[x] = 1
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end
-- !blocks
            -- *Flag to check if the next block will contain the key.
            local spawnKey = math.random(width - (x - 4)) == 1 and not keyWasSpawn
            -- *Flag to check if the next block will be a locked block.
            local spawnLockedBlock = math.random(width - (x - 4)) == 1 and not lockedBlockWasSpawn
            
            -- chance to spawn a block
            if (x > 1) and (x <= width - 3) and (math.random(10) == 1 or ((spawnKey or spawnLockedBlock) and not (spawnKey and spawnLockedBlock))) then
                -- *Add block to outline
                if outline[x] ~= 1 then
                    outline[x] = 2
                elseif outline[x] == 1 then
                    outline[x] = 3
                end
                -- *If so, change keyWasSpawn to true so the key doesn't generate again    
                if spawnKey and not spawnLockedBlock then
                    keyWasSpawn = true
                    print('key at '..x)
                end
                -- *If so, change lockedBlockWasSpawn to true so the locked block doesn't generate again    
                if spawnLockedBlock and not spawnKey then
                    lockedBlockWasSpawn = true
                    print('lock at '..x)
                end
                -- *Spawn lockedBlock
                if spawnLockedBlock then
                    table.insert(objects,
                        GameObject {
                            texture = 'keys-locks',
                            x = (x - 1) * TILE_SIZE,
                            y = (blockHeight - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,

                            -- make it a random variant
                            frame = LOCKS[math.random(#LOCKS)],
                            collidable = true,
                            hit = false,
                            solid = true,
                            onCollide = function (obj, player, k)
                                if player.keyAcquired then
                                    gSounds['unlocked']:play()
                                    player.flagAcquired = true
                                    table.remove(player.level.objects, k)
                                end
                            end
                        }
                )
                else
                    table.insert(objects,
                        -- jump block
                        GameObject {
                            texture = 'jump-blocks',
                            x = (x - 1) * TILE_SIZE,
                            y = (blockHeight - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,

                            -- make it a random variant
                            frame = math.random(#JUMP_BLOCKS),
                            collidable = true,
                            hit = false,
                            solid = true,

                            -- collision function takes itself
                            onCollide = function(obj)

                                -- spawn a gem if we haven't already hit the block
                                if not obj.hit then

                                    -- chance to spawn gem, not guaranteed
                                    -- *Added chance to spawn a Key, which IS guaranteed
                                    if math.random(5) == 1 or spawnKey then
                                        if spawnKey then                                    
                                            -- maintain reference so we can set it to nil
                                            local key = GameObject {
                                                texture = 'keys-locks',
                                                x = (x - 1) * TILE_SIZE,
                                                y = (blockHeight - 1) * TILE_SIZE - 4,
                                                width = 16,
                                                height = 16,
                                                frame = math.random(#KEYS),
                                                collidable = true,
                                                consumable = true,
                                                solid = false,

                                                onConsume = function(player, object)
                                                    gSounds['pickup']:play()
                                                    player.keyAcquired = true
                                                end
                                            }
                                            
                                            -- *make the key move up from the block and play a sound
                                            Timer.tween(0.1, {
                                                [key] = {y = (blockHeight - 2) * TILE_SIZE}
                                            })
                                            gSounds['powerup-reveal']:play()

                                            table.insert(objects, key)

                                        else
                                            -- maintain reference so we can set it to nil
                                            local gem = GameObject {
                                                texture = 'gems',
                                                x = (x - 1) * TILE_SIZE,
                                                y = (blockHeight - 1) * TILE_SIZE - 4,
                                                width = 16,
                                                height = 16,
                                                frame = math.random(#GEMS),
                                                collidable = true,
                                                consumable = true,
                                                solid = false,

                                                -- gem has its own function to add to the player's score
                                                onConsume = function(player, object)
                                                    gSounds['pickup']:play()
                                                    player.score = player.score + 100
                                                end
                                            }
                                            
                                            -- make the gem move up from the block and play a sound
                                            Timer.tween(0.1, {
                                                [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                            })
                                            gSounds['powerup-reveal']:play()

                                            table.insert(objects, gem)
                                        end
                                    end

                                    obj.hit = true
                                end

                                gSounds['empty-block']:play()
                            end
                        }
                    )
                end
            end
            -- *Generate pole for the flag
            if x == width - 1 then
                print('pole!')
                table.insert(objects,
                GameObject{
                    texture = 'poles',
                    x = (x - 1) * TILE_SIZE + 4,
                    y = (blockHeight - 1) * TILE_SIZE,
                    width = 8,
                    height = 48,
                    frame = math.random(#POLES_IDS),
                    collidable = true,
                    solid = false,
                    triggerable = true,
                    hit = false,
                    onCollide = 
                        function(obj, player)
                            if player.flagAcquired then
                                if not obj.hit then
                                    print('Flag!')
                                    local flag 
                                    flag = Entity{
                                        x = (x - 1) * TILE_SIZE + 6,
                                        y = (blockHeight+1) * TILE_SIZE,
                                        texture = 'flag',
                                        width = 16,
                                        height = 15,
                                        stateMachine = StateMachine{
                                            ['waving'] = function() return FlagWavingState(flag, player)  end,
                                            ['down'] = function() return FlagDownState(flag, player) end
                                        }
                                    }
                                    
                                    flag.direction = 'right'
                                    
                                    flag:changeState('down')

                                    -- *Get the player into the Celebration State! Hooray!
                                    player:changeState('celebration')
                                    
                                    gSounds['goal']:play()

                                    Timer.tween(2, {
                                        [flag] = {y = (blockHeight - 1) * TILE_SIZE + 4}
                                    }):finish(
                                        function () 
                                            flag:changeState('waving') 
                                            -- !Change for animation in future
                                            local params ={
                                                score = player.score,
                                                width = width + 10
                                            }
                                            Timer.after(3, function () gStateMachine:change('play', params) end)
                                        end
                                    )

                                   
                                    table.insert(entities, flag)
                                    
                                    obj.hit = true
                                end
                            end
                        end
                }
            )
            end
        end
    end

    map = TileMap(width, height)
    map.tiles = tiles

    -- *Check outline for unaccessible blocks
    print("level width: "..width)
    print("level length: "..#outline)
    print("level tiles: "..#tiles[1])
    print("Before: "..table.concat(outline, ", "))
    local match = false
    local counter = 1
    while counter <= #outline do
        if outline[counter] == outline[counter+1] then
            table.remove(outline, counter + 1)
        else
            counter = counter + 1
        end
    end

    accessible = true
    
    for i=1, #outline-2 do
        local check = table.concat({outline[i], outline[i+1], outline[i+2]})
        if check == "121" or check == "232" or check == "123" or check == "321" then
            print("We found it at "..i)
            accessible = false
        end
    end
    print("After: "..table.concat(outline, ", "))

        if not keyWasSpawn or not lockedBlockWasSpawn then
            print('regenerating')
        end
end

return GameLevel(entities, objects, map)
end