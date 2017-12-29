package = "wire"
version = "0.0.5-1"
source = {
 url = "https://github.com/italonascimento/wire"
}
description = {
 summary = "Reactive wrapping for LÖVE framework.",
 detailed = [[
   Wire is a small wrapping that allows you to use all the
   awesomeness of LÖVE in a fully reactive and delightfull way.
   Just wire everything up declarativelly, and let the data flow freely
   throughout your game.
 ]],
 homepage = "http://...", -- We don't have one yet
 license = "MIT" -- or whatever you like
}
dependencies = {
 "lua >= 5.1, <= 5.3",
 "rxlua == 0.0.2"
}
build = {
 type = "builtin",

 modules = {
   wire = "wire/init.lua",
   ["wire.run"] = "wire/run.lua",
   ["wire.isolate"] = "wire/isolate.lua",
   ["wire.merge"] = "wire/merge.lua",
 }
}
