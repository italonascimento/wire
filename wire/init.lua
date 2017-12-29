-- wire
-- git@github.com:italonascimento/wire.git
-- v0.0.1
-- MIT License

require 'rxlove'
local isolate = require 'wire.isolate'
local run = require 'wire.run'

return {
  isolate = isolate,
  run = run,
}
