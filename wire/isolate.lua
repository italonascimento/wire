local merge = require 'wire.merge'

local function createLens(key)
  return {
    get = function(state) return state[key] end,
    set = function(state, childState) return { [key] = childState } end,
  }
end

return function (component, lens)
  return function(sources)
    local _lens = type(lens) == 'string' and createLens(lens) or lens

    if type(_lens) ~= 'table' then
      error('Argument must be of type <string> or <table>, got <' .. type(_lens) .. '> instead')
    end

    local isolatedSources = merge(sources, {
      state = sources.state:map(_lens.get)
    })

    local entity = component(isolatedSources)

    if entity.reducer then
      entity.reducer = entity.reducer:map(function(reducer)
        return function(prevState)
          return _lens.set(prevState, reducer(_lens.get(prevState)))
        end
      end)
    end

    return entity
  end
end
