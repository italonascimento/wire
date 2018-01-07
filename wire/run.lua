local rx = require 'rx'
local merge = require 'wire.merge'

local function getLoveEvents()
  local events = {}
  local loveEvents = {
    'directorydropped',
    'load',
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

local function associateDraw(stream1, stream2)
  stream1
    :combineLatest(
      stream2:take(1),
      function(_, fn)
        return fn
      end
    )
    :subscribe(function(fn)
      fn()
    end
  )
end

return function (gameComponent)
  local events = getLoveEvents()
  local reducerMimic = rx.Subject.create()

  local gameState = reducerMimic
    :scan(function(prevState, reduce)
      return merge(prevState, reduce(prevState))
    end, {})

  local replayState = rx.ReplaySubject.create(1)
  gameState:subscribe(replayState)

  love.load:subscribe(function(arg)
    local game = gameComponent({
      state = replayState,
      events = events,
      arg = rx.Observable.fromValue(arg),
    })

    if game.draw then associateDraw(love.draw, game.draw) end

    if game.reducer then
      game.reducer:subscribe(reducerMimic)
    end

    if game.effects then
      game.effects:subscribe(function(effect)
        effect()
      end)
    end
  end)
end
