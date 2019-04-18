---
title: Lua Objects
permalink: /docs/lua_objects/
---
Object Orientation Tutorial
	
lua-users home
	wiki

Lua is not really an object-oriented language, and it doesn't have a built-in concept of classes. But it is easily possible to create your own class system using tables and metatables.

Simple metatable-based class

    local MyClass = {} -- the table representing the class, which will double as the metatable for the instances
    MyClass.__index = MyClass -- failed table lookups on the instances should fallback to the class table, to get methods

    -- syntax equivalent to "MyClass.new = function..."
    function MyClass.new(init)
      local self = setmetatable({}, MyClass)
      self.value = init
      return self
    end

    function MyClass.set_value(self, newval)
      self.value = newval
    end

    function MyClass.get_value(self)
      return self.value
    end

    local i = MyClass.new(5)
    -- tbl:name(arg) is a shortcut for tbl.name(tbl, arg), except tbl is evaluated only once
    print(i:get_value()) --> 5
    i:set_value(6)
    print(i:get_value()) --> 6

First we create a table to represent the class and contain its methods. We also make it double as the metatable for instances, but you can use a separate instance metatable if you like.

In the constructor, we create the instance (an empty table), give it the metatable, fill in fields, and return the new instance.

In the methods, we use a "self" parameter to get the instance to operate on. This is so common that Lua offers the : syntax sugar that calls a function entry from a table and inserts the table itself before the first arg.

There are some improvements that can be made:

    local MyClass = {}
    MyClass.__index = MyClass

    setmetatable(MyClass, {
      __call = function (cls, ...)
        return cls.new(...)
      end,
    })

    function MyClass.new(init)
      local self = setmetatable({}, MyClass)
      self.value = init
      return self
    end

    -- the : syntax here causes a "self" arg to be implicitly added before any other args
    function MyClass:set_value(newval)
      self.value = newval
    end

    function MyClass:get_value()
      return self.value
    end

    local instance = MyClass(5)
    -- do stuff with instance...

Here we add a metatable to the class table that has the __call metamethod, which is triggered when a value is called like a function. We make it call the class's constructor, so you don't need the .new when creating instances. Another option would be to put the constructor right in the metamethod.

Also, to complement the : method call shortcut, Lua lets you use : when defining a function in a table, which implicitly adds a self argument so you don't have to type it out yourself.

Inheritance

It's easy to extend the design of the class in the above example to use inheritance:

    local BaseClass = {}
    BaseClass.__index = BaseClass

    setmetatable(BaseClass, {
      __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
      end,
    })

    function BaseClass:_init(init)
      self.value = init
    end

    function BaseClass:set_value(newval)
      self.value = newval
    end

    function BaseClass:get_value()
      return self.value
    end

    ---

    local DerivedClass = {}
    DerivedClass.__index = DerivedClass

    setmetatable(DerivedClass, {
      __index = BaseClass, -- this is what makes the inheritance work
      __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
      end,
    })

    function DerivedClass:_init(init1, init2)
      BaseClass._init(self, init1) -- call the base class constructor
      self.value2 = init2
    end

    function DerivedClass:get_value()
      return self.value + self.value2
    end

    local i = DerivedClass(1, 2)
    print(i:get_value()) --> 3
    i:set_value(3)
    print(i:get_value()) --> 5

Here we have the derived class table an __index metamethod that makes it inherit the base class. Also we moved the creating of the instance into the __call metamethods, and turned the constructors purely into initialization methods. This is so that the derived class can call the base class initialization function on itself.

One final optimization that can be done is to copy the contents of the base class into the derived class instead of using __index. This avoids the long __index chain that can slow down method calls, and also makes it so that if the base class has methods like __add, they will work like proper metamethods on the derived class. This is because __index is not followed when looking for metamethods:

    local DerivedClass = {}
    for k, v in pairs(BaseClass) do
      DerivedClass[k] = v
    end
    DerivedClass.__index = DerivedClass

Class creation function

Knowing all this, it's possible to create a convenience function that creates classes, optionally inheriting from other classes. Here is an example of such a function:

    function (...)
      -- "cls" is the new class
      local cls, bases = {}, {...}
      -- copy base class contents into the new class
      for i, base in ipairs(bases) do
        for k, v in pairs(base) do
          cls[k] = v
        end
      end
      -- set the class's __index, and start filling an "is_a" table that contains this class and all of its bases
      -- so you can do an "instance of" check using my_instance.is_a[MyClass]
      cls.__index, cls.is_a = cls, {[cls] = true}
      for i, base in ipairs(bases) do
        for c in pairs(base.is_a) do
          cls.is_a[c] = true
        end
        cls.is_a[base] = true
      end
      -- the class's __call metamethod
      setmetatable(cls, {__call = function (c, ...)
        local instance = setmetatable({}, c)
        -- run the init method if it's there
        local init = instance._init
        if init then init(instance, ...) end
        return instance
      end})
      -- return the new class table, that's ready to fill with methods
      return cls
    end

Closure-based objects

It's also possible to make objects using closures. Instances are slower to create and use more memory, but there are also some advantages (like faster instance field access), and it's an interesting example of how closures can be used.

    local function MyClass(init)
      -- the new instance
      local self = {
        -- public fields go in the instance table
        public_field = 0
      }

      -- private fields are implemented using locals
      -- they are faster than table access, and are truly private, so the code that uses your class can't get them
      local private_field = init

      function self.foo()
        return self.public_field + private_field
      end

      function self.bar()
        private_field = private_field + 1
      end

      -- return the instance
      return self
    end

    local i = MyClass(5)
    print(i.foo()) --> 5
    i.public_field = 3
    i.bar()
    print(i.foo()) --> 9

Notice that the . syntax was used to call methods, not :. This is because the self variable is already stored in the methods as an upvalue, so it doesn't need to be passed in by the code calling it.

Inheritance is also possible this way:

    local function BaseClass(init)
      local self = {}

      local private_field = init

      function self.foo()
        return private_field
      end

      function self.bar()
        private_field = private_field + 1
      end

      -- return the instance
      return self
    end

    local function DerivedClass(init, init2)
      local self = BaseClass(init)

      self.public_field = init2

      -- this is independent from the base class's private field that has the same name
      local private_field = init2

      -- save the base version of foo for use in the derived version
      local base_foo = self.foo
      function self.foo()
        return private_field + self.public_field + base_foo()
      end

      -- return the instance
      return self
    end

    local i = DerivedClass(1, 2)
    print(i.foo()) --> 5
    i.bar()
    print(i.foo()) --> 6

Table- vs. Closure-based classes

Advantages of table-based:

    Creating instances of table-based classes is faster, since you only create the instance table and its fields, and the methods are shared by all instances.
    Table-based instances use less memory, since the methods are not duplicated for each instance.
    It's possible to get a method directly from the class (for example MyClass.method(instance, args)).
    Many Lua developers might find : for method calls more consistent with the vast majority of object-oriented Lua code. 

Advantages of closure-based:

    Closure-based instances can have truly private fields, so that the users of your class cannot accidentally or intentionally get to them.
    Access to private fields is faster with closure-based classes, since they're upvalues, not table lookups.
    Method calls are faster, since they don't have to go through an __index metamethod.
    Many developers from other languages may find the . method call syntax more familiar. 

See Also

    ObjectOrientedProgramming - links and discussions on using object oriented programming techniques in Lua. 

RecentChanges · preferences
edit · history
Last edited August 1, 2014 9:50 am GMT (diff) 	
