--[[ Digg process ]]--
-- Goes to specific location
-- excavates vertically
-- goes to chest and deposits stuff

local args = {...}

local x, y, z

if #args == 3 then
    x = tonumber( args[1] )
    y = tonumber( args[2] )
    z = tonumber( args[3] )
    v_digg = vector.new(x, y, z)
else 
    error("Usage: digg_process x y z \n")
end

shell.run("gps_go_to", v_digg.x, v_digg.y, v_digg.z)
shell.run("v_exc")
shell.run("deposit_stuff")