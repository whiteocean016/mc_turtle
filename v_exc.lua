--[[ Excavate vertical hole script ]]--

-- Digs straight down till it reaches bedrock
-- or gets to depth h (if specified).
-- On the way collects valuable ores from its 4
-- neighbuoring blocks (does not follow veins).


local args = {...}

local REFILL, DEPTH

if #args == 1 then
    REFILL = tonumber( args[1] )
    DEPTH = 9999
elseif #args == 2 then
        REFILL = tonumber( args[1] )
        DEPTH = tonumber( args[2] )
else
    error("Usage: v_exc refill[0|1] [depth] \n")
end

print("Running miner with arguments")
print("Depth    = ", DEPTH)
print("Refill = ", REFILL)

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

-- Destructive movement forward/backward/up/...
function go_forward()
    fuel()
    if not turtle.forward() then
        turtle.dig()
        --sleep(1)
        turtle.forward()
    end
end

function go_back()
    fuel()
    if not turtle.back() then
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.dig()
        turtle.forward()
        turtle.turnLeft()
        turtle.turnLeft()
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


-- Destructive move left/right (TURN)
function go_right()
    turtle.turnRight()
    go_forward()
end

function go_left()
    turtle.turnLeft()
    go_forward()
end

-- Destructive move left/right (STRAFE)
function strf_right()
    go_right()
    turtle.turnLeft()
end

function strf_left()
    go_left()
    turtle.turnRight()
end


-- Check if valuable ore
function check_ore()
    local succ, data = turtle.inspect()
    if succ then
        local str = string.lower(data.name)
        --TODO better way of determining valuable blocks
        local idx_ore = string.find(str, "ore")
        local idx_ic2 = string.find(str, "ic2") -- industrial craft 2 blocks
        if idx_ore ~= nill or idx_ic2 ~= nill then
            print("Found ", data.name)
            return true
        else
            return false
        end
    end
end

function find_junk()
    local data
    for i = 1, 16 do
        data = turtle.getItemDetail(i)
        if data then
            local str = data.name
            str = string.lower(str)
            --TODO add other junk material (gravel, ?)
            local stone = string.find(str, "stone")
            local dirt = string.find(str, "dirt")
            local andesite = string.find(str, "andesite")
            if stone ~= nill or dirt ~= nill or andesite ~= nill then
                return i
            end
        end
    end
    return false
end



--------------
----PREREQ----
--------------

local expected_depth
if DEPTH ~= 9999 then
    expected_depth = 30
else
    expected_depth = DEPTH
end

-- Fuel check in advance
--TODO calculate available fuel (distance) from inventory
local fuelSlot    = findAndRefuel()
local currentFuelLevel = turtle.getFuelLevel()
local availableFuelLevel = currentFuelLevel + turtle.getItemCount(fuelSlot)*80
print("Fuel needed at least: ", (expected_depth)*2 )
print("Recommened fuel:      ", (expected_depth+2)*2 )
print("Available fuel:       ", availableFuelLevel )

if availableFuelLevel < (expected_depth)*2 then
    print("Fuel needed at least: ", (expected_depth)*2)
    error("Not enough fuel.")
end


--------------
-----MAIN-----
--------------

for h = 1, DEPTH do
    -- check bedrock
    local succ, data = turtle.inspectDown()
    if succ then
        local name_block = string.lower(data.name)
        if string.find(name_block, "bedrock") then
            break
        end
    end

    -- check fuel
    -- check full inventory

    go_down()
    for d = 1, 4 do
        local valuable = check_ore()
        if valuable then
            turtle.dig()
        end
        turtle.turnLeft()
    end
end

-- if return
for d = 1, h do
    go_up()
end

