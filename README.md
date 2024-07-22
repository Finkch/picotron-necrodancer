# picotron-necrodancer

picotron-necrodancer is a tool to build animated skeletons in the Picotron fantasy workstation. It is built on three separate libraries: gui, skeleton, and lib.  
necrodancer has two modes: `skeleton` mode and `animation` mode. These modes specify what the user is editing. Buttons are used to select bones and keyframes, to add or remove bones and keyframes, and to pause or play the animation. Sliders are used edit bone and keyframe parameters, and to step through the animation frame-wise. Labels above and below the sliders can be used to increment or decrement the sliders value by one.  


## importing and exporting skeletons

By default, necrodancer stores a skeleton in Picotron's `apddata/necrodancer/skeleton.pod` as a POD file. There is also a `log.txt` stores alongside the POD with a human-readable representation of the current stored skeleton (since Picotron's `podtree` program does not seem to like these skeletons).  
The `skeleton.pod` file is created by calling a skeleton's `:pod()` method, which can be `store()`-ed. Clicking the `save` button in the gui does this automatically. To load a skeleton into the gui, ensure that `skeleton.pod` is present in `appdata/necrodancer/` and click the `load` button.  
To import a skeleton into a different project, first move the `skeleton.pod` file into the project directory. Then use the function in `skeleton/gravedig.lua` called `import()`. Pass `import()` the skeleton's pod and it will return a skeleton. Of course, the project must have the `skeleton` library. Renaming `skeleton.pod` to a more specialised name will help identify it.  


## necrodancer.lua

`necrodancer.lua` creates the gui. It creates object instances from the `gui` library and adds logic, stitching it all together.  


## gui, skeleton, and lib

These three libraries are required for necrodancer. If you want to export skeletons into your own project, the `skeleton` library is required, as well as as two files from `lib`: `vec.lua` and `tstr.lua`.  
For more documentation on the `gui` and `skeleton` libraries, see their repositories.  


### lib

Since `lib` does not have its own repository, here are some brief details.  
`vec.lua` is a class for a 2D vector. This library was created before I realised vectors were supported through userdata.  
`tstr.lua` gives some utility functions relating to tostrings. Particularly, the `tstr()` function returns the `:tostring()`'s string of a table or, if the table has not tostring, a string of the contents of the table. In short, `tstr()` returns a human-readable string for a table.  
`kmb.lua` is used to track user-inputs. While `kmb.lua` can handle both keyboard and mouse, only the mouse portion is used by necrodancer. It is used to detect things like mouse click events on buttons and sliders.  
`log.lua` it used to write data to files. This is separate from writing pods, rather it is used for...well, logging data.  
`queue.lua` is used to maintain a queue to contains strings used for debug readouts. If necrodancer is launched with the `debug_mode = true` parameter, queue is used to handle the messages on the rightmost container.  
`ttype.lua` allows for classes (tables with a metatable) to have custom types. If the variable has no `.__type` parameter, it acts identical to `type()`; otherwise, `ttype()` returns the table's `.__type` parameter.  
