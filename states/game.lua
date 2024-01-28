local game = {}
local Level = require 'entities.level'

Levels.sequence = {}
Levels.sequence[1] = {
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
  { 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1 },
  { 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1 },
  { 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0 },
  { 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0 },
  { 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 0 },
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

Levels.sequence[2] = {
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
  { 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1 },
  { 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0 },
  { 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0 },
  { 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0 },
  { 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1 },
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

function game:init()
  Levels.current_level = 1
end

function game:enter(current, current_level)
  local current_level = current_level or Levels.current_level
  Entities.level = Level:new(Levels.sequence[current_level])
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
  if Levels.current_level < #Levels.sequence then
    Levels.current_level = Levels.current_level + 1
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