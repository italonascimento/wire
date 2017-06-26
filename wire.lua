-- Wire
-- v0.0.1
-- MIT License

local rx = require 'rx'
require 'rxlove'

local function assign (t, values)
    local target = {}
    if type(t) == "table" then
      local meta = getmetatable(t)
      for k, v in pairs(t) do target[k] = v end
      setmetatable(target, meta)
    end
    for k, v in pairs(values) do target[k] = v end
    return target
end

local function run(gameComponent)
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

local function isolate(component, key)
  return function(sources)
    local isolatedSources = assign(sources, {
      state = sources.state:map(function(state)
        return state[key]
      end)
    })

    local entity = component(isolatedSources)

    entity.reducer = entity.reducer:map(function(reducer)
      return function(prevState)
        local newState = {}
        newState[key] = reducer(prevState[key])
        return newState
      end
    end)

    return entity
  end
end

return {
  isolate = isolate,
  run = run
}
