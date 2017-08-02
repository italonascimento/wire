local rx = require 'rx'
local assign = require 'wire.assign'

local function getLoveEvents()
  local events = {}
  local loveEvents = {
    'directorydropped',
    'draw',
    'filedropped',
    'focus',
    'keypressed',
    'keyreleased',
    'lowmemory',
    'mousefocus',
    'mousemoved',
    'mousepressed',
    'mousereleased',
    'quit',
    'resize',
    'textedited',
    'textinput',
    'touchmoved',
    'touchpressed',
    'touchreleased',
    'threaderror',
    'update',
    'visible',
    'wheelmoved'
  }

  for _, event in pairs(loveEvents) do
    love[event] = rx.Subject.create()
    events[event] = love[event]
  end

  return events
end

return function (gameComponent)
  local events = getLoveEvents()
  local reducerMimic = rx.Subject.create()

  local gameState = reducerMimic
    :scan(function(prevState, reduce)
      return assign(prevState, reduce(prevState))
    end, {})

  local game = gameComponent({
    state = gameState,
    events = events
  })

  rx.Observable.combineLatest(
    game.render,
    love.draw,
    function(render)
      return render
    end
  ):subscribe(function(render)
    render()
  end)

  if game.reducer then
    game.reducer:subscribe(reducerMimic)
  end
end
