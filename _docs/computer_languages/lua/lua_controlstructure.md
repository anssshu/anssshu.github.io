---
title: Lua Control Structures
permalink: /docs/lua_controlstructure/
---
Control Structure Tutorial
	
lua-users home
	wiki

Control structures let your program make choices, or to run the same piece of code many times.

if statement

The if statement lets you run different code based on a condition:

    if condition then
      block
    elseif condition2 then
      block
    elseif condition3 then
      block
    else
      block
    end

The if and elseif parts are checked in order, and once one of the conditions is true, it runs the block under it and skips to the end, ignoring any other elseif conditions after it. The else block is run if none of the conditions match. Finally, the elseif and else parts are optional.

    > n = 5
    > if n > 5 then print("greater than 5") else print("less than 5") end
    less than 5
    > n = 7
    > if n > 5 then print("greater than 5") else print("less than 5") end
    greater than 5

A more complex example:

    > n = 12
    > if n > 15 then
    >> print("the number is > 15")
    >> elseif n > 10 then
    >> print("the number is > 10")
    >> elseif n > 5 then
    >> print("the number is > 5")
    >> else
    >> print("the number is <= 5")
    >> end
    the number is > 10

Notice how just one of the messages is printed, even though more than one of the conditions are true: This is because once one matches, the if statement skips checking the other conditions.

while loop

    while condition do
      block
    end

This runs the block over and over in a loop, but on each iteration, it first checks the condition, and if it's false, skips to the end, breaking the loop. If the condition is always false, the block will never be run.

    > i = 1
    > while i <= 10 do
    >> print(i)
    >> i = i + 1
    >> end
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10

repeat loop

    repeat
      block
    until condition

Same as the while loop, except the condition is inverted (breaks the loop when true), and it's checked after the first iteration, so the code is guaranteed to run at least once.

    > i = 5
    > repeat
    >> print(i)
    >> i = i - 1
    >> until i == 0
    5
    4
    3
    2
    1

numeric for loop

    for variable = start, stop, step do
      block
    end

Runs the block with variable first being equal to start, then keeps incrementing it step amount and running the block again until it's greater than stop. step can be omitted and will default to 1.

You can also make the step negative, and the loop will stop once the counter variable is less than the stop value.

    > for i = 1, 5 do
    >> print(i)
    >> end
    1
    2
    3
    4
    5
    > for i = 1, 100, 8 do
    >> print(i)
    >> end
    1
    9
    17
    25
    33
    41
    49
    57
    65
    73
    81
    89
    97
    > for i = 3, -3, -1 do
    >> print(i)
    >> end
    3
    2
    1
    0
    -1
    -2
    -3
    > for i = 0, 1, 0.25 do
    >> print(i)
    >> end
    0
    0.25
    0.5
    0.75
    1
    > for i = 1, 3 do
    >> for j = 1, i do
    >> print(j)
    >> end
    >> end
    1
    1
    2
    1
    2
    3

Also remember that the variable in a for loop is only visible inside the block, it will not still be there containing the last value after the loop is broken.

iterator for loop

    for var1, var2, var3 in iterator do
      block
    end

The iterator version of the for loop takes a special iterator function, and can have any amount of variables. What the loop does, how many variables it needs, and what they will be set to depends on the iterator.

This is mainly good for tables, which haven't been introduced yet, but here's an example to give you an idea:

    > tbl = {"a", "b", "c"}
    > for key, value in ipairs(tbl) do
    >> print(key, value)
    >> end
    1       a
    2       b
    3       c

Here, ipairs is the iterator, which gets the numbered entries from a table in order.

break statement

The break statement causes Lua to jump out of the current loop:

    > i = 3
    > while true do -- infinite loop
    >> print(i)
    >> i = i + 1
    >> if i > 6 then
    >> break
    >> end
    >> end
    3
    4
    5
    6

