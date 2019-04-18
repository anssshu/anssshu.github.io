---
title: Lua Functions
permalink: /docs/lua_function/
---

Functions are the main mechanism for abstraction of statements and expressions in Lua. Functions can both carry out a specific task (what is sometimes called procedure or subroutine in other languages) or compute and return values. In the first case, we use a function call as a statement; in the second case, we use it as an expression:

    print(8*9, 9/8)
    a = math.sin(3) + math.cos(10)
    print(os.date())
In both cases, we write a list of arguments enclosed in parentheses. If the function call has no arguments, we must write an empty list () to indicate the call. There is a special case to this rule: If the function has one single argument and this argument is either a literal string or a table constructor, then the parentheses are optional:
    print "Hello World"     <-->     print("Hello World")
    dofile 'a.lua'          <-->     dofile ('a.lua')
    print [[a multi-line    <-->     print([[a multi-line
     message]]                        message]])
    f{x=10, y=20}           <-->     f({x=10, y=20})
    type{}                  <-->     type({})
Lua also offers a special syntax for object-oriented calls, the colon operator. An expression like o:foo(x) is just another way to write o.foo(o, x), that is, to call o.foo adding o as a first extra argument. In Chapter 16 we will discuss such calls (and object-oriented programming) in more detail.

Functions used by a Lua program can be defined both in Lua and in C (or in any other language used by the host application). For instance, all library functions are written in C; but this fact has no relevance to Lua programmers. When calling a function, there is no difference between functions defined in Lua and functions defined in C.

As we have seen in other examples, a function definition has a conventional syntax; for instance

    -- add all elements of array `a'
    function add (a)
      local sum = 0
      for i,v in ipairs(a) do
        sum = sum + v
      end
      return sum
    end



In that syntax, a function definition has a name (add, in the previous example), a list of parameters, and a body, which is a list of statements.
Parameters work exactly as local variables, initialized with the actual arguments given in the function call. You can call a function with a number of arguments different from its number of parameters. Lua adjusts the number of arguments to the number of parameters, as it does in a multiple assignment: Extra arguments are thrown away; extra parameters get nil. For instance, if we have a function like

    function f(a, b) return a or b end
we will have the following mapping from arguments to parameters:
    CALL             PARAMETERS
       
    f(3)             a=3, b=nil
    f(3, 4)          a=3, b=4
    f(3, 4, 5)       a=3, b=4   (5 is discarded)
Although this behavior can lead to programming errors (easily spotted at run time), it is also useful, especially for default arguments. For instance, consider the following function, to increment a global counter.
    function incCount (n)
      n = n or 1
      count = count + n
    end
This function has 1 as its default argument; that is, the call incCount(), without arguments, increments count by one. When you call incCount(), Lua first initializes n with nil; the or results in its second operand; and as a result Lua assigns a default 1 to n.
