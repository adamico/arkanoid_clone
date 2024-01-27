local game = {}
local ball = require 'entities.ball'
local bricks = require 'entities.bricks'
local player = require 'entities.player'
local walls = require 'entities.walls'

function game:enter()
  bricks.construct_level()
  walls.construct()
  love.mouse.setVisible(false)
  Entities.ball.body:setType('dynamic')
end

function game:update(dt)
  World:update(dt)
  Entities.player.joint:setTarget(love.mouse.getPosition())
end

-- function game:mousemoved(x, y, dx, dy, istouch)
--     if love.mouse.isDown(1) then
--         Entities.player.body:setAngle(dx / math.pi + math.pi/8 * dx)
--     else
--         Entities.player.body:setAngle(math.pi)
--     end
-- end

function game:draw()
  ball.draw()
  player.draw()
  bricks.draw()
  walls.draw()
end

return game