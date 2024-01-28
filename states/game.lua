local game = {}

function game:enter(current, current_level)
  local current_level = current_level or levelLoader.current_level
  Entities.level = levelLoader:loadCurrentLevel()
  love.mouse.setVisible(false)
  Entities.ball:setInMotion()
end

function game:update(dt)
  World:update(dt)
  Entities.player.physicalObject.joint:setTarget(love.mouse.getPosition())
  if TableLength(Entities.bricks) == 0 then
    game:next_level()
  end
end

function game:keypressed(key)
  if key == 'c' then
    for _, brick in pairs(Entities.bricks) do
      brick.physicalObject.body:destroy()
    end
    game:next_level()
  end
end

function game:next_level()
  local current_level = levelLoader.current_level
  if  current_level < #levelLoader.sequence then
    levelLoader.current_level = current_level + 1
    Entities.ball:reposition()
    Entities.bricks = {}
    Gamestate.switch(game)
  else
    Gamestate.switch(GameOver)
  end
end
-- function game:mousemoved(x, y, dx, dy, istouch)
--     if love.mouse.isDown(1) then
--         Entities.player.body:setAngle(dx / math.pi + math.pi/8 * dx)
--     else
--         Entities.player.body:setAngle(math.pi)
--     end
-- end

function game:draw()
  Entities.level:draw()
  Entities.ball:draw()
  Entities.player:draw()
end

return game