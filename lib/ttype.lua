--[[
    allows support for custom metatable types.
    to use, give your metatable a string in its `self.__type` attribute.

]]

function ttype(obj)
    if (type(obj) == "table" and obj.__type) return obj.__type
    return type(obj)
end