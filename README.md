# About

**Wire** is a small reactive wrapping for [LÖVE](https://love2d.org/) framework,
highly inspired in [Cycle.js](cycle.js.org) (the web development framework) and it's fractal state
management, [Onionify](https://github.com/staltz/cycle-onionify).

Wire allows you to take advantage of the simplicity of LÖVE in a fully
reactive and delightfull way. You just need to wire everything up
**declarativelly**, and let the data flow freely throughout your game.

# Reactive?

Not familiar with reactive programming? You may want to take a look at this
great article first, as a basic understanding of data streams will be
necessary throught this documentation:
[The introduction to Reactive Programming you've been
missing](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754)

# Installation

More info coming soon. :hourglass:

# How to use

## Creating a component

Every wire component follow two simple rules:

1. Separation of concerns;
2. Just logics, no side-effects.

Let's get started by creating a simple `game.lua` file containing the
following four functions:

```lua
return function()

end

local function intent()

end

local function reduce()

end

local function render()

end
```

The first function, as you may have noticed, is an anonimous function, and
will take the role of a constructor. We'll get back to it soon.

### Intent

The `intent` function is the place we define all the possible user's intent
concerning our component. And, as user intent are events that occur over time,
we're going to define them as event streams.

```lua
local function intent()
  return {
    space = love.keypress:filter(function(key)
      return key == 'space'
    end)
  }
end
```

Here we're defining an intent called `space`, which is a stream that emits
everytime the user hits space.


### Reduce

The `reduce` function is the place we define how our intents should be reduced
into game state.

```lua
local function reduce(intent)
  return intent.space:map(function(prevState)
    local newState = {
      foo = prevState.foo + 'bar'
    }

    return newState
  end)
end
```

This is how we define a reducer: by mapping every intent emited in the stream
to a function, which recieves a *previous state* object and returns a *new
state* one.

So anytime the player press space, the `foo` field of our game's state will
get the string `' bar'` concatenated to it.

Note the importance of the word *define* in this situation, as we're not
acctually *doing* anything here, but instead *declaring* how data should
proccessed as soon as our `space` intent emits an event.

### Initial state

For the reduce proccess to make sense, though, we need to have a initial state.
And we're going to define it as another stream: one that  emits right away,
providing the initial data we need:

```lua
local rx = require 'rx'

local function reduce(intent)
  return rx.Observable.merge(
    rx.Observable.of(function()
      return {
        foo = ''
      }
    end),

    intent.space:map(function(prevState)
      local newState = {
        foo = prevState.foo + ' bar'
      }

      return newState
    end)
end
```

As we have more than one stream in this case, we must merge them together
in single a stream to be returned.

### Render

The `render` function, as you may expect, is where we define what gets
rendered to the screen. But, as we're **just defining**, we can't acctually
render anything right now. Instead, we're going to return a new function
which will be responsible to actual render when the time is come.

```lua
local function render(state)
  return function()
    love.graphics.print(state.foo, 32, 32)
  end
end
```

Note how we decide what to render based on the current state. No global
variables, everything should go throught the state.

### The constructor

The constructor is the main function of each component. It's where we wire  
everything up.

A component constructor will be called with a `sources` argument, which may
contain many fields, as we'll cover in the future. For now, lets focus in the
one field that will almost always be present: `state`.

```lua
return function(sources)
  local renderStream = sources.state:map(render)

  return {
    reducer = reduce(intent()),
    render = renderStream
  }
end
```

Here, in the first line of our function, we map the `state` stream to
a stream of render functions.
In other words, anytime the `state` stream  emits a new state object,
the `renderStream` also emits a new render function.

Than, the render stream is returned as the `render` field, while the `reducer`
field recieves the stream resulting stream (the merge!) of the reducing of our
defined intents.

### Running

To run the component we've just defined, we just need to create a `main.lua`
file containing the following:

```lua
local wire = require 'wire'
local game = require 'game'

wire.run(game)
```

That's it. Run `love ./` to see it working.

### Managing state and multiple components

More info coming soon. :hourglass:
