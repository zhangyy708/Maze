StartState = Class{__includes = BaseState}

function StartState:enter()
    gSounds['music-menu']:play()
end

function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            level = 1
        })
    end
end

function StartState:render()
    love.graphics.draw(gTextures['background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['background']:getHeight())

    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(213/255, 238/255, 243/255, 1)
    love.graphics.printf('Maze', 2, VIRTUAL_HEIGHT / 2 - 60, VIRTUAL_WIDTH, 'center')

    -- love.graphics.setColor(8/255, 42/255, 50/255, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 64, VIRTUAL_WIDTH, 'center')
end