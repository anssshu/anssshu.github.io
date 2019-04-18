---
title: Lua Tables
permalink: /docs/lua_tables/
---
Tables Tutorial
	
lua-users home
	wiki

Tables are the only "container" type in Lua. They are associative arrays ([1]), which means they store a set of key/value pairs. In a Key/Value pair you can store a value under a key and then later retrieve the value using that key.

Creating tables

Tables are created using table constructors, which are defined using curly brackets, e.g. { } . To define an empty table we can do the following.

    > t = {}    -- construct an empty table and assign it to variable "t"
    > print(t)
    table: 0035AE18

Notice when the value of a table is displayed only the type and unique id of the object are displayed. To print out the contents of a table we must do so explicitly. We'll learn how to do this later.

Using tables

To access the value associated with the key in a table you can use the table[key] syntax:

    > t = {}
    > t["foo"] = 123 -- assign the value 123 to the key "foo" in the table
    > t[3] = "bar" -- assign the value "bar" to the key 3 in the table
    > = t["foo"]
    123
    > = t[3]
    bar

If there's no value associated with the key, it's not an error, instead the result will be nil:

    > t = {}
    > = t["foo"]
    nil

You can erase a key/value pair from a table by assigning nil to the key.

Any value can be used as a key (not just numbers and strings) just make sure it's not nil or NaN (Not a Number):

    > t = {}
    > k = {}
    > f = function () end
    > t[k] = 123
    > t[f] = 456
    > = t[k]
    123
    > = t[f]
    456
    > t[nil] = 123
    stdin:1: table index is nil
    stack traceback:
            stdin:1: in main chunk
            [C]: in ?
    > t[0/0] = 123
    stdin:1: table index is NaN
    stack traceback:
            stdin:1: in main chunk
            [C]: in ?

But it's so common to use string constants as keys there's a special shortcut syntax for it:

    > t = {}
    > t.foo = 123 -- same as t["foo"] (but not t[foo], which would use the variable foo as the key)
    > = t.foo
    123
    > = t["foo"]
    123

The shortcut syntax is only valid if the string consists of underscores, letters, and numbers, but shouldn't start with a number.

You can also add key/value associations right inside the {} syntax:

    > t = {["foo"] = "bar", [123] = 456}
    > = t.foo
    bar
    > = t[123]
    456

There is also a syntax shortcut for string keys in {}, as long as the string conforms to the same rules as the . syntax:

    > t = {foo = "bar"} -- same as ["foo"]="bar" (but not [foo]="bar" , that would use the variable foo)
    > = t["foo"]
    bar

To loop over all the key/value pairs in a table, use the pairs iterator:

    > t = {foo = "bar", [123] = 456}
    > for key,value in pairs(t) do print(key,value) end
    foo bar
    123 456

The order when looping with pairs is undefined. Just because you added one item after adding another doesn't mean that's the order they'll be in with pairs.

Inside a pairs loop, it's safe to reassign existing keys or remove them (by assigning nil to them), but not to add new keys (that had a nil value previously).

Tables as arrays

Firstly remember tables are still just key/value containers because Lua doesn't actually have an array type. But tables can be treated like arrays which is explained here:

Table constructors can contain a comma separated list of objects to create an "array":

    > t = {"a", "b", "c"}
    > = t[1]
    a
    > = t[3]
    c

This is a syntax shortcut for:

    > t = {[1]="a", [2]="b", [3]="c"}
    > = t[1]
    a
    > = t[3]
    c

So it's still just a key/value association.

You can also mix the array syntax with the usual key=value syntax:

    > t = {"a", "b", [123]="foo", "c", name="bar", "d", "e"}
    > for k,v in pairs(t) do print(k,v) end
    1       a
    2       b
    3       c
    4       d
    5       e
    123     foo
    name    bar

The first index is the number one, unlike most other languages that start with the number zero. The reason this was chosen is because it's often more intuitive. It was also chosen because it's just a key and not an offset from the beginning. Most languages implement actual array types.

You can get the "length" of an array using the # operator:

    > t = {"a", "b", "c"}
    > = #t
    3

The # operator doesn't count all the items in the table (!). Instead it finds the last integer (non-fractional number) key. Because of how it's implemented its results are undefined if all the integer keys in the table aren't consecutive. Which is why it shouldn't be used for tables used as sparse arrays[2]).

There are two ways to add an item to the end of an array:

    > t = {}
    > table.insert(t, 123)
    > t[#t+1] = 456
    > = t[1]
    123
    > = t[2]
    456

table.insert takes an optional index parameter to insert into the middle of an array. It shifts up any other integer keys above the index:

    > t = {"a", "c"}
    > table.insert(t, 2, "b")
    > = t[1], t[2], t[3]
    a b c

table.remove removes an item from an array, shifting down any remaining integer keys:

    > t = {"a", "b", "c"}
    > table.remove(t, 2)
    > = t[1], t[2]
    a c

To loop over an array use ipairs. Unlike pairs it only gives you the consecutive integer keys from 1. It guarantees their order sequence. With pairs the number keys will not necessarily be given in the correct order!

    > t = {"a", "b", "c"}
    > for i, v in ipairs(t) do print(i, v) end
    1       a
    2       b
    3       c

To join together an array of strings there's table.concat. It takes optional separator, start, and end parameters. Here we only use the separator:

    > t = {"a", "b", "c"}
    > = table.concat(t, ";")
    a;b;c

For a list of all the table.* functions and their complete documentation, see [[3]].

Table values are references

When you pass a table to a function or store it in a new variable, etc. a new copy of that table is not created. Tables do not act like numbers in these cases. Instead the variable or function becomes a reference to the original table. This is much like a pointer in the C Language. For example:

    > t = {}
    > u = t
    > u.foo = "bar"
    > = t.foo
    bar
    > function f(x) x[1] = 2 end
    > f(t)
    > = u[1]
    2

Tables are freed from memory by the garbage collector after the last reference to them is gone. This does not always happen immediately however. The garbage collector is designed to work correctly even if a table (directly or indirectly) contains a reference to itself.

A related thing to remember is that table comparison works by reference. Comparing tables using == will return false even if the two tables have the same contents. They must actually be references to the same table.

Finally; if you want to copy a table you'll have to do it manually. Lua offers no standard function for it mainly due to all the different ways you can copy a table.

Tables as unordered sets

Often people new to Lua will create an array to store a group of objects even if the order isn't necessary. The problem with this is that removal is slow because the computer needs to shift down other items. Checking if an item is in the array is slow; again because the computer must loop over all the items.

This can be solved by storing items in the keys and setting values to a dummy value (like true). Doing that will help you use a table like an unordered set with fast insertion, removal, and lookup.

The main differences are that there's no easy way to get the count (you have to use a loop), and you can't store the same item twice in the set.

So if you need to store a group of items it's best to consider both sets and arrays to see what fits your situation best.

    local items = {}

    -- add some items to the set
    items["foo"] = true
    items[123] = true

    -- is "foo" in the set?
    if items["foo"] then
      -- do stuff
    end

    -- remove item from the set
    items[123] = nil

RecentChanges · preferences
edit · history
Last edited September 7, 2014 5:47 am GMT (diff) 
