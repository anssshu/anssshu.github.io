---
title: Lua Assignment
permalink: /docs/lua_assignment/
---
Assignment Tutorial
	
lua-users home
	wiki

Assigning values

Setting the value of a variable is an assignment:

    > x = 1
    > y = "hello"
    > print(x,y)
    1       hello

You can read about assignments in section 2.4.3 of the Reference Manual.[1]

Multiple assignment

In Lua we can perform multiple assignments in a single statement, e.g.,

    > x, y = 2, "there"
    > print(x,y)
    2       there 

The list of values on the right is assigned to the list of variables on the left of the =. We can assign as many values as we like and they don't all have to be of the same type. e.g.,

    > a,b,c,d,e,f = 1,"two",3,3.14159,"foo",{ this="a table" }
    > print(a,b,c,d,e,f)
    1       two     3       3.14159 foo     table: 0035BED8

Values on the right of the equal sign can be expressions, like i+1. Values on the left side however cannot.

Multiple assignment comes with a few caveats as described below.

Evaluation occurs before assignment

Any expressions are evaluated first. The evaluated expression is then assigned.

    > i = 7
    > i, x = i+1, i
    > print(i, x)
    8       7

When Lua reaches the second line it evaluates the expressions i+1 and i before anything else. After evaluation the second line becomes i, x = 8, 7. Then it performs the assignments from right to left. (see below for assignment order).

Swapping values

Values are assigned as though all assignments are simultaneous. So you can use multiple assignment to swap variable values around.

    > a,b = 1,2  -- set initial values
    > print(a,b)
    1       2
    > a,b = b,a  -- swap values around
    > print(a,b)
    2       1
    > a,b = b,a  -- and back again
    > print(a,b)
    1       2

Note that there is no need for a temporary variable (such as bold = b; b = a; a = bold;). Using a temporary variable like that would be common in C Language programming; but isn't necessary in Lua.

Assignment order

The order in which multiple assignments are performed is not defined. This means you shouldn't assume the assignments are made from left to right. If the same variable or table reference occurs twice in the assignment list the results may surprise you.

    > a, a = 1, 2
    > print(a)
    1

In the above example Lua does assignments from right-to-left, e.g. a=2 and then a=1. However we shouldn't depend on this being consistent in future versions of Lua. You should use separate assignment statements if the order of assignment is important to you.

Mismatched list sizes

If a value list is longer than the variable list the extra values are ignored.

    > a,b,c = 1,2,3,4,5,6
    > print(a,b,c)
    1       2       3

Lua assigns the value nil to the variables without a value if a value list is shorter than the variable list.

    > a,b,c,d = 1,2
    > print(a,b,c,d)
    1       2       nil     nil

RecentChanges · preferences
edit · history
Last edited August 4, 2014 10:18 am GMT (diff) 
