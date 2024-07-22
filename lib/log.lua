--[[
    a function that can log.

]]

include("lib/tstr.lua")

function log(file, contents, argv)

    -- navigates to the home directory.
    -- im sure there's a better way of having consistent paths,
    -- but i'm no os expert.
    while (pwd() != "/") do cd("..") end
    
    -- sets default value
    argv = argv or {}

    if (not file) then
        print("log(file, contents, argv)")
        exit(1)
    end

    -- if no file was specified, default to log.txt
    if (not contents) then
        contents = file
        file = "log.txt"
    end

    -- ensures the contents are a table
    if (type(contents) != "table") contents = {contents}



    -- checks if the file is actually a file.
    -- this mostly matters from calling this from the command line
    if (not file:find(".", 1, true)) then
        add(contents, file, 1)
        file = "log.txt"
    end

    -- checks arguments
    local append = false        -- start new file or append to existing
    local dir = "/appdata/logs" -- directory to store logs
    for i = 1, #argv do
        if (argv[i] == "-a") append = true
        if (sub(argv[i], 1, 2) == "-d") dir = sub(argv[i], 4)
    end

    -- ensures the directory exists
    for i = 2, #dir do
        if (dir[i] == "/" or i == #dir) then
            if (not fstat(sub(dir, 1, i))) mkdir(sub(dir, 1, i))
        end
    end

    -- gets target path for easy reference
    local target = dir .. "/" .. file

    -- ensures the file exists
    if (not fstat(target)) store(target, "")

    -- constructs the string to store
    local new_contents = ""

    if (append) new_contents = fetch(target)

    for i = 1, #contents do
        new_contents ..= contents[i] .. "\n"
    end

    -- writes to the file
    store(target, new_contents)
end