package = "Wire"
version = "0.0.1-1"
source = {
 url = "..."
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
 "lua >= 5.1, < 5.4",
 "rxlua == 0.0.2",
 "rxlove == 0.0.1"
}
build = {
 type = "builtin",

 modules = {
   wire = "wire/init.lua",
   ["wire.run"] = "wire/run.lua",
   ["wire.isolate"] = "wire/isolate.lua",
   ["wire.assign"] = "wire/assign.lua"
 }
}
