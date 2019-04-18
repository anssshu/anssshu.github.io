---
title: Lua Environments
permalink: /docs/lua_environments/
---
Environments Tutorial
	
lua-users home
	wiki

Unlike local variables, which are stored in a special data structure in the interpreter, global variables are just stored in a table. A useful feature in Lua is the ability to change this table per-function, so the function sees a different set of global variables.

The default global table is stored inside itself under the key "_G", this is useful if you want to get an actual reference to it.

The way environments work in Lua 5.2 is very different from 5.1. Both ways will be explained here.

Environments in Lua 5.2

A function's environment is stored in an upvalue, named _ENV. As an example, here's a function that sets its environment to a custom one and uses variables from it:

    print(_ENV == _G) -- prints true, since the default _ENV is set to the global table

    a = 1

    local function f(t)
      local print = print -- since we will change the environment, standard functions will not be visible

      local _ENV = t -- change the environment. without the local, this would change the environment for the entire chunk

      print(getmetatable) -- prints nil, since global variables (including the standard functions) are not in the new env
      
      a = 2 -- create a new entry in t, doesn't touch the original "a" global
      b = 3 -- create a new entry in t
    end

    local t = {}
    f(t)

    print(a, b) --> 1 nil
    print(t.a, t.b) --> 2 3

When loading a chunk, the top-level function gets a new _ENV upvalue, and any nested functions inside it can see it. You can pretend that when loading works something like this:

    local _ENV = _G
    return function (...) -- this function is what's returned from load
      -- code you passed to load goes here, with all global variable names replaced with _ENV lookups
      -- so, for example "a = b" becomes "_ENV.a = _ENV.b" if neither a nor b were declared local
    end

Now you can see that _ENV is an ordinary local variable, how all the functions have access to the _ENV, and why if one function changes _ENV all other functions in the loaded chunks will see the change. That's why if you want a function to only change its own environment, you need to make a new _ENV local that shadows the original one.

In most cases, you don't need to use environments, unless you want to sandbox a loaded chunk, to give it convenient access to certain functions by making them look global, or to prevent it from seeing unsafe functions for security reasons. This is why 5.2's load function takes a parameter that lets you set the chunk's _ENV to a custom table, instead of _G.

    local sandbox_env = {
      print = print,
    }

    local chunk = load("print('inside sandbox'); os.execute('echo unsafe')", "sandbox string", "bt", sandbox_env)

    chunk() -- prevents os.execute from being called, instead raises an error saying that os is nil

If you actually want to make a sandbox to run untrusted code, remember that it's easy to overlook a lot of things that can be exploited, and that you would need some kind of way to limit CPU usage and memory.

Environments in Lua 5.1

In Lua 5.1, environments are their own thing, not related to locals or upvalues. Instead, each function has an environment table associated with it, that can be manipulated with the getfenv/setfenv standard functions.

getfenv and setfenv both take a function or stack level (where 1 is the current function, 2 is the function that called the current function, etc.). setfenv has a second parameter that takes the new env table, and getfenv returns the functions's current env table.

The previous example rewritten for 5.1:

    print(getfenv(1) == _G) -- prints true, since the default env is set to the global table

    a = 1

    local function f(t)
      local print = print -- since we will change the environment, standard functions will not be visible

      setfenv(1, t) -- change the environment

      print(getmetatable) -- prints nil, since global variables (including the standard functions) are not in the new env
      
      a = 2 -- create a new entry in t, doesn't touch the original "a" global
      b = 3 -- create a new entry in t
    end

    local t = {}
    f(t)

    print(a, b) --> 1 nil
    print(t.a, t.b) --> 2 3

And the sandbox example rewritten for 5.1:

    local sandbox_env = {
      print = print,
    }

    local chunk = loadstring("print('inside sandbox'); os.execute('echo unsafe')")
    setfenv(chunk, sandbox_env)

    chunk() -- prevents os.execute from being called, instead raises an error saying that os is nil

The 5.1 way is sometimes considered simpler and more versatile, but it also requires special treatment of environments (instead of using the existing local variable system). Also, the 5.2 way is designed with the idea that a function's environment is supposed to be private, instead of being accessible from everywhere without the debug library, so it can be considered safer.
RecentChanges · preferences
edit · history
Last edited June 25, 2014 11:48 pm GMT (diff) 
