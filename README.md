# About

**Wire** is a small reactive wrapping for [LÖVE](https://love2d.org/) framework,
highly inspired in Cycle.js (web frontend framework) and it's fractal state
management, Onionify.

Wire allows you to use all the awesomeness of LÖVE in a fully
reactive and delightfull way. You just need to wire everything up
**declarativelly**, and let the data flow freely throughout your game.

# Installation

More info coming soon. :hourglass:

# How to use

## Creating a component

Every wire component follow two simple rules:

1. Separation of concerns;
2. Just logics, no side-effects.

Let's get started by creating a simple `game.lua` component containing the
following four functions:

```lua
local function intent()

end

local function reduce()

end

local function render()

end

local function constructor()

end
```
