Maze = Class{}

function Maze:init(def)

    self.player = def.player
    self.level = def.level

    -- the number of tiles (floor)
    self.width = 9 + self.level
    self.height = self.width

    -- to center maze rendering
    self.renderOffsetX = (VIRTUAL_WIDTH - (self.width * TILE_SIZE)) / 2
    self.renderOffsetY = (VIRTUAL_HEIGHT - (self.height * TILE_SIZE)) / 2

    -- generate maze for each level
    self.map = {}
    self:generateMap()

    -- generate start and end positions for each level
    self.startPos = {0, 0}
    self.endPos = {0, 0}

    -- generate bonus (hearts) positions
    self.hearts = {}
    
    -- generate objects
    self.objects = {}
    self:generateObjects()

    -- used for checking movement
    self.check = {
        left = {xPos = 0, yPos = 0, xPos0 = 0, yPos0 = 0},
        right = {xPos = 0, yPos = 0, xPos0 = 0, yPos0 = 0},
        up = {xPos = 0, yPos = 0, xPos0 = 0, yPos0 = 0},
        down = {xPos = 0, yPos = 0, xPos0 = 0, yPos0 = 0}
    }

end

function Maze:generateMap()

    -- walls on four sides & floor
    for y = 1, self.height do
        table.insert(self.map, {})

        if y == 1 or y == self.height then
            for x = 1, self.width do
                table.insert(self.map[y], {
                    id = 'wall'
                })
            end
        else
            for x = 1, self.width do
                if x == 1 or x == self.width then
                    table.insert(self.map[y], {
                        id = 'wall'
                    })
                else
                    table.insert(self.map[y], {
                        id = 'floor'
                    })
                end
            end
        end
    end

    -- obstacle walls for each level
    for i, position in ipairs(MAP_WALLS[self.level]) do
        self.map[position[1]][position[2]].id = 'wall'
    end

end

function Maze:generateObjects()
    -- start and end positions
    self.startPos = MAP_START[self.level]
    self.endPos = MAP_END[self.level]

    -- add start switch
    table.insert(self.objects, GameObject(
        GAME_OBJECT_DEFS['switch-start'], 
        (self.startPos[2] - 1) * TILE_SIZE + self.renderOffsetX, 
        (self.startPos[1] - 1) * TILE_SIZE + self.renderOffsetY
    ))

    -- add end switch
    local switch = GameObject(
        GAME_OBJECT_DEFS['switch-end'], 
        (self.endPos[2] - 1) * TILE_SIZE + self.renderOffsetX,
        (self.endPos[1] - 1) * TILE_SIZE + self.renderOffsetY
    )

    switch.onCollide = function()
        switch.state = 'color'..tostring(self.player.type)

        if self.player.type < #PLAYERS then
            gSounds['new-player']:play()
            
            self.player.type = self.player.type + 1
            self.player.animations = self.player:createAnimations(
                ENTITY_DEFS['player'..tostring(self.player.type)].animations)
            self.player.x = self.renderOffsetX + (self.startPos[2] - 1) * TILE_SIZE
            self.player.y = self.renderOffsetY + (self.startPos[1] - 1) * TILE_SIZE

        else
            Timer.clear()
            
            if self.level < 2 then
                gSounds['level-up']:play()

                gStateMachine:change('play', {
                    level = self.level + 1,
                    score = self.player.score + self.player.bonus
                })
            else

                gStateMachine:change('game-over', {
                    score = self.player.score + self.player.bonus,
                    result = 'win'
                })
            end

        end
    end

    table.insert(self.objects, switch)
    
    -- add hearts
    self.hearts = MAP_HEARTS[self.level]
    for i = 1, #self.hearts do
        local heart = GameObject(
            GAME_OBJECT_DEFS['heart'], 
            (self.hearts[i][2] - 1) * TILE_SIZE + self.renderOffsetX, 
            (self.hearts[i][1] - 1) * TILE_SIZE + self.renderOffsetY
        ) 

        heart.onCollide = function()
            gSounds['pick-up']:play()

            heart.visible = false
            self.player.bonus = self.player.bonus + BONUS_HEART
            heart.onCollide = function() end
        end

        table.insert(self.objects, heart)
    end

    -- add walls as objects (in order to easily detect collision)
    for y = 1, self.height do
        for x = 1, self.width do
            if self.map[y][x].id == 'wall' then
                local wall = GameObject(
                    GAME_OBJECT_DEFS['wall'], 
                    (x - 1) * TILE_SIZE + self.renderOffsetX, 
                    (y - 1) * TILE_SIZE + self.renderOffsetY
                )

                table.insert(self.objects, wall)
            end
        end
    end

end

