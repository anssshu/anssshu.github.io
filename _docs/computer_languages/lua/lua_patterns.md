---
title: Lua Patterns
permalink: /docs/lua_patterns/
---
Patterns Tutorial
	
lua-users home
	wiki

Lua patterns can match sequences of characters, where each character can be optional, or repeat multiple times. If you're used to other languages that have regular expressions to match text, remember that Lua's pattern matching is not the same: it's more limited, and has different syntax.

After reading this tutorial, it's very strongly recommended to read the manual on patterns[1], so you know everything it offers.

Introduction to patterns

First we will use the string.find function, which finds the first occurrence of a pattern in a string and returns start and end indices of the first and last characters that matched the text:

    > = string.find('banana', 'an') -- find 1st occurance of 'an' (letters are matched literally)
    2       3
    > = string.find('banana', 'lua') -- 'lua' will not be found
    nil

But literally matching text isn't that useful, so patterns have the concept of character classes. A character class is a pattern that matches one of a set of characters. For example, . is a character class that matches any character:

    > = string.find("abcdefg", 'b..')
    2 4

We can now use these indices to get the matched text, but there's a better way: the string.match function. It returns the matched text, or nil if the pattern is not found: (actually, find also returns the matched text, but it first returns the indexes; match only returns the text)

    > = string.match("abcdefg", 'b..')
    bcd

Patterns have a few pre-defined classes, use them as "%x", where "x" is the letter identifying the class:

    > = string.match("foo 123 bar", '%d%d%d') -- %d matches a digit
    123
    > = string.match("text with an Uppercase letter", '%u') -- %u matches an uppercase letter
    U

Making the letter after the % uppercase inverts the class, so %D will match all non-digit characters. See the patterns manual (linked at the top of the tutorial) for a list of all pre-defined classes.

You can also create your own classes by wrapping a group of characters in square brackets. This will match one of the characters. If the first character inside the brackets is ^, then it will match a character not in the group.

    > = string.match("abcd", '[bc][bc]')
    bc
    > = string.match("abcd", '[^ad]')
    b
    > = string.match("123", '[0-9]') -- you can specify a range of characters using -
    1

Repetition

Even with character classes this is still very limiting, because we can only match strings with a fixed length. To solve this, patterns support these four repetition operators:

    * Match the previous character (or class) zero or more times, as many times as possible.
    + Match the previous character (or class) one or more times, as many times as possible.
    - Match the previous character (or class) zero or more times, as few times as possible.
    ? Make the previous character (or class) optional. 

We'll start with ?, since it's the simplest:

    > = string.match("examples", 'examples?')
    examples
    > = string.match("example", 'examples?')
    example
    > = string.match("example", 'examples')
    nil

Now an example of +. Note how it's used with a class, so it can match a sequence of different characters:

    > = string.match("this is some text with a number 12345 in it", '%d+')
    12345

Unlike +, * can match nothing:

    > = string.match("one |two| three", '|.*|')
    |two|
    > = string.match("one || three", '|.*|')
    ||
    > = string.match("one || three", '|.+|')
    nil

A common mistake with + and * is not realizing that they match as much as possible, which may not be the desired result. One way to fix this is using -:

    > = string.match("one |two| three |four| five", '|.*|')
    |two| three |four|
    > = string.match("one |two| three |four| five", '|.-|')
    |two|
    > = string.match("one |two| three |four| five", '|[^|]*|') -- another solution can be to not let the contents match the delimiter
    |two|

When using -, you need to remember to "anchor" it from both sides, otherwise it will match nothing (since it tries to match as little as possible):

    > = string.match("abc", 'a.*')
    abc
    > = string.match("abc", 'a.-') -- the .- part matches nothing
    a
    > = string.match("abc", 'a.-$') -- the $ matches the end of the string
    abc
    > = string.match("abc", '^.-b') -- the ^ matches the start of the string
    ab

Here we also introduced ^ and $, which match the start and end of the string. They're not just for use with -, you can just prepend the pattern with ^ to make it match at the start, append $ to make it match at the end, and wrap it in both (like the example above) to make it match the whole string.

Finally, you might be thinking how to match all these special characters literally. The solution is to prepend them with a % character:

    > = string.match("%*^", '%%%*%^')
    %*^

Captures

What if you want to get certain pieces out of a string of text? This can be done by wrapping parts of a pattern in ( ), and the contents of each of these captures will be returned from string.match.

    > = string.match("foo: 123 bar: 456", '(%a+):%s*(%d+)%s+(%a+):%s*(%d+)') -- %a: letter %s: whitespace
    foo 123 bar 456

Each capture is returned as a separate result, so this is useful for splitting out values

        date = "04/19/64"
        m, d, y = string.match(date, "(%d+)/(%d+)/(%d+)")
        print("19" .. y)  --> 1964

For more on captures, see the manual [2]

Limitations of Lua patterns

Especially if you're used to other languages with regular expressions, you might expect to be able to do stuff like this:

    '(foo)+' -- match the string "foo" repeated one or more times
    '(foo|bar)' -- match either the string "foo" or the string "bar"

Unfortunately Lua patterns do not support this, only single characters can be repeated or chosen between, not sub-patterns or strings. The solution is to either use multiple patterns and write some custom logic, use a regular expression library like lrexlib or Lua PCRE, or use LPeg [3]. LPeg is a powerful text parsing library for Lua based on Parsing Expression Grammar [4]. It offers functions to create and combine patterns in Lua code, and also a language somewhat like Lua patterns or regular expressions to conveniently create small parsers.

See Also

Again, now that you have an idea of how patterns work, see the patterns manual[1] to find out all the possibilities.
RecentChanges · preferences
edit · history
Last edited June 13, 2014 6:50 pm GMT (diff) 