With nested loops, break only affects the innermost one:

    > for i = 1, 2 do
    >> while true do
    >> break
    >> end
    >> print(i)
    >> end
    1
    2

Using break outside of a loop is a syntax error:

    > break
    stdin:1: <break> at line 1 not inside a loop

continue statement alternatives

Many other languages have a continue statement that skips the rest of the current iteration of the innermost loop. In Lua 5.2, this can be imitated using goto:

    > for i = 1, 10 do
    >> if i>3 and i<6 then goto continue end
    >> print(i)
    >> ::continue:: -- a name surrounded in :: :: is a goto label
    >> end
    1
    2
    3
    6
    7
    8
    9
    10

Lua 5.1 and earlier doesn't have goto, but there are other workarounds:

    > for i = 1, 10 do
    >> if not (i>3 and i<6) then
    >> print(i)
    >> end
    >> end
    1
    2
    3
    6
    7
    8
    9
    10
    > for i = 1, 10 do repeat
    >> if i>3 and i<6 then break end
    >> print(i)
    >> until true end
    1
    2
    3
    6
    7
    8
    9
    10

Conditions

Conditions don't necessarily have to be boolean values. In fact, any value is a valid condition: nil and false make the condition false, anything else (including 0) makes it true.

    > if 5 then print("true") else print("false") end
    true
    > if 0 then print("true") else print("false") end
    true
    > if true then print("true") else print("false") end
    true
    > if {} then print("true") else print("false") end
    true
    > if "string" then print("true") else print("false") end
    true
    > if nil then print("true") else print("false") end
    false
    > if false then print("true") else print("false") end
    false

Also there are some languages where variable assignment is considered an expression (so it can be used as a sub-expression), so code like this is written:

    > i = 0
    > while (i = i + 1) <= 10 do print(i) end
    stdin:1: ')' expected near '='

But in Lua assignment is a statement, and the above example is a syntax error.

if/else as an expression

Some languages have a ternary operator that acts like an if/else statement, but can be used as a sub-expression. If the condition is true, it evaluates to one expression, otherwise it evaluates the other.

Lua doesn't have such an operator, but in many cases you can imitate it using the and and or logical operators. This works for two reasons: those operators don't even run the right-side expression if the logical result is known only from the left side result, and also they directly return the result of their sub-expressions, instead of converting them to boolean:

    > = true and print("test")
    test
    nil
    > = false and print("test") -- 'and' is always false if one of the sides are false, don't bother running the other expression
    false
    > = true or print("test") -- 'or' is always true if one of the sides are true, don't bother running the other expression
    true
    > = false or print("test")
    test
    nil
    > = 8 or 5
    8
    > = true and "text"
    text

This can be used to make a simple if/else expression:

    > condition = true
    > = condition and 2 or 4
    2
    > condition = false
    > = condition and 2 or 4
    4
    > = condition and print("a") or print("b") -- only the "false" branch is run, otherwise both a and b would be printed
    b
    nil

Remember that "and" has a higher precedence than "or": If the condition is false, it makes the "and" expression give up and return false. This then makes the "or" part try its right-side expression and return its value. If the condition is true, "and" will return its right-side expression. This is then given to "or", which sees that the left result is a true condition, and just returns it.

Note that we assumed that the result of the true branch is a value that acts as a true condition. This leads to the catch: the true branch cannot evaluate to nil or false, because then the false branch will also be run and its value will be returned:

    > condition = true
    > = condition and false or true -- wrong result!
    true

This is because the whole "and" sub-expression is now false, causing "or" to try running its other sub-expression. But it is alright to return a false value from the false branch. In fact, if you're in a situation like the above example, you can just invert the condition and swap the contents of the branches:

    > condition = true
    > = not condition and true or false
    false

But if both branches must return a value that acts as a false condition, there's no way to work around that.
RecentChanges · preferences
edit · history
Last edited September 17, 2013 5:59 pm GMT (diff) 
