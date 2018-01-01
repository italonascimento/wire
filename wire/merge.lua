return function (t, ...)
    local target = {}
    if type(t) == 'table' then
      local meta = getmetatable(t)
      for k, v in pairs(t) do target[k] = v end
      setmetatable(target, meta)
    else
      error('Argument must be of type <table>, got <' .. type(t) .. '> instead')
    end

    for i, tab in ipairs{...} do
      if type(tab) == 'table' then
        for k, v in pairs(tab) do target[k] = v end
      else
        error('Arguments must be of type <table>, got <' .. type(tab) .. '> instead')
      end
    end
    return target
end
