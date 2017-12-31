local merge = require 'wire.merge'

return function (component, key)
  return function(sources)
    local isolatedSources = merge(sources, {
      state = sources.state:map(function(state)
        return state[key]
      end)
    })

    local entity = component(isolatedSources)

    if entity.reducer then
      entity.reducer = entity.reducer:map(function(reducer)
        return function(prevState)
          local newState = {}
          newState[key] = reducer(prevState[key])
          return newState
        end
      end)
    end

    return entity
  end
end
