local assign = 'wire.assign'

return function (component, key)
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
