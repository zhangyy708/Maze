GameOverState = Class{__includes = BaseState}

function GameOverState:enter(def)
    self.score = def.score
    self.result = def.result

    gSounds['music']:stop()
    gSounds['music-menu']:play()
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(175/255, 53/255, 42/255, 1)
    if self.result == 'lose' then
        love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 2 - 120, VIRTUAL_WIDTH, 'center')
    elseif self.result == 'win' then
        love.graphics.printf('YOU WIN!!!', 0, VIRTUAL_HEIGHT / 2 - 120, VIRTUAL_WIDTH, 'center')
    end
    
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Score: '..tostring(self.score), 
        0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')
    -- love.graphics.setColor(8/255, 42/255, 50/255, 1)
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 66, VIRTUAL_WIDTH, 'center')
end