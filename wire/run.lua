local rx = require 'rx'
local assign = 'wire.assign'

return function (gameComponent)
  local reducerMimic = rx.Subject.create()

  local gameState = reducerMimic
    :scan(function(prevState, reduce)
      return assign(prevState, reduce(prevState))
    end, {})

  local game = gameComponent({state = gameState})

  rx.Observable.combineLatest(
    game.render,
    love.draw,
    function(render)
      return render
    end
  ):subscribe(function(render)
    render()
  end)

  game.reducer:subscribe(reducerMimic)
end
