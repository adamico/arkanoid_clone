local Level = Class('Level')
local Wall = require 'entities.wall'
local Brick = require 'entities.brick'

local screen_width = love.graphics.getWidth()
local screen_height = love.graphics.getHeight()

function Level:initialize(level_pattern)
  Level:constructWalls()
  Level:constructBricks(level_pattern)
end

function Level.static:constructWalls()
  local wall_thickness = Wall.defaultThickness()
  local top_center = {x = screen_width/2, y = wall_thickness/2}
  local right_center = {x = screen_width - wall_thickness/2, y = screen_height/2}
  local bottom_center = {x = screen_width/2, y = screen_height - wall_thickness/2}
  local left_center = {x = wall_thickness/2, y = screen_height/2}

  Entities.walls = {
    Wall:new('top', top_center, screen_width, wall_thickness, active),
    Wall:new('right', right_center, wall_thickness, screen_height, active),
    Wall:new('bottom', bottom_center, screen_width, wall_thickness, active),
    Wall:new('left', left_center, wall_thickness, screen_height, active)
  }
end

function Level.static:constructBricks(level_pattern)
  local brick_index = ''
  local top_left_position = {x = 70, y = 70}
  local width, height = 50, 30
  local gap = 10
  local color_codes = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}
  Entities.bricks = {}
  for row_index, row in ipairs(level_pattern) do
    for col_index, brick_type in ipairs(row) do
      brick_index = row_index..col_index
      if brick_type ~= 0 then
        local position = {
          x = top_left_position.x + width/2 + (col_index - 1) * (width + gap),
          y = top_left_position.y + height/2 + (row_index - 1) * (height + gap)
        }
        local brick = Brick:new(brick_index, position, width, height, color_codes[brick_type])
        Entities.bricks[brick_index] = brick
      end
    end
  end
end

function Level:draw()
  Level:drawWalls()
  Level:drawBricks()
end

function Level.static:drawWalls()
  for _, wall in pairs(Entities.walls) do
    wall:draw()
  end
end

function Level.static:drawBricks()
  for _, brick in pairs(Entities.bricks) do
    brick:draw()
  end
end

return Level