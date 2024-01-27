local menu = {}
local pre_game = require 'states.pre_game'

local screen_width = love.graphics.getWidth()
local screen_height = love.graphics.getHeight()

function menu:enter()
  love.mouse.setVisible(true)
end

function menu:draw()
  local margin = 100
  love.graphics.setColor(0.8, 0.8, 0.8)
  love.graphics.rectangle('fill', margin, margin, screen_width-margin*2, screen_height/2 - margin)
  CenterText({'Welcome to Brahrkanoid', '', 'Press Enter to play'}, {0, 0, 0.2}, screen_height/4)
end

function menu:keypressed(k)
  if Gamestate.current() == menu and k == 'return' then
    Gamestate.switch(pre_game)
  end
end

return menu