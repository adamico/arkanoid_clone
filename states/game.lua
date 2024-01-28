local game = {}
local Level = require 'entities.level'

function game:enter()
  Entities.level = Level:new()
  love.mouse.setVisible(false)
  Entities.ball:setInMotion()
end

function game:update(dt)
  World:update(dt)
  Entities.player.physicalObject.joint:setTarget(love.mouse.getPosition())
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