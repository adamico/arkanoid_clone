local LevelLoader = Class('LevelLoader')
local Level = require 'entities.level'

function LevelLoader:initialize()
  self.current_level = 1
  self.sequence = {
    'hey',
    'bye'
  }
end

function LevelLoader:loadCurrentLevel()
  local level_filename = "levels/" .. self.sequence[self.current_level]
  local level = require(level_filename)
  return Level:new(level)
end

return LevelLoader