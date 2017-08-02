local rx = require 'rx'
local run = require 'wire.run'

local game = function(sources)
  return {
    reducer = rx.Observable.merge(
      rx.Observable.fromValue(function()
        return {count = 0}
      end),

      sources.events.keypressed:map(function()
        return function(prevState)
          return {count = prevState.count + 1}
        end
      end)
    ),

    render = sources.state:map(function(state)
      return function()
        love.graphics.print(state.count, 8, 8)
      end
    end)
  }
end

run(game)
