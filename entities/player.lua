local player = {
  speed = {x = 500, y = 3},
  width = 70,
  height = 20
}

function player.build()
  local object = {}
  object.body = love.physics.newBody(World, love.mouse.getX(), love.mouse.getY(), 'dynamic')
  object.body:setAngularDamping(0.1)
  object.body:setFixedRotation(true)
  object.shape = love.physics.newRectangleShape(player.width, player.height)
  object.fixture = love.physics.newFixture(object.body, object.shape, 2)
  object.fixture:setRestitution(1)
  object.fixture:setUserData({'Player', 1})
  object.joint = love.physics.newMouseJoint(object.body, love.mouse.getPosition())
  Entities.player = object
  
end

function player.move(dt)
  Entities.player.joint:setTarget(love.mouse.getPosition())
end

function player.draw()
  local player_object = Entities.player
  love.graphics.setColor(1, 1, 1)
  love.graphics.polygon('line', player_object.body:getWorldPoints(player_object.shape:getPoints()))
end

return player