local game_over = {}

function game_over:enter()
  Entities.ball.physicalObject.body:destroy()
  Entities.ball = {}
  Entities.player.physicalObject.body:destroy()
  Entities.player = {}
  Levels.current_level = 1
end

function game_over:draw()
  love.graphics.printf( "Congratulations!\n" .. "You have finished the game!\n" .. "Press Enter to restart.", 300, 250, 200, "center" )
end

function game_over:keypressed(key)
  if key == 'return' then
    Gamestate.switch(Menu)
  end
end

return game_over