function Maze:update(dt)
    self.player:update(dt)

    -- if player passes a tile, a wall should be built
    self:checkMovement()

    -- check collision with objects
    for k, object in pairs(self.objects) do

        object:update(dt)

        -- trigger collision callback on object
        if self.player:collides(object) then
            object:onCollide()

            if object.solid then
                if self.player.direction == 'left' then
                    self.player.x = self.player.x + self.player.walkSpeed * dt
                elseif self.player.direction == 'right' then
                    self.player.x = self.player.x - self.player.walkSpeed * dt
                elseif self.player.direction == 'up' then
                    self.player.y = self.player.y + self.player.walkSpeed * dt
                elseif self.player.direction == 'down' then
                    self.player.y = self.player.y - self.player.walkSpeed * dt
                end
            end

        end

    end

    -- reset start and end positions to 'floor'
    self.map[self.startPos[1]][self.startPos[2]].id = 'floor'
    self.map[self.endPos[1]][self.endPos[2]].id = 'floor'

end

--[[
    if player passes a floor tile, there should be a wall built
    since the criteria of 'passing a tile' on four directions are different, 
    the function incorporates four conditions for all directions
]]
function Maze:checkMovement()
    -- Pos0: position of player in the last frame
    -- Pos: position of player in the current frame
    -- any difference between Pos and Pos0 indicates that player passes a tile


    -- update Pos
    -- to left
    self.check['left'].xPos = math.floor((self.player.x + self.player.width - 
        self.renderOffsetX - 1) / TILE_SIZE) + 1
    self.check['left'].yPos = math.floor((self.player.y + self.player.height - 
        self.renderOffsetY) / TILE_SIZE) + 1

    -- to right
    self.check['right'].xPos = math.floor((self.player.x - 
        self.renderOffsetX) / TILE_SIZE) + 1
    self.check['right'].yPos = math.floor((self.player.y + self.player.height - 
        self.renderOffsetY) / TILE_SIZE) + 1

    -- to up
    self.check['up'].xPos = math.floor((self.player.x + self.player.width / 2 - 
        self.renderOffsetX) / TILE_SIZE) + 1
    self.check['up'].yPos = math.floor((self.player.y + self.player.height - 
        self.renderOffsetY - 1) / TILE_SIZE) + 1

    -- to down
    self.check['down'].xPos = math.floor((self.player.x + self.player.width / 2 - 
        self.renderOffsetX) / TILE_SIZE) + 1
    self.check['down'].yPos = math.floor((self.player.y + self.player.height / 2 - 
        self.renderOffsetY) / TILE_SIZE) + 1
        --[[
            self.player.height / 2  on the above line is a compromise, 
            it should be self.player.height, but this will cause player to be stuck
        ]]

    -- initiation
    for k, direction in ipairs({'left', 'right', 'up', 'down'}) do
        if self.check[direction].xPos0 == 0 or self.check[direction].yPos0 == 0 then
            self.check[direction].xPos0 = self.check[direction].xPos
            self.check[direction].yPos0 = self.check[direction].yPos
        end
    end

    -- do not add walls on start and end positions

    -- check whether player has passed a tile
    -- to left
    if self.check['left'].xPos < self.check['left'].xPos0 and 
        (not (self.check['left'].xPos0 == self.startPos[2] and self.check['left'].yPos0 == self.startPos[1])) and
        (not (self.check['left'].xPos0 == self.endPos[2] and self.check['left'].yPos0 == self.endPos[1])) and
        self.player.direction == 'left' then

        self.map[self.check['left'].yPos0][self.check['left'].xPos0].id = 'wall'
        local wall = GameObject(
            GAME_OBJECT_DEFS['wall'], 
            (self.check['left'].xPos0 - 1) * TILE_SIZE + self.renderOffsetX, 
            (self.check['left'].yPos0 - 1) * TILE_SIZE + self.renderOffsetY
        )

        table.insert(self.objects, wall)

        self.check['left'].xPos0 = self.check['left'].xPos

        -- update score
        self.player.bonus = self.player.bonus + BONUS

    else
        self.check['left'].xPos0 = self.check['left'].xPos
        self.check['left'].yPos0 = self.check['left'].yPos
    end

    -- to right
    if self.check['right'].xPos > self.check['right'].xPos0 and 
        (not (self.check['right'].xPos0 == self.startPos[2] and self.check['right'].yPos0 == self.startPos[1])) and
        (not (self.check['right'].xPos0 == self.endPos[2] and self.check['right'].yPos0 == self.endPos[1])) and
        self.player.direction == 'right' then

        self.map[self.check['right'].yPos0][self.check['right'].xPos0].id = 'wall'
        local wall = GameObject(
            GAME_OBJECT_DEFS['wall'], 
            (self.check['right'].xPos0 - 1) * TILE_SIZE + self.renderOffsetX, 
            (self.check['right'].yPos0 - 1) * TILE_SIZE + self.renderOffsetY
        )

        table.insert(self.objects, wall)

        self.check['right'].xPos0 = self.check['right'].xPos

        -- update score
        self.player.bonus = self.player.bonus + BONUS
        
    else
        self.check['right'].xPos0 = self.check['right'].xPos
        self.check['right'].yPos0 = self.check['right'].yPos
    end

    -- to up
    if self.check['up'].yPos < self.check['up'].yPos0 and 
        (not (self.check['up'].xPos0 == self.startPos[2] and self.check['up'].yPos0 == self.startPos[1])) and
        (not (self.check['up'].xPos0 == self.endPos[2] and self.check['up'].yPos0 == self.endPos[1])) and
        self.player.direction == 'up' then

        self.map[self.check['up'].yPos0][self.check['up'].xPos0].id = 'wall'
        local wall = GameObject(
            GAME_OBJECT_DEFS['wall'], 
            (self.check['up'].xPos0 - 1) * TILE_SIZE + self.renderOffsetX, 
            (self.check['up'].yPos0 - 1) * TILE_SIZE + self.renderOffsetY
        )

        table.insert(self.objects, wall)

        self.check['up'].yPos0 = self.check['up'].yPos

        -- update score
        self.player.bonus = self.player.bonus + BONUS
        
    else
        self.check['up'].xPos0 = self.check['up'].xPos
        self.check['up'].yPos0 = self.check['up'].yPos
    end

    -- to down
    if self.check['down'].yPos > self.check['down'].yPos0 and 
        (not (self.check['down'].xPos0 == self.startPos[2] and self.check['down'].yPos0 == self.startPos[1])) and
        (not (self.check['down'].xPos0 == self.endPos[2] and self.check['down'].yPos0 == self.endPos[1])) and
        self.player.direction == 'down' then

        self.map[self.check['down'].yPos0][self.check['down'].xPos0].id = 'wall'
        local wall = GameObject(
            GAME_OBJECT_DEFS['wall'], 
            (self.check['down'].xPos0 - 1) * TILE_SIZE + self.renderOffsetX, 
            (self.check['down'].yPos0 - 1) * TILE_SIZE + self.renderOffsetY
        )

        table.insert(self.objects, wall)

        self.check['down'].yPos0 = self.check['down'].yPos

        -- update score
        self.player.bonus = self.player.bonus + BONUS
        
    else
        self.check['down'].xPos0 = self.check['down'].xPos
        self.check['down'].yPos0 = self.check['down'].yPos
    end            

