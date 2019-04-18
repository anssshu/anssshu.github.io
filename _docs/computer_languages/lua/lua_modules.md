---
title: Lua Modules
permalink: /docs/lua_modules/
---
Modules Tutorial
	
lua-users home
	wiki

Creating and using Modules

There are actually two ways to make modules, the old (and deprecated) way for 5.0 and early 5.1, and the new way for 5.1 and 5.2. We will mainly explain the new way, but also the old because a lot of programs that you might come across still use it.

Create an example file mymodule.lua with the following content:

    local mymodule = {}

    function mymodule.foo()
        print("Hello World!")
    end

    return mymodule

Now to use this new module in the interactive interpreter, just do:

    > mymodule = require "mymodule"
    > mymodule.foo()
    Hello World!

In an actual script file, it would be recommended to make the mymodule variable local:

    local mymodule = require "mymodule"
    mymodule.foo()

But since we're in the interactive interpreter, that would make it out of scope on the next line, so we have to put it in a global variable.

So that you can require the same module in different files without re-running the module code, Lua caches modules in the package.loaded table. To demonstrate this, say we changed foo in mymodule.lua to now print "Hello Module!" instead. If we just continued in the same session as above the following would happen:

    > mymodule = require "mymodule"
    > mymodule.foo()
    Hello World!

To actually reload the module, we need to remove it from the cache first:

    > package.loaded.mymodule = nil
    > mymodule = require "mymodule"
    > mymodule.foo()
    Hello Module!

Another nice thing is that since they're ordinary tables stored in a variable, modules can be named arbitrarily. Say we think that "mymodule" is too long to type every time we want to use a function from it:

    > m = require "mymodule"
    > m.foo()
    Hello Module!

Other ways to create a module table

There are different ways of putting together a module table, that you can choose depending on your situation and personal preference:

Create a table at the top and add your functions to it:

    local mymodule = {}

    local function private()
        print("in private function")
    end

    function mymodule.foo()
        print("Hello World!")
    end

    function mymodule.bar()
        private()
        mymodule.foo() -- need to prefix function call with module
    end

    return mymodule

Make all functions local and put them in a table at the end:

    local function private()
        print("in private function")
    end

    local function foo()
        print("Hello World!")
    end

    local function bar()
        private()
        foo() -- do not prefix function call with module
    end

    return {
      foo = foo,
      bar = bar,
    }

A combination of the two examples above:

    local mymodule = {}

    local function private()
        print("in private function")
    end

    local function foo()
        print("Hello World!")
    end
    mymodule.foo = foo

    local function bar()
        private()
        foo()
    end
    mymodule.bar = bar

    return mymodule

You can even change the chunk's environment to store any global variables you create into the module:

    local print = print -- the new env will prevent you from seeing global variables

    local M = {}
    if setfenv then
    	setfenv(1, M) -- for 5.1
    else
    	_ENV = M -- for 5.2
    end

    local function private()
        print("in private function")
    end

    function foo()
        print("Hello World!")
    end

    function bar()
        private()
        foo()
    end

    return M

Or if you don't want to have to save all the globals you need into locals:

    local M = {}
    do
    	local globaltbl = _G
    	local newenv = setmetatable({}, {
    		__index = function (t, k)
    			local v = t[k]
    			if v == nil then return globaltbl[k] end
    			return v
    		end,
    		__newindex = M,
    	})
    	if setfenv then
    		setfenv(1, newenv) -- for 5.1
    	else
    		_ENV = newenv -- for 5.2
    	end
    end

    local function private()
        print("in private function")
    end

    function foo()
        print("Hello World!")
    end

    function bar()
        private()
        foo()
    end

    return M

Note that it might make access to global and module variables a bit slower, since it uses an __index function. And the reason an empty "proxy" table is used instead of giving the module an __index metamethod pointing to _G is because this would happen:

    > require "mymodule"
    > mymodule.foo()
    Hello World!
    > mymodule.print("example") -- unwanted __index metamethod
    example

The old way of creating modules

Lua 5.0 and 5.1 have a module function that's used like this:

mymodule.lua:

    module("mymodule", package.seeall)

    function foo() -- create it as if it's a global function
        print("Hello World!")
    end

And it would be used like this:

    > require "mymodule"
    > mymodule.foo()
    Hello World!

The way it works is it creates a new table for the module, stores it in the global named by the first argument to module, and sets it as the environment for the chunk, so if you create a global variable, it gets stored in the module table.

This would make it so the module can't see global variables (like print). One solution would be so store all needed standard functions in locals before calling module, but that can be tedious, so the solution was module's second parameter, which should be a function that's called with the module table as the parameter. package.seeall gives the module a metatable with an __index that points to the global table, so the module can now use global variables. The problem with this is that the user of the module can now see global variables through the module:

    > require "mymodule"
    > mymodule.foo()
    Hello World!
    > mymodule.print("example")
    example

This is strange and unexpected at best, and could be a security hole at worst (if you give the module to a sandboxed script).

The reason module is deprecated, apart from the above issue, is the fact that it forces a global name onto the user of the module, and the fact that in 5.2 a function can't change the environment of its caller (at least not without the debug library), making module impossible to implement.

Modules for 5.0 and older ones for 5.1 use this, but 5.2 and new 5.1 modules should use the new way (returning a table).

The package table

As already mentioned above Lua uses the package library to manage modules.

package.path (for modules written in Lua) and package.cpath (for modules written in C) are the places where Lua looks for modules. They are semicolon-separated lists, and each entry can have a ? in it that's replaced with the module name. This is an example of what they look like:

    > =package.path
    ./?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/lib/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?/init.lua;/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua
    > =package.cpath
    ./?.so;/usr/local/lib/lua/5.1/?.so;/usr/lib/x86_64-linux-gnu/lua/5.1/?.so;/usr/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so

package.loaded is a table, where the already loaded modules are stored by name. As mentioned before, this acts as a cache so that modules aren't loaded twice, instead require first tries getting the module from this table, and if it's nil, then it tries loading.

package.preload is a table of functions associated with module names. Before searching the filesystem, require checks if package.preload has a matching key. If so, the function is called and its result used as the return value of require.

The other fields aren't really important for general use of Lua modules, but if you are interested in how the module system works they are described in detail in the manual: [1]

See Also

    For more and in-depth information see the sample chapter of Programming in Lua, 2nd Edition [2] and LuaModuleFunctionCritiqued.
    TheEssenceOfLoadingCode - explains the relationship between the various ways of loading external code in Lua
    ModuleDefinition - various ways to define modules 

RecentChanges · preferences
edit · history
Last edited October 28, 2013 2:15 pm GMT (diff) 
