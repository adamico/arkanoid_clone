local Wall = Class('Wall')
local screen_width = love.graphics.getWidth()
local screen_height = love.graphics.getHeight()

function Wall:initialize(direction, center, width, height, active, color)
  self.direction = direction
  self.center = center
  self.width = width
  self.height = height
  self.active = active
  self.active = active or true
  self.color = color or {0.2, 0.2, 0.4}
  self.physicalObject = self:buildPhysics()-- TODO: extract component
end

function Wall:buildPhysics()
  local object = {
    body = love.physics.newBody(World, self.center.x, self.center.y),
    shape = love.physics.newRectangleShape(self.width, self.height)
  }
  object.fixture = love.physics.newFixture(object.body, object.shape)
  object.fixture:setUserData({'Wall', self.direction})
  object.fixture:setRestitution(1)

  return object
end

function Wall:draw()
  love.graphics.setColor(self.color)
  love.graphics.polygon('fill', self.physicalObject.body:getWorldPoints(self.physicalObject.shape:getPoints()))
end

function Wall.static:defaultThickness()
  return 20
end

return Wall