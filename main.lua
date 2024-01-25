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
    local brick_object = {
        body = love.physics.newBody(World, position.x, position.y, 'static'),
        shape = love.physics.newRectangleShape(bricks.width, bricks.height)
    }
    brick_object.fixture = love.physics.newFixture(brick_object.body, brick_object.shape)
    brick_object.fixture:setUserData({"Brick", index})
    Bricks[index] = brick_object
end


function bricks.draw()
    for _, brick in pairs(Bricks) do
        love.graphics.polygon("line", brick.body:getWorldPoints(brick.shape:getPoints()))
    end
end

-- walls
local walls = {thickness = 20}

function walls.construct()
    Objects.walls = {}
    local top_center = {x = screen_width/2, y = walls.thickness/2}
    local right_center = {x = screen_width - walls.thickness/2, y = screen_height/2}
    local bottom_center = {x = screen_width/2, y = screen_height - walls.thickness/2}
    local left_center = {x = walls.thickness/2, y = screen_height/2}

    walls.add_wall("top", top_center, screen_width, walls.thickness)
    walls.add_wall("right", right_center, walls.thickness, screen_height)
    walls.add_wall("bottom", bottom_center, screen_width, walls.thickness)
    walls.add_wall("left", left_center, walls.thickness, screen_height)

end

function walls.add_wall(direction, center, width, height)
    local wall_object = {
        body = love.physics.newBody(World, center.x, center.y),
        shape = love.physics.newRectangleShape(width, height)
    }
    wall_object.fixture = love.physics.newFixture(wall_object.body, wall_object.shape)
    wall_object.fixture:setUserData({"Wall", direction})
    Objects.walls[direction] = wall_object
end

function walls.draw()
    love.graphics.setColor(0.2, 0.2, 0.4)
    for direction, wall in pairs(Objects.walls) do
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
    local ball_object = {}
    ball_object.body = love.physics.newBody(World, love.graphics.getWidth()/2, 500, "dynamic")
    ball_object.body:setInertia(0)
    ball_object.shape = love.physics.newCircleShape(ball.radius)
    ball_object.fixture = love.physics.newFixture(ball_object.body, ball_object.shape, 1)
    ball_object.fixture:setRestitution(0.6)
    ball_object.fixture:setUserData({"Ball", 1})
    Objects.ball = ball_object
end

function ball.draw()
    local ball_object = Objects.ball
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("line", ball_object.body:getX(), ball_object.body:getY(), ball_object.shape:getRadius(), ball.segments)
end

-- player
local player = {
    speed = {x = 500, y = 3},
    width = 70,
    height = 20
}

local mouse = {}

function player.build()
    local player_object = {}
    player_object.body = love.physics.newBody(World, love.mouse.getX(), love.mouse.getY(), "dynamic")
    player_object.body:setAngularDamping(0.1)
    player_object.body:setFixedRotation(true)
    player_object.shape = love.physics.newRectangleShape(player.width, player.height)
    player_object.fixture = love.physics.newFixture(player_object.body, player_object.shape, 2)
    player_object.fixture:setRestitution(0.5)
    player_object.fixture:setUserData({"Player", 1})
    player_object.joint = love.physics.newMouseJoint(player_object.body, love.mouse.getPosition())
    Objects.player = player_object
end

function player.move(dt)
    local player_object = Objects.player
    local move_right = love.keyboard.isDown("right")
    local move_left = love.keyboard.isDown("left")
    local move_down = love.keyboard.isDown("down")
    local move_up = love.keyboard.isDown("up")

    if move_right then
        player_object.body:applyForce(player.speed.x, 0)
    end
    if move_left then
        player_object.body:applyForce(-player.speed.x, 0)
    end
    if move_down then
        player_object.body:applyLinearImpulse(0, player.speed.y)
    end
    if move_up then
        player_object.body:applyLinearImpulse(0, -player.speed.y)
    end
end

function player.draw()
    local player_object = Objects.player
    love.graphics.setColor(1, 1, 1)
    love.graphics.polygon("line", player_object.body:getWorldPoints(player_object.shape:getPoints()))
end

-- main loop
love.graphics.setDefaultFilter('nearest', 'nearest')

Objects = {}

function love.load()
    Vector = require('lib.hump.vector')
    love.window.setTitle('My Arkanoid Clone')
    local meter = 64
    love.physics.setMeter(meter)
    World = love.physics.newWorld(0, 9.81*meter, true)
    World:setCallbacks(beginContact, endContact, preSolve, postSolve)
    bricks.construct_level()
    walls.construct()
    ball.build()
    player.build()
end

function love.update(dt)
    World:update(dt)
    Objects.player.joint:setTarget(love.mouse.getPosition())
    -- player.move(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    ball.draw()
    player.draw()
    bricks.draw()
    walls.draw()
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