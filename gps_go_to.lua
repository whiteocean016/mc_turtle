--[[ Go to GPS location ]]--
-- Goes to specific gps location provided by x, y, z arguments

--- INPUT ---
local args = {...}

local x, y, z

if #args == 3 then
    x = tonumber( args[1] )
    y = tonumber( args[2] )
    z = tonumber( args[3] )
    local v_dst = vector.new(x, y, z)
else 
    error("Usage: gps_go_to x y z \n")
end

print("Going to coordinates: " .. x .. ", " .. y .. ", " .. z)

-- locate turtle
local x_0, y_0, z_0 = gps.locate(5)
if not x_0 then --If gps.locate didn't work, it won't return anything. So check to see if it did.
    error("Failed to get my location!")
else
    print("I am at (" .. x_0 .. ", " .. y_0 .. ", " .. z_0 .. ")")
    local v_src = vector.new(x_0, y_0, z_0)
end

local v_disp = v_dst - v_src
--TODO fuel check here (L1 distance)


--- FUNCTIONS ---

--TODO find any kind of fuel and only return slot number
function findAndRefuel()
    for i = 1, 16 do
        turtle.select(i)
        if turtle.refuel(1) then
            return i
        end
    end
    return false
end

-- Fuel
function fuel()
    if turtle.getFuelLevel() < 1 then
        findAndRefuel()
    end
end

-- Non-destructive movement forward/backward/up/...
function go_forward()
    fuel()
    local has_waited = false
    while not turtle.forward() do
        local success, data = turtle.inspect()
        if success and string.find(data.name, "turtle") and not has_waited then
            -- wait time based on computerID (lower waits less has higher priority)
            sleep(os.computerID() / 10)
            has_waited = true
        else
            go_up()
        end
    end
end

function go_up()
    fuel()
    if not turtle.up() then
        turtle.digUp()
        turtle.up()
    end
end

function go_down()
    fuel()
    if not turtle.down() then
        turtle.digDown()
        turtle.down()
    end
end


--- MAIN ---

-- go to x
d_x = v_disp.x
if d_x > 0 then
    for i=1,d_x do
        go_forward()
    end
elseif d_x < 0 then
    turtle.turnLeft()
    turtle.turnLeft()
    for i=1, -1*d_x do
        go_forward()
    end
    turtle.turnLeft()
    turtle.turnLeft()
else
    print("At x: " .. x)
end

-- go to z
turtle.turnRight()
d_z = v_disp.z
if d_z > 0 then
    for i=1,d_z do
        go_forward()
    end
elseif d_z < 0 then
    turtle.turnLeft()
    turtle.turnLeft()
    for i=1, -1*d_z do
        go_forward()
    end
    turtle.turnLeft()
    turtle.turnLeft()
else
    print("At z: " .. z)
end
turtle.turnLeft()

-- kind of ignore y; find floor under (x,z)
--TODO keep track of y
