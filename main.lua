Class = require 'lib.middleclass'
Gamestate = require 'lib.hump.gamestate'
Vector = require 'lib.hump.vector'
local lume = require 'lib.lume'

Levels = {}
Entities = {}

Menu = require 'states.menu'
PreGame = require 'states.pre_game'
Game = require 'states.game'
GameOver = require 'states.game_over'

love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(Menu)
  love.window.setTitle('My Arkanoid Clone')
  local meter = 64
  love.physics.setMeter(meter)
  local gravity = 9.81*meter
  World = love.physics.newWorld(0, gravity, true)
  World:setCallbacks(beginContact, endContact, preSolve, postSolve)
  love.mouse.setGrabbed(true)
end

function love.update(dt)
end

function love.draw()
end

function love.keypressed(k)
  if k == 'escape' then
    love.event.quit()
  end
end

-- collisions callback

function beginContact(a, b, contact)
  local dx, dy = contact:getNormal()
  local aData = a:getUserData()
  local bData = b:getUserData()
  -- ball/bricks collisions
  if aData[1] == 'Ball' and bData[1] == 'Brick' then
    Entities.bricks[bData[2]].physicalObject.body:destroy()
    lume.remove(Entities.bricks, Entities.bricks[bData[2]])
  elseif bData[1] == 'Ball' and aData[1] == 'Brick' then
    Entities.bricks[aData[2]].physicalObject.body:destroy()
    lume.remove(Entities.bricks, Entities.bricks[aData[2]])
  end
end

function endContact(a, b, coll)
  local textA = a:getUserData()
  local textB = b:getUserData()
  
end

function preSolve(a, b, coll)
  local textA = a:getUserData()
  local textB = b:getUserData()
  
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
  
end

--TODO: extract text drawing system
function CenterText(string_array, color, vertical_offset)
  local font = love.graphics.getFont()
  local text_array = {}
  for _, string in pairs(string_array) do
    local text = love.graphics.newText(font, string)
    table.insert(text_array, text)
  end
  
  local widths = {}
  for i, text in pairs(text_array) do
    widths[i] = text:getWidth()
  end
  
  local width = math.max(unpack(widths))
  
  local height = font:getHeight()
  love.graphics.setColor(color)
  for i, text in pairs(text_array) do
    love.graphics.draw(text, love.graphics.getWidth()/2-width/2, vertical_offset-height/2+(i-1)*height)
  end
end

function TableLength(table)
  local count = 0
  for _ in pairs(table) do count = count + 1 end
  return count
end