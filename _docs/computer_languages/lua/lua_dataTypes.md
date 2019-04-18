---
title: Lua Data Types
permalink: /docs/lua_dataTypes/
---
Lua Types Tutorial
	
lua-users home
	wiki

This is a short introduction to the eight basic types of values in Lua: number, string, boolean, table, function, nil, userdata, thread. Each section introduces a different type.

Please look at TutorialExamples for notes about running the examples here. We'll use the print() function to print out values or calculations on those values. The parentheses around the arguments are important and will cause an error if omitted.

    !
    > print("hello") -- print the string hello.
    hello

Numbers

The number type represents a floating point (fractional) number. There is no separate integer (non-fractional) type.

Lua allows simple arithmetic on numbers using the usual operators to add, subtract, multiply and divide.

    > print(2+2)
    4
    > print(2-7)
    -5
    > print(7*8)
    56
    > print(7/8)
    0.875

Notice that the numbers are not rounded into integers. They are floating point, or real numbers. We can assign values to variables using the = operator.

    > x = 7
    > print(x)
    7

The = operator assigns the number 7 to the variable x. We use the print() function again to print out the value of x. We can now use the value in x for other calculations.

    > x = x * 9
    > print(x)
    63
    > print(x*2) -- will not change the value of x
    126
    > print(x)
    63

For more information on Lua's number type you can look at the NumbersTutorial.

Strings

Lua also uses strings (i.e. text) types. To create strings, wrap text in "double quotes" or 'single quotes':

    > print("hello")
    hello

We can assign strings to variables just like we can numbers:

    > who = "Lua user"
    > print(who)
    Lua user

We can concatenate (join together) strings together using the .. operator:

    > print("hello ")
    hello 
    > print("hello " .. who) -- the variable "who" was assigned above
    hello Lua user
    > print(who)
    Lua user

Unlike some other languages, you cannot use the + operator to concatenate strings. i.e.:

    > message = "hello " + who
    stdin:1: attempt to perform arithmetic on a string value
    stack traceback:
            stdin:1: in main chunk
            [C]: ?

For more information on Lua's string type you can look at the StringsTutorial.

Boolean

Boolean values have either the value true or false. If a value is not true, it must be false and vice versa. The not operator can be placed before a boolean value to invert it. i.e. not true is equal to false.

    > x = true
    > print(x)
    true
    > print(not x)
    false
    > print(not false)
    true

Boolean values are used to represent the results of logic tests. The equals ==, and not equals ~= operators will return boolean values depending on the values supplied to them.

    > print(1 == 0) -- test whether two numbers are equal
    false
    > print(1 == 1)
    true
    > print(1 ~= 0) -- test whether two numbers are not equal
    true
    > print(true ~= false) -- is true not equal to false?
    true

Note that for assignment you use a single equals sign (=), but for comparison you use a double equals sign (==). These two operators have different meanings but look similar, it's a common mistake to write one where you meant the other.

For more information on Lua's Boolean type you can look at the ExpressionsTutorial.

Tables

Lua has a general-purpose aggregate datatype called a table. Aggregate data types are used for storing collections (such as lists, sets, arrays, and associative arrays) containing other objects (including numbers, strings, or even other aggregates). Lua is a unique language in that tables (which are associative arrays) are used for representing all other aggregate types.

Tables are created using a pair of curly brackets {} . Let's create an empty table:

    > x = {}
    > print(x)
    table: 0035C910

(it is normal if your table does not have the same unique identifier as in the above example.)

The TablesTutorial will later explain how to use tables.

Functions

In Lua, functions are assigned to variables, just like numbers and strings. Functions are created using the function keyword. Here we create a simple function which will print a friendly message.

    > foo = function () print("hello") end -- declare the function
    > foo() -- call the function
    hello
    > print(foo) -- get the value of the variable "foo"
    function: 0035D6E8

Notice we can print the value of the variable foo and it displays (like tables) that the value is a function, and has unique identifier for that particular function. So, being a value just like any other, we should be able to assign functions to variables, just like the other values, and we can.

    > x = function() print("hello") end
    > x()
    hello
    > print(x)
    function: 0035EA20

The ability to do this is because Lua has first class values. This means that all values are treated the same way. This is a very powerful and useful feature of Lua.

A function can be part of a table:

    > a = "aeiou" -- a string
    > b = 13      -- a number
    > c = function()  -- a function
    >  print ("\n\n\tAin't it grand")
    > end
    > d = { a, b ,c} -- put them in a table
    > function printit(tata)  -- print their types.
    > table.unpack(tata) -- unpack the table
    > for key, value in ipairs(tata) do print(key, type(value)) end
    > end
    > printit(d)
    1       string
    2       number
    3       function
            

The FunctionsTutorial will later explain how to use functions.

nil values

nil is a special value which indicates the lack of a useful value. If you try getting a variable that doesn't exist you will get nil:

    > print(x)
    nil
    > x = 2.5
    > print(x)
    2.5

The other places where nil is used will be shown in other tutorials.

Userdata

Userdata values are objects foreign to Lua, such as objects implemented in C. These typically come about when an object in a C library is exposed to Lua. You cannot do anything with a userdata value in Lua other than pass it around, it's only useful for giving to functions exposed by the same C library that made the userdata. But using metamethods (explained in a later tutorial), it's possible to make userdata work with operators and act similar to tables. Userdata is a more advanced topic discussed further in the [Lua Reference Manual].

Thread

A thread value represents an independent (cooperative) thread of execution. These are discussed further in CoroutinesTutorial.

Dynamic typing

You might have noticed that whilst we created the above variables, we did not have to specify which type of variable we were creating. For example,

    a = 1
    b = "hello"
    c = {}

In other languages, such as C, we have to specify the type of a variable when we create it. In Lua we can also assign different types of values to the same variable, e.g.

    a = 1
    a = "hello"
    a = {}

This is called dynamic typing. This means that you don't have to specify what type a variable is. The variable knows what type it is from the value, or object, assigned to it.

Querying type

As Lua is a reflective language, we can use the Lua function type() to get a description of the type of a particular object.

    > x = "123"  -- a string
    > print(x, type(x)) -- show the value of x and its type
    123     string
    > x = x + 7  -- add a number to the string which forces coercion
    > print(x, type(x)) -- again show the value and type
    130     number

RecentChanges · preferences
edit · history
Last edited December 22, 2013 11:16 pm GMT (diff) 
