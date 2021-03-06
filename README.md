<h1 align="center">
&nbsp<:3&nbsp&nbsp)~
<br>
Wire
</h1>

**Wire** is a small reactive wrapping for [LÖVE](https://love2d.org/) framework,
highly inspired in [Cycle.js](http://cycle.js.org) (the web development framework) and it's fractal state
management, [onionify](https://github.com/staltz/cycle-onionify).

Wire allows you to take advantage of the awesomeness of LÖVE in a fully
reactive and delightfull way. No global variables all around, no imperative
actions, no mixed concerns (interaction, logic, side-effects, etc).

You just need to wire everything up **declarativelly** and let the data flow
freely throughout your game.


## Installation

Via [luarocks](https://luarocks.org/)

```sh
luarocks install wire
```

## Hello reactive world

```lua
local rx = require 'rx'
local wire = require 'wire'

local function game(sources)
  return {
    reducer = rx.Observable.merge(

      -- initial state
      rx.Observable.of(function()
        return {
          text = 'Hello World'
        })
      end),

      -- update state on key press
      sources.events.keypressed
        :filter(
          function(key)
            return key == 'space'
          end
        )
        :map(
          function()
            -- return a reducer function to update state
            return function(prevState)
              -- returned table will be merged to current
              -- state, updating value of text key
              return {
                text = 'Hello Interactive World :)'
              }
            end
          end
        )
    ),

    -- emit render function on state update
    render = sources.state:map(
      function(state)
        return function()
          love.graphics.print(state.text, 8, 8)
        end
      end
    )
  }
end

wire.run(game)
```

## Documentation

https://italonascimento1.gitbooks.io/wire/


## Reactive?

Not familiar with reactive programming? You may want to take a look at this
great article first:

[The introduction to Reactive Programming you've been
missing](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754)
