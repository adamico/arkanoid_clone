local walls = {thickness = 20}

local screen_width = love.graphics.getWidth()
local screen_height = love.graphics.getHeight()

function walls.construct(active)
  local active = active or true
  Entities.walls = {}
  local top_center = {x = screen_width/2, y = walls.thickness/2}
  local right_center = {x = screen_width - walls.thickness/2, y = screen_height/2}
  local bottom_center = {x = screen_width/2, y = screen_height - walls.thickness/2}
  local left_center = {x = walls.thickness/2, y = screen_height/2}
  
  walls.add_wall('top', top_center, screen_width, walls.thickness, active)
  walls.add_wall('right', right_center, walls.thickness, screen_height, active)
  walls.add_wall('bottom', bottom_center, screen_width, walls.thickness, active)
  walls.add_wall('left', left_center, walls.thickness, screen_height, active)
  
end

function walls.add_wall(direction, center, width, height, active)
  local object = {
    body = love.physics.newBody(World, center.x, center.y),
    shape = love.physics.newRectangleShape(width, height)
  }
  
  object.fixture = love.physics.newFixture(object.body, object.shape)
  object.fixture:setUserData({'Wall', direction})
  object.fixture:setRestitution(1)
  
  Entities.walls[direction] = object
end

function walls.draw()
  love.graphics.setColor(0.2, 0.2, 0.4)
  for direction, wall in pairs(Entities.walls) do
    love.graphics.polygon('fill', wall.body:getWorldPoints(wall.shape:getPoints()))
  end
end

return walls