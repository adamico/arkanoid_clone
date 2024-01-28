local Player = Class('Player')

function Player:initialize()
  self.speed = {x = 500, y = 3}
  self.width = 70
  self.height = 20
  self.color = {1, 1, 1}
  self.physicalObject = self:buildPhysics()-- TODO: extract component
end

function Player:buildPhysics()
  local object = {}
  object.body = love.physics.newBody(World, love.mouse.getX(), love.mouse.getY(), 'dynamic')
  object.body:setAngularDamping(0.1)
  object.body:setFixedRotation(true)
  object.shape = love.physics.newRectangleShape(self.width, self.height)
  object.fixture = love.physics.newFixture(object.body, object.shape, 2)
  object.fixture:setRestitution(1)
  object.fixture:setUserData({'Player', 1})
  object.joint = love.physics.newMouseJoint(object.body, love.mouse.getPosition())
  return object
end

function Player:move(dt)
  self.physicalObject.joint:setTarget(love.mouse.getPosition())
end

function Player:draw()
  love.graphics.setColor(self.color)
  love.graphics.polygon('line', self.physicalObject.body:getWorldPoints(self.physicalObject.shape:getPoints()))
end

return Player