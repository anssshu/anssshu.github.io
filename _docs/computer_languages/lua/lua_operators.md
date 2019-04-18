---
title: Lua Operators
permalink: /docs/lua_operators/
---
Operators Tutorial
	
lua-users home
	wiki

Expressions are evaluated in order to perform calculations which may assign values to variables or pass arguments to functions. Expressions are covered pretty well in section 2.5 of the Reference Manual.[1] Expressions are covered here for completeness and to offer more examples.

We'll use the = expression shorthand notation for this page. The values can easily be assigned to a variable, e.g.,

    > x = 7
    > print(x)
    7
    > = 7
    7

Arithmetic expressions

Lua has the usual binary arithmetic operators.

    > = 2+3, 5-12, 2*7, 7/8
    5       -7      14      0.875
    > = 5*(2-8.3)/77.7+99.1
    98.694594594595

Unary negation:

    > = -(-10), -(10)
    10      -10

Modulo (division remainder):

    > = 15%7, -4%3, 5.5%1
    1       -1       0.5

Power of:

    > = 7^2, 107^0, 2^8
    49      1       256

Relational expressions

Relational operators are supplied which return the boolean values true or false.

    == equal to
    ~= not equal to
    < less than
    > greater than
    <= less than or equal to
    >= greater than or equal to 

Examples:

    > = 1 == 1, 1 == 0
    true    false
    > = 1 ~= 1, 1 ~= 0
    false   true
    > = 3 < 7, 7 < 7, 8 < 7
    true	false	false
    > = 3 > 7, 7 > 7, 8 > 7
    false	false	true
    > = 3 <= 7, 7 <= 7, 8 <= 7
    true    true    false
    > = 3 >= 7, 7 >= 7, 8 >= 7
    false   true    true

These also work on strings (alphabetical order) and other types.

    > = "abc" < "def"
    true
    > = "abc" > "def"
    false
    > = "abb" < "baa"
    true
    > = "abc" == "abc"
    true
    > = "abc" == "a".."bc"
    true

Objects will not be equal if the types are different or refer to different objects.

    > = {} == "table"
    false
    > = {} == {}  -- two different tables are created here
    false
    > t = {}
    > t2 = t
    > = t == t2   -- we're referencing the same table here
    true

Coercion does not work here, the types must be converted explicitly. See NumbersTutorial and StringsTutorial for explanation of coercion.

    > = "10" == 10
    false
    > = tonumber("10") == 10
    true

Logical operators

Lua provides the logical operators and, or and not. In Lua both nil and the boolean value false represent false in a logical expression. Anything that is not false (either nil or false) is true, including 0, which might be surprising coming from some other languages. There are more notes on the implications of this at the end of this page.

    > = false==nil   -- although they are both considered false by logical operators, they're still different values
    false
    > = true==false, true~=false
    false   true
    > = 1==0
    false

not

The keyword not inverts a logical expression value:

    > = true, false, not true, not false
    true    false   false   true
    > = not nil       -- nil represents false
    true
    > = not not true  -- true is not not true!
    true
    > = not "foo"     -- anything not false or nil is true
    false

and

The binary operator and does not necessarily return a boolean value true or false to the logical expression x and y. In some languages the and operator returns a boolean dependent on the two inputs. Rather in Lua, it returns the first argument (without even executing the second one) if its value is false or nil, and the second argument if the first argument is not false or nil. So, a boolean is only returned if the first argument is false or the second argument is a boolean. Aka minimal evaluation.

    > = false and true  -- false is returned because it is the first argument
    false
    > = nil and true    -- as above
    nil
    > = nil and false
    nil
    > = nil and "hello", false and "hello"
    nil     false
    > = false and print("hello") -- the print function isn't evaluated, so "hello" isn't printed
    false

All of the above expressions return the first argument. All of the following expressions return the second argument, as the first is true.

    > = true and false
    false
    > = true and true
    true
    > = 1 and "hello", "hello" and "there"
    hello   there
    > = true and nil
    nil
    > = true and print("hello") -- the print function is evaluated here, so "hello" is printed
    hello
    nil

As you can see the logical expressions are still evaluated correctly but we have some interesting behaviour because of the values returned.

or

The or binary operator also does not necessarily return a boolean value (see notes for and above). If the first argument is not false or nil it is returned, otherwise the second argument is returned. So, a boolean is only returned if the first argument is true or the second argument is a boolean.

    > = true or false
    true
    > = true or nil
    true
    > = "hello" or "there", 1 or 0
    hello   1
    > = true or print("hello") -- the print function isn't evaluated, so "hello" isn't printed
    true

All of the above expressions return the first argument. All of the following expressions return the second argument, as the first is false or nil.

    > = false or true
    true
    > = nil or true
    true
    > = nil or "hello"
    hello
    > = false or print("hello") -- the print function is evaluated here, so "hello" is printed
    hello

This can be a very useful property. For example, setting default values in a function:

    > function foo(x)
    >>  local value = x or "default"  -- if argument x is false or nil, value becomes "default"
    >>  print(value, x)
    >> end
    >
    > foo()       -- no arguments, so x is nil
    default nil
    > foo(1)
    1       1
    > foo(true)
    true    true
    > foo("hello")
    hello   hello

Ternary operators

Even though Lua doesn't have a ternary operator (if/else expression), it's possible to create similar behavior with and and or:

    value = condition and trueval or falseval;

If condition is true, trueval is returned, otherwise falseval is returned. To help understand this, remember that and has a higher precedence than or:

    value = (condition and trueval) or falseval;

If condition is true, this causes the and to run trueval and return its value. Otherwise, the whole and part of the expression will be false, triggering the or expression to run falseval. Note that this has the issue that falseval will be run if trueval is nil or false. This can be worked around by negating the condition if you know falseval is always a "true" value, otherwise you'll just need to use an if-then-else statement.

This does not work in a case of "value = false and true or false".
RecentChanges · preferences
edit · history
Last edited May 9, 2014 4:28 pm GMT (diff) 
