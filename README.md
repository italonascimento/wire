# About

**Wire** is a small reactive wrapping for [LÖVE](https://love2d.org/) framework,
highly inspired in [Cycle.js](cycle.js.org) (the web development framework) and it's fractal state
management, [onionify](https://github.com/staltz/cycle-onionify).

Wire allows you to take advantage of the awesomeness of LÖVE in a fully
reactive and delightfull way. No global variables all around, no imperative
actions, no mixed concerns (interaction, logic, side-effects, etc).

You just need to wire everything up **declarativelly** and let the data flow
freely throughout your game.


# Installation

More info coming soon. :hourglass:


# Reactive?

Not familiar with reactive programming? You may want to take a look at this
great article first:

[The introduction to Reactive Programming you've been
missing](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754)


# Concept

In complex interactive systems such as games, the human/computer interaction
is mostly of an asynchronous nature.

Based on this understanding, Wire deals with user intent as a stream of
events over time, which are asynchronouslly modeled into data streams, and
then, asynchronouslly converted to side-effects, producing output for the user.

To a better understanding, take as for example a stream of user clicks:

```
---c-----c--c-----c----|
```

Everytime the user clicks, a new event is emited on the stream.

Now, we may listen to those intent events and, on each emission, model them
into a new stream, which will hold the counting of the clicks:

```
---c-----c--c-----c----|
0--1-----2--3-----4----|
```

That's nice, but... If we also needed to keep track of the times the user
hits the SPACE key, we would need another intent stream, and yet another one
to keep our data. Well, this is not much scalable, as our source of truth
would be living in separate streams which would emit updates separatelly over
time.

Alternativelly, we can move our source of truth to a single place, a
centralized *data store*, and instead of modeling our intent events directly
to data, model them to *reducer functions*, which receive the current state
of the centralized store and return an updated one:

```lua
local function reducer(prevState)
  -- proccess stuff
  return newState
end
```

Than, we end up with three streams:

* One of *intent*,
* One of *reducers*
* And one of data, our *store*.

Each intent event will dispatch a reducer event. And on each reducer emission,
we call the emited function with the current store as argument.

```
-----c--------c-----c------c----|
----r(0)-----r(1)--r(2)---r(3)--|
0----1--------2-----3------4----|
```

Finally, listening to the store events, we're abble to display
information to the user or produce any other side-effect, everytime
the data changes, automatically.


# How to use

## Creating a component

Let's get started by creating a simple `game.lua` file containing the
following four functions:

```lua
return function()

end

local function intent()

end

local function model()

end

local function render()

end
```

### The constructor

The first function, as you may have noticed, is an anonimous function, and
will take the role of a constructor. It will recieve a `sources` argument, and
may return a table with two keys: `reducer` and `render`.

As we can't yet define these values, we'll come back to the constructor later.


### Intent

The `intent` function is the place we define all the possible user's intent
concerning our component.

Let's define the click intent we talked about before.

```lua
local function intent()
  return {
    click = love.mousepressed
  }
end
```

### Model

The `model` function is the place we define how our intents should be reduced
into data.

This is where the modeling process we talked before takes place, but we're not
going to manipulate the data directly, instead we're going to define reducers.

A reducer is a pure function which recieves the current game state (the data)
and returns an updated one.

```lua
local function model(intent)
  return intent.click:map(function()
    return function(prevState)
      local newState = {
        clickCount = prevState.clickCount + 1
      }

      return newState
    end
  end)
end
```

For the reduce proccess to make sense, though, we need to have a initial state.
Right now, when the user first clicks, we'll try to sum 1 to `nil`, as
`clickCount` is not defined.

To create a initial state, we just need to create another stream of reducer,
but one that will emit right away, independent of any intent:

```lua
local function model(intent)
  local initialReducer = rx.Observable.of(
    function()
      return {
        clickCount = 0
      }
    end
  )

  local clickReducer = intent.click:map(
    function()
      return function(prevState)
        local newState = {
          clickCount = prevState.clickCount + 1
        }

        return newState
      end
    end
  )

  return rx.Observable.merge(
    initialReducer,
    clickReducer
  )
end
```

Note that as we now have more than one reducer streams, we must merge them
together to return a single stream of all reducers.


### Render

The `render` function, as you may expect, is where we define what gets
rendered to the screen.

As we're **just defining**, we won't acctually render anything here.
Instead, we're going to recieve the current state and return a new function,
which Wire will use to make the actual rendeing.

```lua
local function render(state)
  local message = 'Clicks: '..state.clickCount

  return function()
    love.graphics.print(message, 32, 32)
  end
end
```

### Wiring it up

Now, we're abble to define our constructor.

```lua
return function(sources)
  return {
    reducer = model(intent()),
    render = sources.state:map(render)
  }
end
```

The `reducer` key is literally the modeling of our intents. And the `render`
key is a new stream which is the result of passing to our `render` function
each emission of the state.


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
