---
title: Lua Scope
permalink: /docs/lua_scope/
---
Scope Tutorial
	
lua-users home
	wiki

Until now you just assigned values to names, and could get back the value by using the name anywhere in the script. This is fine for small examples, but now that you know functions, it can be a big problem: what if different functions use the same name to store temporary values? They will conflict and overwrite each other, making your script an impossible-to-debug mess. The solution is to control where your variables exist using the local keyword.

Interactive interpreter note

The examples in this page will be written in the form of a script file instead of an interactive interpreter session, since local variables are really hard to work with in it. It will be explained why later.

Creating local variables

To create local variables, add the local keyword before the assignment:

    local a = 5
    print(a)

You don't need the local keyword any more when changing the variable:

    local a = 5
    a = 6 -- changes the local a, doesn't create a global

Local variables only exist in the block they were created in. Outside of the block, they do not exist any more.

    local a = 5
    print(a) --> 5

    do
      local a = 6 -- create a new local inside the do block instead of changing the existing a
      print(a) --> 6
    end

    print(a) --> 5

The place where a variable is visible is called the "scope" of a variable.

Now let's use functions to show how this is really useful:

    function bar()
      print(x) --> nil
      local x = 6
      print(x) --> 6
    end

    function foo()
      local x = 5
      print(x) --> 5
      bar()
      print(x) --> 5
    end

    foo()

As you can see, each variable is visible from the point where it's declared to the end of the block it's declared in. Even though bar's x exists at the same time as foo's x, they're not written in the same block, so they're independent. This is what's called lexical scoping.

local function syntax sugar

    local function f() end

    -- is equivalent to

    local f
    f = function() end

    -- not

    local f = function() end

the difference between the last two examples is important: the local variable still doesn't exist to the right of the = that gives it the initial value. So if the contents of the function used f to get a reference to itself, it will correctly get the local variable in the first and second versions, but the third version will get the global f (which will be nil, if not a completely unrelated value set by some other code).

Closures

Functions can use local variables created outside of them. These are called upvalues. A function that uses upvalues is called a closure:

    local x = 5

    local function f() -- we use the "local function" syntax here, but that's just for good practice, the example will work without it
      print(x)
    end

    f() --> 5
    x = 6
    f() --> 6

The function sees the change even if it's changed outside of the function. This means that the variable in the function is not a copy, it's shared with the outer scope.

Also, even if the outer scope has passed, the function will still hold on to the variable. If there were two functions created in the scope, they will still share the variable after the outer scope is gone.

    local function f()
      local v = 0
      local function get()
        return v
      end
      local function set(new_v)
        v = new_v
      end
      return {get=get, set=set}
    end

    local t, u = f(), f()
    print(t.get()) --> 0
    print(u.get()) --> 0
    t.set(5)
    u.set(6)
    print(t.get()) --> 5
    print(u.get()) --> 6

Since the two values returned by the two calls to f are independent, we can see that every time a function is called, it creates a new scope with new variables.

Similarly, loops create a new scope on each iteration:

    local t = {}

    for i = 1, 10 do
      t[i] = function() print(i) end
    end

    t[1]() --> 1
    t[8]() --> 8

Why are local variables difficult in the interactive interpreter

Because it runs each line in a new scope:

    > local a=5; print(a)
    5
    > print(a) -- a is out of scope now, so global a is used
    nil

One thing you can do is wrap the code in a do-end block, but it won't be interactive until you finish writing the whole block:

    > do
    >>  local a = 5
    >>  print(a) -- works on a new line
    >> end
    5

Why not local by default?

You might be coming from another language that makes variables local by default, and are probably thinking "what is the point of all this extra complication? Why not make variables local by default?":

    x = 3

    -- more code, you might have even forgotten about variable x by now...

    function ()
      -- ...
      x = 5 -- does this create a new local x, or does it change the outer one?
      -- ...
    end

    -- some more code...

The problem with changing the outer one is that you might have intended to make a new variable, and instead change the existing one that you might not even know about, introducing bugs.

The problem with creating a new one is what if you actually want to change the outer one?

With the local keyword, it's all explicit: without local, you change the existing variable, with it, you create a new one.

For more discussion about this, see LocalByDefault.

When to use local variables

The general rule is to always use local variables, unless it's necessary for every part of your program to be able to access the variable (which is very rare).

Since it's easy to forget a local, and since Lua doesn't warn you about it (instead silently creating a global), it can be a source of bugs. One solution is to use a script like strict.lua (shown below), that uses metatables (mentioned in a later tutorial) to trap global variable creation and raise an error. You can put the script in a file in your project, and do require("strict") to use it.

    --
    -- strict.lua
    -- checks uses of undeclared global variables
    -- All global variables must be 'declared' through a regular assignment
    -- (even assigning nil will do) in a main chunk before being used
    -- anywhere or assigned to inside a function.
    --

    local mt = getmetatable(_G)
    if mt == nil then
      mt = {}
      setmetatable(_G, mt)
    end

    __STRICT = true
    mt.__declared = {}

    mt.__newindex = function (t, n, v)
      if __STRICT and not mt.__declared[n] then
        local w = debug.getinfo(2, "S").what
        if w ~= "main" and w ~= "C" then
          error("assign to undeclared variable '"..n.."'", 2)
        end
        mt.__declared[n] = true
      end
      rawset(t, n, v)
    end
      
    mt.__index = function (t, n)
      if not mt.__declared[n] and debug.getinfo(2, "S").what ~= "C" then
        error("variable '"..n.."' is not declared", 2)
      end
      return rawget(t, n)
    end

    function global(...)
       for _, v in ipairs{...} do mt.__declared[v] = true end
    end

For more info about enforcing use of local variables, see DetectingUndefinedVariables.
RecentChanges · preferences
edit · history
Last edited December 21, 2013 9:07 am GMT (diff) 