end

function Maze:render()

    -- draw floor
    for y = 1, self.height do
        for x = 1, self.width do 
            local type = self.map[y][x].id

            if type == 'floor' then
                love.graphics.draw(gTextures['floor'], gFrames['floor'][3],
                    (x - 1) * TILE_SIZE + self.renderOffsetX, 
                    (y - 1) * TILE_SIZE + self.renderOffsetY)
            end
        end
    end

    -- draw objects
    for k, object in pairs(self.objects) do
        if object.type == 'wall' and
            ((object.x == (self.startPos[2] - 1) * TILE_SIZE + self.renderOffsetX and
            object.y == (self.startPos[1] - 1) * TILE_SIZE + self.renderOffsetY) or
            (object.x == (self.endPos[2] - 1) * TILE_SIZE + self.renderOffsetX and
            object.y == (self.endPos[1] - 1) * TILE_SIZE + self.renderOffsetY)) then
                -- do not draw walls on start and end positions
        else
            object:render()
        end
    end

    -- draw wall-top
    for y = 1, self.height do
        for x = 1, self.width do 
            local type = self.map[y][x].id

            if type == 'wall' then
                love.graphics.draw(gTextures['wall-top'], gFrames['wall-top'][1], 
                    (x - 1) * TILE_SIZE + self.renderOffsetX, 
                    (y - 1) * TILE_SIZE + self.renderOffsetY - TILE_SIZE / 2)
            end
        end
    end

    -- top-half of wall-top
    love.graphics.stencil(function()
        
        for y = 1, self.height do
            for x = 1, self.width do 
                local type = self.map[y][x].id
    
                if type == 'wall' then
                    love.graphics.rectangle('fill', 
                        (x - 1) * TILE_SIZE + self.renderOffsetX, 
                        (y - 1) * TILE_SIZE + self.renderOffsetY - TILE_SIZE / 2, 
                        TILE_SIZE,
                        TILE_SIZE)
                end
            end
        end

    end, 'replace', 1)

    love.graphics.setStencilTest('less', 1)
    
    -- draw player
    if self.player then
        self.player:render()
    end

    love.graphics.setStencilTest()  

end
