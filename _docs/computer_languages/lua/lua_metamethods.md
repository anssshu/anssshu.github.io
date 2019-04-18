---
title: Lua Metamethods
permalink: /docs/lua_metamethods/
---
Metamethods Tutorial
	
lua-users home
	wiki

This is a brief introduction to the concepts of Lua metamethods.

Metamethods

Lua has a powerful extension mechanism which allows you to overload certain operations on Lua objects. Each overloaded object has a metatable of function metamethods associated with it; these are called when appropriate, similar to the concept of operator overloading from many other languages.

A metatable is a regular Lua table containing a set of metamethods, which are associated with events in Lua. Events occur when Lua executes certain operations, like addition, string concatenation, comparisons etc. Metamethods are regular Lua functions which are called when a specific event occurs. The events have names like "add" and "concat" (see manual section 2.8) which correspond with string keys in the metatable like "__add" and "__concat". In this case to add (+) or concatenate (..) two Lua objects.

Metatables

We use the function setmetatable() to make a table act as a metatable for a certain object.

    local x = {value = 5} -- creating local table x containing one key,value of value,5

    local mt = {
      __add = function (lhs, rhs) -- "add" event handler
        return { value = lhs.value + rhs.value }
      end
    }

    setmetatable(x, mt) -- use "mt" as the metatable for "x"

    local y = x + x

    print(y.value) --> 10  -- Note: print(y) will just give us the table code i.e table: <some tablecode>

    local z = y + y -- error, y doesn't have our metatable. this can be fixed by setting the metatable of the new object inside the metamethod

When the addition operator finds that its operands aren't numbers, it tries checking if one of them has a metatable with an __add key. In this case it does, so it runs the function stored under that key in the metatable, equivalent to this:

    local y = (getmetatable(x).__add(x, x)) -- x + x

Metatables are still triggered with math operators if one of the operands is a number. And the left operand is always the first parameter to the function, and the right operand is always the second. This means that the table that has the metamethod might not necessarily be the first parameter to the metamethod.

More events

The following are notes on other of the metamethod events that Lua handles. For a full list of metamethod events, see: MetatableEvents.

__index

This is a very commonly used and versatile metamethod, it lets you run a custom function or use a "fallback" table if a key in a table doesn't exist. If a function is used, its first parameter will be the table that the lookup failed on, and the second parameter will be the key. If a fallback table is used, remember that it can trigger an __index metamethod on it if it has one, so you can create long chains of fallback tables.

    local func_example = setmetatable({}, {__index = function (t, k)  -- {} an empty table, and after the comma, a custom function failsafe
      return "key doesn't exist"
    end})

    local fallback_tbl = setmetatable({   -- some keys and values present, together with a fallback failsafe
      foo = "bar",
      [123] = 456,
    }, {__index=func_example})

    local fallback_example = setmetatable({}, {__index=fallback_tbl})  -- {} again an empty table, but this time with a fallback failsafe

    print(func_example[1]) --> key doesn't exist
    print(fallback_example.foo) --> bar
    print(fallback_example[123]) --> 456
    print(fallback_example[456]) --> key doesn't exist

__newindex

This metamethod is called when you try to assign to a key in a table, and that key doesn't exist (contains nil). If the key exists, the metamethod is not triggered.

    local t = {}

    local m = setmetatable({}, {__newindex = function (table, key, value)
      t[key] = value
    end})

    m[123] = 456
    print(m[123]) --> nil
    print(t[123]) --> 456

Comparison operators

__eq is called when the == operator is used on two tables, the reference equality check failed, and both tables have the same __eq metamethod (!).

__lt is called to check if one object is "less than" another. Unlike __eq, it's not an error if the two objects have different __lt metamethods, the one on the left will be used.

That's all you need for all of the comparison operators to work with your object. But there will be some cases where both __lt and __eq will need to be called by the same operator. To avoid this, you can optionally add the __le (less than or equal to) metamethod. Now only one of the metamethods will be called with any of the comparison operators.

For example, we can improve the example at the top of the page like this:

    local mt
    mt = {
      __add = function (lhs, rhs)
        return setmetatable({value = lhs.value + rhs.value}, mt)
      end,
      __eq = function (lhs, rhs)
        return lhs.value == rhs.value
      end,
      __lt = function (lhs, rhs)
        return lhs.value < rhs.value
      end,
      __le = function (lhs, rhs) -- not really necessary, just improves "<=" and ">" performance
        return lhs.value <= rhs.value
      end,
    }

__metatable

__metatable is for protecting metatables. If you do not want a program to change the contents of a metatable, you set its __metatable field. With that, the program cannot access the metatable (and therefore cannot change it).

Metamethod manual

See [1] for a list of all metamethods and explanations of what they do.

See Also

    MetatableEvents
    ObjectOrientationTutorial
    LuaClassesWithMetatable
    Section 2.8 of the Reference Manual [2] covers Metatables.
    "Chapter 7: Effecting Large-Scale Change (with little trauma) using Metatables" by Sérgio Alvarez Maffra and PedroMillerRabinovitch in Lua Programming Gems (see LuaBooks) outlines some practical applications of metatables, particularly in illustrating how adding only a little metatable code can be used to make significant system-wide changes in a program. 

RecentChanges · preferences
edit · history
Last edited August 16, 2014 6:47 am GMT (diff) 
