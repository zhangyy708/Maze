PlayState = Class{__includes = BaseState}

function PlayState:init()

end

function PlayState:enter(def)

    gSounds['music-menu']:stop()
    gSounds['music']:play()

    self.level = def.level

    self.player = Player {
        animations = ENTITY_DEFS['player1'].animations,
        walkSpeed = ENTITY_DEFS['player1'].walkSpeed,
        
        x = 0,
        y = 0,

        width = 16,
        height = 16,

        type = 1, 
        score = def.score or 0
    }

    self.maze = Maze{
        player = self.player, 
        level = self.level
    }

    -- adjust player's default position
    self.player.x = self.maze.renderOffsetX + (self.maze.startPos[2] - 1) * TILE_SIZE
    self.player.y = self.maze.renderOffsetY + (self.maze.startPos[1] - 1) * TILE_SIZE
    
    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player, self.maze) end,
        ['idle'] = function() return PlayerIdleState(self.player) end
    }
    self.player:changeState('idle')

    self.timer = TIME_LIMIT

    Timer.every(2, function()
        self.timer = self.timer - 1
    end)

end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- game over if time runs out
    if self.timer <= 0 then
        
        -- clear timers from prior PlayStates
        Timer.clear()
        
        gSounds['game-over']:play()

        gStateMachine:change('game-over', {
            score = self.player.score + self.player.bonus, 
            result = 'lose'
        })
    end

    -- reset the game if pressing r
    if love.keyboard.wasPressed('r') then
        gSounds['reset']:play()

        local player = self.player
        local level = self.maze.level

        -- reset the maze
        self.maze = nil
        self.maze = Maze{
            player = player,
            level = level
        }

        -- reset player position & change to player1
        self.player.animations = self.player:createAnimations(ENTITY_DEFS['player1'].animations)
        self.player.walkSpeed = ENTITY_DEFS['player1'].walkSpeed
        self.player.x = self.maze.renderOffsetX + (self.maze.startPos[2] - 1) * TILE_SIZE
        self.player.y = self.maze.renderOffsetY + (self.maze.startPos[1] - 1) * TILE_SIZE
        self.player.type = 1
        
        -- reset score
        self.player.bonus = 0

        -- do not reset timer
    end

    self.maze:update(dt)

    Timer.update(dt)
end

function PlayState:render()
    
    love.graphics.push()
    self.maze:render()
    love.graphics.pop()

    love.graphics.setColor(213/255, 238/255, 243/255, 1)
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Time Left: '..tostring(self.timer)..'s', 
        20, 40, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Score: '..tostring(self.player.score + self.player.bonus), 
        20, 70, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Level: '..tostring(self.maze.level), 
        20, 100, VIRTUAL_WIDTH, 'left')

end