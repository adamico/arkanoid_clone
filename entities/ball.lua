local Ball = Class('Ball')

function Ball:initialize(state)
  self.speed = {x = 300, y = 300}
  self.radius = 10
  self.segments = 16
  self.color = {1, 1, 1}
  self.initial_position = {x =  love.graphics.getWidth()/2, y = 500}
  self.physicalObject = self:buildPhysics(state)-- TODO: extract component
end

function Ball:buildPhysics(state)
  local object = {}
  object.body = love.physics.newBody(World, self.initial_position.x,  self.initial_position.y, state)
  object.body:setInertia(0)
  object.shape = love.physics.newCircleShape(self.radius)
  object.fixture = love.physics.newFixture(object.body, object.shape, 1)
  -- object.point = love.physics.newCircleShape(self.radius/4)
  -- object.fixture2 = love.physics.newFixture(object.body, object.point, 1)
  object.fixture:setRestitution(1)
  object.fixture:setUserData({'Ball', 1})--TODO: set object id in case of multiple balls in game
  return object
end

function Ball:setInMotion()
  self.physicalObject.body:setType('dynamic')
end

function Ball:reposition()
  self.physicalObject.body:setPosition(self.initial_position.x, self.initial_position.y)
end

function Ball:draw()
  love.graphics.setColor(self.color)
  love.graphics.circle('line',
                       self.physicalObject.body:getX(),
                       self.physicalObject.body:getY(),
                       self.physicalObject.shape:getRadius(),
                       self.segments)
  -- love.graphics.circle('line', self.physicalObject.body:getX()+2, self.physicalObject.body:getY()-2, self.physicalObject.point:getRadius())
end

return Ball