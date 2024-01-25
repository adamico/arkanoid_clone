
love.graphics.setDefaultFilter('nearest', 'nearest')

local ball = {}
ball.position = {x = 300, y = 300}
ball.speed = {x = 300, y = 300}
ball.radius = 10
ball.segments = 16

local player = {}
player.position = {x = 500, y = 500}
player.speed = {x = 300, y = 0}
player.width, player.height = 70, 20

local bricks = {}
bricks.width, bricks.height = 50, 30
bricks.rows, bricks.columns = 8, 11
bricks.top_left_position = {x = 70, y = 50}
bricks.gap = {width = 10, height = 10}
bricks.current_level_bricks = {}

function love.load()
    love.window.setTitle('My Arkanoid Clone')
    bricks.construct_level()
end

function bricks.construct_level()
    for row = 1, bricks.rows do
        for col = 1, bricks.columns do
            local new_brick_position = {
                x = bricks.top_left_position.x +
                (col - 1) *
                (bricks.width + bricks.gap.width),
                y = bricks.top_left_position.y +
                (row - 1) *
                (bricks.height + bricks.gap.height)
            }
            local new_brick = bricks.add_brick(new_brick_position)
        end
    end
end

function bricks.add_brick(position)
    local brick = {}
    brick.position = position
    brick.width = bricks.width
    brick.height = bricks.height
    table.insert(bricks.current_level_bricks, brick)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    ball.update(dt)
    player.update(dt)
    bricks.update(dt)
end

function love.draw()
    ball.draw()
    player.draw()
    bricks.draw()
end

function ball.update(dt)
    ball.move(dt)
end

function ball.move(dt)
    --TODO: normalize diagonal movement
    ball.position.x = ball.position.x + ball.speed.x * dt
    ball.position.y = ball.position.y + ball.speed.y * dt
end

function ball.draw()
    love.graphics.circle("line", ball.position.y, ball.position.y, ball.radius, ball.segments)
end

function player.update(dt)
    player.move(dt)
end

function player.move(dt)
    if love.keyboard.isDown("right") then
        player.position.x = player.position.x + player.speed.x * dt
    end
    if love.keyboard.isDown("left") then
        player.position.x = player.position.x - player.speed.x * dt
    end
end

function player.draw()
    Draw_object_rectangle(player)
end

function bricks.draw()
    for _, brick in ipairs(bricks.current_level_bricks) do
        Draw_object_rectangle(brick)
    end
end

function bricks.update(dt)
end

function Draw_object_rectangle(object)
    if object.position and object.width and object.height then
        love.graphics.rectangle("line", object.position.x, object.position.y, object.width, object.height)
    end
end