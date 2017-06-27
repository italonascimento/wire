return function (t, values)
    local target = {}
    if type(t) == "table" then
      local meta = getmetatable(t)
      for k, v in pairs(t) do target[k] = v end
      setmetatable(target, meta)
    end
    for k, v in pairs(values) do target[k] = v end
    return target
end
