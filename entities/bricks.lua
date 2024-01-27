local bricks = {}

bricks.width, bricks.height = 50, 30
bricks.rows, bricks.columns = 7, 11
bricks.top_left_position = {x = 70, y = 70}
bricks.gap = {width = 10, height = 10}

function bricks.construct_level()
  Bricks = {}
  local brick_index = ''
  for row = 1, bricks.rows do
    for col = 1, bricks.columns do
      local new_brick_position = {
        x = bricks.top_left_position.x +
        bricks.width/2 +
        (col - 1) *
        (bricks.width + bricks.gap.width),
        y = bricks.top_left_position.y +
        bricks.height/2 +
        (row - 1) *
        (bricks.height + bricks.gap.height)
      }
      brick_index = row..col
      bricks.add_brick(brick_index, new_brick_position)
    end
  end
end

function bricks.add_brick(index, position)
  print(index)
  local object = {
    body = love.physics.newBody(World, position.x, position.y, 'static'),
    shape = love.physics.newRectangleShape(bricks.width, bricks.height)
  }
  object.fixture = love.physics.newFixture(object.body, object.shape)
  object.fixture:setUserData({'Brick', index})
  object.fixture:setRestitution(1)
  Bricks[index] = object
end


function bricks.draw()
  for _, brick in pairs(Bricks) do
    love.graphics.polygon('line', brick.body:getWorldPoints(brick.shape:getPoints()))
  end
end

return bricks