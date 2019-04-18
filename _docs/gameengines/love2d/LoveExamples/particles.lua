
function love.load()
    local img = love.graphics.newImage('assets/icon.png');

    psystem = love.graphics.newParticleSystem(img, 32);
    psystem:setParticleLifetime(1, 5); -- Particles live at least 2s and at most 5s.
    psystem:setEmissionRate(5);
    psystem:setSizeVariation(1);
    psystem:setLinearAcceleration(-120, -120, 120, 120); -- Random movement in all directions.
    psystem:setColors(255, 255, 255, 155, 255, 255, 255, 0); -- Fade to black.
end

function love.draw()
    -- Draw the particle system at the center of the game window.
    love.graphics.draw(psystem, love.mouse.getX(), love.mouse.getY());
end

function love.update(dt)
    psystem:update(dt);
end