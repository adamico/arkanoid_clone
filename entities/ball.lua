local ball = {
  speed = {x = 300, y = 300},
  radius = 10,
  segments = 16
}

function ball.build()
  local object = {}
  object.body = love.physics.newBody(World, love.graphics.getWidth()/2, 500, 'dynamic')
  object.body:setInertia(0)
  object.shape = love.physics.newCircleShape(ball.radius)
  object.fixture = love.physics.newFixture(object.body, object.shape, 1)
  -- object.point = love.physics.newCircleShape(ball.radius/4)
  -- object.fixture2 = love.physics.newFixture(object.body, object.point, 1)
  object.fixture:setRestitution(1)
  object.fixture:setUserData({'Ball', 1})
  Entities.ball = object
end

function ball.draw()
  local ball_object = Entities.ball
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle('line', ball_object.body:getX(), ball_object.body:getY(), ball_object.shape:getRadius(), ball.segments)
  -- love.graphics.circle('line', ball_object.body:getX()+2, ball_object.body:getY()-2, ball_object.point:getRadius())
end

return ball