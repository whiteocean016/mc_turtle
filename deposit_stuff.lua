--[[ Drop valuable stuff ]]--
-- Goes to specified chest and drops all but fuel items
-- If no chest location specified, goes to default chest (261, 68, 350)

local args = {...}

local x, y, z

if #args == 0 then
    v_chest = vector.new(261, 69, 350)
elseif #args == 3 then
    x = tonumber( args[1] )
    y = tonumber( args[2] )
    z = tonumber( args[3] )
    v_chest = vector.new(x, y, z)
else 
    error("Usage: deposit_stuff [x y z] \n")
end

shell.run("gps_go_to", v_chest.x, v_chest.y, v_chest.z)

-- drop stuff
for i = 1, 16 do
    turtle.select(i)
    turtle.dropDown()
end