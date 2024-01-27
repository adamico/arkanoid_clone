local pre_game = {}
local game = require 'states.game'

local ball = require 'entities.ball'
local player = require 'entities.player'

local screen_width = love.graphics.getWidth()
local screen_height = love.graphics.getHeight()

function pre_game:enter()
  ball.build()
  Entities.ball.body:setType('static')
  player.build()
end

function pre_game:draw()
  ball.draw()
  player.draw()
  local margin = 100
  love.graphics.setColor(0.8, 0.8, 0.8)
  love.graphics.rectangle('fill', margin, margin, screen_width-margin*2, screen_height/2 - margin)
  CenterText({'Position the bat and left click to start the game'}, {0, 0, 0.2}, screen_height/4)
end

function pre_game:update(dt)
  World:update(dt)
  player.move(dt)
end

function pre_game:mousereleased(x, y, button, istouch, presses)
  if button == 1 then
    Gamestate.switch(game)
  end
end

return pre_game