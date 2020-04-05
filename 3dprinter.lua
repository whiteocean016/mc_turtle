--[[ 3D printer math ]]--

-- Scrtipt for 3D printing of
-- mathematical functions, such
-- as spheres.

local args = {...}

local R, d

if #args == 2 then
  R = tonumber(args[1])
  d = tonumber(args[2])
else
  error("Usage: 3dprint radius width\n")
end

print("Running ", args[0], " with arguments")
print("radius = ", R)
print("width  = ", d)


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

-- Premikanje naprej/nazaj
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


-- Premikanje desno/levo (TURN)
function go_right()
  turtle.turnRight()
  go_forward()
end

function go_left()
  turtle.turnLeft()
  go_forward()
end

-- Premikanje desno/levo (STRAFE)
function strf_right()
  go_right()
  turtle.turnLeft()
end

function strf_left()
  go_left()
  turtle.turnRight()
end


-- Iskanje rude
function check_ore()
  local succ, data = turtle.inspect()
  if succ then
    local str = data.name
    str = string.lower(str)
    local index = string.find(str, "ore")
    if index ~= nill then
      print("Found ", data.name)
      turtle.dig()
      fuel()
      turtle.forward()
      turtle.turnLeft()
      check_ore()         -- preveri na levi
      turtle.turnRight()
      check_ore()         -- preveri pred sabo
      turtle.turnRight()
      check_ore()         -- preveri na desni
      turtle.turnLeft()
      if turtle.detectDown() then
        go_down()
        check_ore()
        go_up()
      end
      fuel()
      turtle.back()
    end
  end
end

-- Define junk from slot 1
local data = turtle.getItemDetail(1)
local junk_name = data.name

function find_junk()
  local data
  for i = 1, 16 do
    data = turtle.getItemDetail(i)
    if data and data.name == junk_name then
      return i
    end
  end
  return false
end


--------------
-----MAIN-----
--------------

-- Fuel check in advance
--TODO calculate available fuel (distance) from inventory
local fuelSlot  = findAndRefuel()
local currentFuelLevel = turtle.getFuelLevel()
local availableFuelLevel = currentFuelLevel + turtle.getItemCount(fuelSlot)*80
print("Fuel needed at least: ", R*R*R)
print("Recommened fuel:      ", (R+1)*(R+1)*(R+1))
print("Available fuel:       ", availableFuelLevel )

if availableFuelLevel < R*R*R then
  print("Fuel needed at least: ", R*R*R)
  error("Not enough fuel.")
end

local junk = find_junk()

go_up()

local x, y, z, x0, y0, z0
x = 0
y = 0
z = 0
x0 = R
y0 = R
z0 = R

function line(j)
  for i = 0, 2*R do
    if (R-d)^2 <= (x-x0)^2 + (y-y0)^2 + (z-z0)^2 and (x-x0)^2 + (y-y0)^2 + (z-z0)^2 <= (R+d)^2 then
      junk = find_junk()
      if junk then
        turtle.select(junk)
        if not turtle.compareDown() then
          turtle.digDown()
          turtle.placeDown()
        end
      end
    else
      turtle.digDown()
    end
    if i < 2*R then
      go_forward()
      if math.fmod(x, 2) == 0 then
        y = y + 1
      else
        y = y - 1
      end
    end
  end
end

function plane()
  for j = 0, 2*R do
    line(j)
    if j < 2*R then
      if math.fmod(j, 2) == 0 then
        turtle.turnRight()
        go_forward()
        turtle.turnRight()
      else
        turtle.turnLeft()
        go_forward()
        turtle.turnLeft()
      end
      x = x + 1
    elseif math.fmod(2*R, 2) ~= 0 then
      print("Going back EVEN")
      turtle.turnRight()
      for step = 1, 2*R do
        go_forward()
      end
      turtle.turnRight()
      print("Im back")
    else
      print("Going back ODD")
      turtle.turnLeft()
      for step = 1, 2*R do
        go_forward()
      end
      turtle.turnLeft()
      for step = 1, 2*R do
        go_forward()
      end
      turtle.turnRight()
      turtle.turnRight()
      print("Im back")
    end
  end
  x = 0
  y = 0
end


for k = 0, 2*R do
  plane()
  go_up()
  z = z + 1
  print("Progress: ", math.floor(k*100.0/(2*R) + 0.5))
end

go_back()
for k = 0, 2*R do
  fuel()
  turtle.down()
end