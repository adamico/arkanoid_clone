local Brick = Class('Brick')

function Brick:initialize(index, position, width, height, color)
  self.index = index
  self.position = position
  self.width, self.height = width, height
  self.physicalObject = self:buildPhysics()-- TODO: extract component
  self.color = color or {1, 1, 1}
end

function Brick:buildPhysics()
  local object = {
    body = love.physics.newBody(World, self.position.x, self.position.y, 'static'),
    shape = love.physics.newRectangleShape(self.width, self.height)
  }
  object.fixture = love.physics.newFixture(object.body, object.shape)
  object.fixture:setUserData({'Brick', self.index})
  object.fixture:setRestitution(1)
  
  return object
end


function Brick:draw()
  love.graphics.setColor(self.color)
  love.graphics.polygon('line', self.physicalObject.body:getWorldPoints(self.physicalObject.shape:getPoints()))
end

return Brick