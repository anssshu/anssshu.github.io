---
title: Lua inheritance
permalink: /docs/lua_inheritance/
---
Inheritance Tutorial
	
lua-users home
	wiki

This tutorial demonstrates a technique for implementing object oriented inheritance in Lua. Before continuing it is recommended that you familiarize yourself with ObjectOrientationTutorial and MetamethodsTutorial.

Simple Classes

The following example implements a class with no inheritance:

    SimpleClass = {}
    SimpleClass_mt = { __index = SimpleClass }

    -- This function creates a new instance of SimpleClass
    --
    function SimpleClass:create()
        local new_inst = {}    -- the new instance
        setmetatable( new_inst, SimpleClass_mt ) -- all instances share the same metatable
        return new_inst
    end

    -- Here are some functions (methods) for SimpleClass:

    function SimpleClass:className()
        print( "SimpleClass" )
    end

    function SimpleClass:doSomething()
        print( "Doing something" )
    end

In the above example, SimpleClass represents a table that holds all of our class's methods, like a class declaration. SimpleClass_mt is the metatable we will attach to each class instance we create. The function SimpleClass:create() creates an instance of our class SimpleClass. Construction of a class instance involves creating an empty table and then attaching our SimpleClass metamethods to it. The result of attaching the metamethods is that the new instance looks to the metatable we attached for its customised behaviour.

Method invocations on the instance will trigger the "index" event on the instance, causing a lookup on the "__index" member of the instance's metatable. The __index member is simply a reference to SimpleClass. Therefore, method invocations on the instance will cause a lookup in the SimpleClass table.

Here is an example:

    > simple = SimpleClass:create()
    > 
    > simple:className()
    SimpleClass
    > 
    > simple:doSomething()
    Doing something

Implementing Inheritance

Now we want to create a new class SubClass that inherits and, optionally, overrides functions from SimpleClass.

    -- Create a new class that inherits from a base class
    --
    function inheritsFrom( baseClass )

        -- The following lines are equivalent to the SimpleClass example:

        -- Create the table and metatable representing the class.
        local new_class = {}
        local class_mt = { __index = new_class }

        -- Note that this function uses class_mt as an upvalue, so every instance
        -- of the class will share the same metatable.
        --
        function new_class:create()
            local newinst = {}
            setmetatable( newinst, class_mt )
            return newinst
        end

        -- The following is the key to implementing inheritance:

        -- The __index member of the new class's metatable references the
        -- base class.  This implies that all methods of the base class will
        -- be exposed to the sub-class, and that the sub-class can override
        -- any of these methods.
        --
        if baseClass then
            setmetatable( new_class, { __index = baseClass } )
        end

        return new_class
    end

The function inheritsFrom(baseClass) takes a single argument, the class declaration we want to inherit from. The function returns a class declaration which we can then tailor. new_class is the new class declaration to be returned. The nested function new_class:create() is part of the class declaration returned and will create new instances of the sub class we are creating. This function creates a newinst table which uses our new class table to hold its methods. The new class table in turn looks in the baseClass if it cannot find a method we require, and thus we inherit its methods.

Inheritance Example

Building on SimpleClass we now create a class called SubClass that inherits from SimpleClass and overrides className():

    > -- Create a new class that inherits from SimpleClass
    > SubClass = inheritsFrom( SimpleClass )
    >
    > -- override className() function
    > function SubClass:className() print( "SubClass" ) end
    >
    > -- Create an instance of SimpleClass
    > simple = SimpleClass:create()
    > 
    > simple:className()
    SimpleClass



    > 
    > simple:doSomething()
    Doing something
    > 
    > -- Create an instance of SubClass
    > sub = SubClass:create()
    > 
    > sub:className()  -- Call overridden method
    SubClass
    > 
    > sub:doSomething()  -- Call base class method
    Doing something
    > 

OO Properties

