local screen_width = love.graphics.getWidth()
local screen_height = love.graphics.getHeight()

-- bricks
local bricks = {}
bricks.width, bricks.height = 50, 30
bricks.rows, bricks.columns = 7, 11
bricks.top_left_position = {x = 70, y = 70}
bricks.gap = {width = 10, height = 10}

function bricks.construct_level()
    Bricks = {}
    local brick_index = ""
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
    object.fixture:setUserData({"Brick", index})
    object.fixture:setRestitution(1)
    Bricks[index] = object
end


function bricks.draw()
    for _, brick in pairs(Bricks) do
        love.graphics.polygon("line", brick.body:getWorldPoints(brick.shape:getPoints()))
    end
end

-- walls
local walls = {thickness = 20}

function walls.construct(active)
    local active = active or true
    Entities.walls = {}
    local top_center = {x = screen_width/2, y = walls.thickness/2}
    local right_center = {x = screen_width - walls.thickness/2, y = screen_height/2}
    local bottom_center = {x = screen_width/2, y = screen_height - walls.thickness/2}
    local left_center = {x = walls.thickness/2, y = screen_height/2}

    walls.add_wall("top", top_center, screen_width, walls.thickness, active)
    walls.add_wall("right", right_center, walls.thickness, screen_height, active)
    walls.add_wall("bottom", bottom_center, screen_width, walls.thickness, active)
    walls.add_wall("left", left_center, walls.thickness, screen_height, active)

end

function walls.add_wall(direction, center, width, height, active)
    local object = {
        body = love.physics.newBody(World, center.x, center.y),
        shape = love.physics.newRectangleShape(width, height)
    }
    
    object.fixture = love.physics.newFixture(object.body, object.shape)
    object.fixture:setUserData({"Wall", direction})
    object.fixture:setRestitution(1)

    Entities.walls[direction] = object
end

function walls.draw()
    love.graphics.setColor(0.2, 0.2, 0.4)
    for direction, wall in pairs(Entities.walls) do
        love.graphics.polygon("fill", wall.body:getWorldPoints(wall.shape:getPoints()))
    end
end

-- ball
local ball = {
    speed = {x = 300, y = 300},
    radius = 10,
    segments = 16
}

function ball.build()
    local object = {}
    object.body = love.physics.newBody(World, love.graphics.getWidth()/2, 500, "dynamic")
    object.body:setInertia(0)
    object.shape = love.physics.newCircleShape(ball.radius)
    object.fixture = love.physics.newFixture(object.body, object.shape, 1)
    -- object.point = love.physics.newCircleShape(ball.radius/4)
    -- object.fixture2 = love.physics.newFixture(object.body, object.point, 1)
    object.fixture:setRestitution(1)
    object.fixture:setUserData({"Ball", 1})
    Entities.ball = object
end

function ball.draw()
    local ball_object = Entities.ball
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("line", ball_object.body:getX(), ball_object.body:getY(), ball_object.shape:getRadius(), ball.segments)
    -- love.graphics.circle("line", ball_object.body:getX()+2, ball_object.body:getY()-2, ball_object.point:getRadius())
end

-- player

local player = {
    speed = {x = 500, y = 3},
    width = 70,
    height = 20
}

local mouse = {}

function player.build()
    local object = {}
    object.body = love.physics.newBody(World, love.mouse.getX(), love.mouse.getY(), "dynamic")
    object.body:setAngularDamping(0.1)
    object.body:setFixedRotation(true)
    object.shape = love.physics.newRectangleShape(player.width, player.height)
    object.fixture = love.physics.newFixture(object.body, object.shape, 2)
    object.fixture:setRestitution(1)
    object.fixture:setUserData({"Player", 1})
    object.joint = love.physics.newMouseJoint(object.body, love.mouse.getPosition())
    Entities.player = object

end

function player.move(dt)
    mouse.x, mouse.y = love.mouse.getPosition()
    Entities.player.joint:setTarget(love.mouse.getPosition())
end

function player.draw()
    local player_object = Entities.player
    love.graphics.setColor(1, 1, 1)
    love.graphics.polygon("line", player_object.body:getWorldPoints(player_object.shape:getPoints()))
end

-- main loop
love.graphics.setDefaultFilter('nearest', 'nearest')

Gamestate = require "lib.hump.gamestate"

Entities = {}

local menu = {}
local pre_game = {}
local game = {}

function menu:enter()
    love.mouse.setVisible(true)
end

function menu:draw()
    local margin = 100
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.rectangle('fill', margin, margin, screen_width-margin*2, screen_height/2 - margin)
    CenterText({"Welcome to Brahrkanoid", "", "Press Enter to play"}, {0, 0, 0.2}, screen_height/4)
end

function menu:keyreleased(key, code)
    if key == 'return' then
        Gamestate.switch(pre_game)
    end
end

function pre_game:enter()
    bricks.construct_level()
    walls.construct(false)
    ball.build()
    Entities.ball.body:setType('static')
    player.build()
end

function pre_game:draw()
    bricks.draw()
    walls.draw()
    ball.draw()
    player.draw()
    local margin = 100
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.rectangle('fill', margin, margin, screen_width-margin*2, screen_height/2 - margin)
    CenterText({"Position the bat and left click to start the game"}, {0, 0, 0.2}, screen_height/4)
end

function pre_game:update(dt)
    World:update(dt)
    player.move(dt)
end

function pre_game:mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        Gamestate.switch(game)
    end
end

function game:enter()
    love.mouse.setVisible(false)
    Entities.ball.body:setType('dynamic')
end

function game:update(dt)
    World:update(dt)
    mouse.x, mouse.y = love.mouse.getPosition()
    Entities.player.joint:setTarget(love.mouse.getPosition())
end

-- function game:mousemoved(x, y, dx, dy, istouch)
--     if love.mouse.isDown(1) then
--         Entities.player.body:setAngle(dx / math.pi + math.pi/8 * dx)
--     else
--         Entities.player.body:setAngle(math.pi)
--     end
-- end

function game:draw()
    ball.draw()
    player.draw()
    bricks.draw()
    walls.draw()
end

---@diagnostic disable-next-line: duplicate-set-field
function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(menu)
    Vector = require('lib.hump.vector')
    love.window.setTitle('My Arkanoid Clone')
    local meter = 64
    love.physics.setMeter(meter)
    local gravity = 9.81*meter
    World = love.physics.newWorld(0, gravity, true)
    World:setCallbacks(beginContact, endContact, preSolve, postSolve)
    love.mouse.setGrabbed(true)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
end

-- collisions callback

function beginContact(a, b, contact)
    local dx, dy = contact:getNormal()
    local aData = a:getUserData()
	local bData = b:getUserData()
    -- ball/bricks collisions
    if aData[1] == "Ball" and bData[1] == "Brick" then
        Bricks[bData[2]] = nil
    elseif bData[1] == "Ball" and aData[1] == "Brick" then
        Bricks[aData[2]].body:destroy()
        Bricks[aData[2]] = nil
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
        love.graphics.draw(text, screen_width/2-width/2, vertical_offset-height/2+(i-1)*height)
    end
end