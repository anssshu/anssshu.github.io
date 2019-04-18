---
title: Lua Numbers
permalink: /docs/lua_numbers/
---
Numbers Tutorial
	
lua-users home
	wiki

Internal representation

Some languages support one or more of the following number types by default:

    Integer
    Unlimited precision integer
    Single precision floating point
    Double precision floating point
    Complex fun 

In the interest of simplicity Lua supports only one type of number: floating point numbers. By default these are double precision floating point numbers. However Lua can easily be recompiled to support single precision floating point numbers should you so desire. If you are unfamiliar with floating point it may be advantageous for you to read about FloatingPoint numbers.

The main thing to remember is that if you use numbers with fractional parts (or division), they may have a rounding error.

Also numbers which have infinitely repeating patterns in decimal will not have them in binary, so don't assume that any fractional number is "safe". The main thing to remember is don't use the == operator with fractional numbers since it checks for perfect equality. The other thing to remember is to write your code so that rounding error can't build up to large amounts over time.

If your numbers are integers (with no fractional part), and they don't reach 2^53; then you won't need to worry about these issues.

Using numbers

We can use the Lua interactive command line prompt as a calculator by prefixing an expression by =, e.g.,

    Lua 5.1  Copyright (C) 1994-2006 Lua.org, PUC-Rio
    > = 1
    1
    > = 1 + 2
    3
    > = 3.1415927
    3.1415927
    > = 5 / 6
    0.83333333333333

We can enter numbers and evaluate simple calculations. Lua can also understand exponent types for expressing numbers in the form <value> * 10 ^ <exponent>

    > = 1.2345e6
    1234500
    > = 543.21E8
    54321000000
    > = 2.56e-4
    0.000256

We can assign numbers to variables and do arithmetic:

    > width = 7.5
    > height = 12.7
    > = width * height
    95.25
    > depth = 2.8
    > area = width * height
    > volume = area * depth
    > print(area, volume)
    95.25   266.7

The math library

Lua is equipped with a math library (see section 5.6 of the Reference Manual [1]). The functions provided are as follows:

    math.abs     math.acos    math.asin       math.atan    math.atan2
    math.ceil    math.cos     math.cosh       math.deg     math.exp
    math.floor   math.fmod    math.frexp      math.ldexp   math.log
    math.log10   math.max     math.min        math.modf    math.pow
    math.rad     math.random  math.randomseed math.sin     math.sinh
    math.sqrt    math.tan     math.tanh

We'll try a few of the functions and variables as an example.

    > = math.sqrt(101)
    10.049875621121
    > = math.pi
    3.1415926535898
    > = math.sin( math.pi/3 )
    0.86602540378444

Read the MathLibraryTutorial for more details.

Conversion

You can convert strings to numbers using the function tonumber(). This takes a string argument and returns a number.

    > = tonumber("123") + 25
    148
    > x = tonumber("123.456e5")
    > print(x)
    12345600

Coercion

Lua will automatically convert string and number types to the correct format to perform calculations. For example: if you try to apply an arithmetic operation to a string Lua will try to convert that string to a number first. Otherwise the operation will not work. If the string cannot be converted to a number an error is raised. This automatic conversion of types is called coercion.

    > = 100 + "7"
    107
    > = "1000" + 234
    1234
    > = "hello" + 234
    stdin:1: attempt to perform arithmetic on a string value
    stack traceback:
            stdin:1: in main chunk
            [C]: ?
    > = 234 + "1000"
    1234

You can see the calculation succeeds where a string was converted to number. The string "hello" cannot be converted to a number and so an error occurs. In statically typed languages (e.g. C) this would cause an error because you cannot assign a value to a variable of an incompatible type without a cast. This works in Lua because it is dynamically typed.

A notable exception: comparison operators (== ~= < > <= >=) do not coerce their arguments. The (in)equality operators consider a number to be not equal to its string representation (or any non-number type in fact). Ordered comparison operators throw an error when you feed them different types.

    > = 100 == "100"
    false
    > = 100 ~= "hello"
    true
    > = 100 ~= {}
    true
    > = 100 == tonumber("100")
    true
    > = 100 <= "100"
    stdin:1: attempt to compare number with string
    stack traceback:
            stdin:1: in main chunk
            [C]: ?

For performance reasons you should avoid relying on automatic coercion too much. Make sure that all numbers in performance sensitive computations (especially in inner loops) are of the proper type. RecentChanges · preferences
edit · history
Last edited August 4, 2014 10:43 am GMT (diff) 