We can now expand on our inheritance structure and add features that are common in other languages, like access to a class's super class and a isa() method that provides type id functionality:

    -- A new inheritsFrom() function
    --
    function inheritsFrom( baseClass )

        local new_class = {}
        local class_mt = { __index = new_class }

        function new_class:create()
            local newinst = {}
            setmetatable( newinst, class_mt )
            return newinst
        end

        if nil ~= baseClass then
            setmetatable( new_class, { __index = baseClass } )
        end

        -- Implementation of additional OO properties starts here --

        -- Return the class object of the instance
        function new_class:class()
            return new_class
        end

        -- Return the super class object of the instance
        function new_class:superClass()
            return baseClass
        end

        -- Return true if the caller is an instance of theClass
        function new_class:isa( theClass )
            local b_isa = false

            local cur_class = new_class

            while ( nil ~= cur_class ) and ( false == b_isa ) do
                if cur_class == theClass then
                    b_isa = true
                else
                    cur_class = cur_class:superClass()
                end
            end

            return b_isa
        end

        return new_class
    end

And, an example of usage:

    > SimpleClass = inheritsFrom( nil )  -- pass nil because SimpleClass has no super class
    > 
    > SubClass = inheritsFrom( SimpleClass )
    > 
    > FinalClass = inheritsFrom( SubClass )
    > 
    > sub = SubClass:create()
    > fc = FinalClass:create()
    > 
    > print( fc:isa( SubClass ) )
    true
    > print( fc:isa( FinalClass ) )
    true
    > print( sub:isa( SubClass ) )
    true
    > print( sub:isa( FinalClass ) )
    false

Alternative Approach: Prototype Based

    Prototype-based programming is a style of object-oriented programming in which classes are not present, and behavior reuse (known as inheritance in class-based languages) is performed via a process of cloning existing objects that serve as prototypes. This model can also be known as class-less, prototype-oriented or instance-based programming. 

[Wikipedia article on Prototype-based programming]

Most of the code is basically the same as above, but reduced to only the essentials needed to make "Prototype based programming" work. More exactly it allows prototype programming using cloning and prototype delegation. Access to a property not set in an object is delegated to it's prototype. This code uses the table table as the very basic prototype, and object as a specialization of table. The function object.isa is not strictly needed for the prototype paradigm, but more of a convenience.

Function clone(base_object[, clone_object]) -> table

Parameters:

    base_object: table, the base object to be cloned.
    clone_object: table, an optional object to turn into a clone of base_object. 

Returns:

    table: the new clone. 

If new_object is not of type table new_object is returned if it's not nil in which case base_object is returned. new_object has it's metatable set to itself, and it's __index now points to it's prototype base_object. clone is also available as object.clone.

    It also has potential problems with boolean values being passed as either argument, because, uhm... as exercise for the reader!? ;-) 

Function isa( clone_object, base_object) -> bool

Parameters:

    clone_object: table, the clone to check
    base_object: table, the suspected base of clone_object. 

Returns:

    bool: clone has base in the prototype hierarchy. 

If neither of the arguments is a table isa falls back to returning the comparison of the types. It's also available as object.isa.

    This function will get bad performance on deep prototype hierarchies. 

The Code

    function clone( base_object, clone_object )
      if type( base_object ) ~= "table" then
        return clone_object or base_object 
      end
      clone_object = clone_object or {}
      clone_object.__index = base_object
      return setmetatable(clone_object, clone_object)
    end

    function isa( clone_object, base_object )
      local clone_object_type = type(clone_object)
      local base_object_type = type(base_object)
      if clone_object_type ~= "table" and base_object_type ~= table then
        return clone_object_type == base_object_type
      end
      local index = clone_object.__index
      local _isa = index == base_object
      while not _isa and index ~= nil do
        index = index.__index
        _isa = index == base_object
      end
      return _isa
    end

    object = clone( table, { clone = clone, isa = isa } )

Examples

    -- testing "isa"
    foo = object:clone()
    bar = object:clone()
    baz = foo:clone()

    print( foo:isa(object) )
    print( bar:isa(foo) )
    print( baz:isa(foo) )

    --[[ output:
    true
    false
    true
    ]]

    --testing prototype delegation

    foo = object:clone()
    bar = foo:clone()

    function foo:speak()
      print(self.thoughts or "foo has no thoughts")
    end

    bar:speak()

    --[[ output:
    foo has no thoughts
    ]]

    bar.thoughts = "I may be a clone, but I'm an individual!"
    bar:speak()

    --[[ output:
    I may be a clone, but I'm an individual!
    ]]

Contributors: KevinBaca

See Also

    ObjectOrientedProgramming 

RecentChanges · preferences
edit · history
Last edited November 18, 2011 11:09 am GMT (diff) 
