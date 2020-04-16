--[[ Skripta za kopanje in filanje luknje ]]--

-- Skoplje luknjo velikosti a x a x n
-- in pobere ore ce so v stranskih stenah
-- potem se vrne na startno lokacijo
-- med tem ko proba zafilat luknjo z zemljo

-- V zadnji predal gre gorivo, v predzadnji
-- world anchor, da lahko dela v miru.

local args = {...}

local REFILL, RETURN

if #args == 2 then
  REFILL = true
  RETURN = true
elseif #args == 3 then
  REFILL = tonumber( args[3] )
  if REFILL == 0 then
    REFILL = false
  else
    REFILL = true
  end
  RETURN = true
elseif #args == 4 then
  REFILL = tonumber( args[3] )
  if REFILL == 0 then
    REFILL = false
  else
    REFILL = true
  end
  RETURN = tonumber( args[4] )
  if RETURN == 0 then
    RETURN = false
  else
    RETURN = true
  end
else
  error("Usage: miner width depth refill[0|1] return[0|1]\n")
end

print("refill = ", REFILL)
print("return = ", RETURN)

local n, a
a = tonumber( args[1] )   -- hole width
n = tonumber( args[2] )   -- hole depth

print("Running miner with arguments")
print("Width = ", a)
print("Depth = ", n)


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
      if turtle.detectUp() then
        go_up()
        check_ore()
        go_down()
      end
      fuel()
      turtle.back()
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
-----MAIN-----
--------------

-- Fuel check in advance
--TODO calculate available fuel (distance) from inventory
local fuelSlot  = findAndRefuel()
local currentFuelLevel = turtle.getFuelLevel()
local availableFuelLevel = currentFuelLevel + turtle.getItemCount(fuelSlot)*80
print("Fuel needed at least: ", a*a*n)
print("Recommened fuel:      ", (a+1)*(a+1)*(n+1))
print("Available fuel:          ", availableFuelLevel )

if availableFuelLevel < a*a*n then
  print("Fuel needed at least: ", a*a*n)
  error("Not enough fuel.")
end


local junk = find_junk()

function line(j, k, digg, refill)
  for i = 1, a do
    if digg then
      turtle.digDown()
    end
    if j == 1 then
      turtle.turnLeft()
      check_ore()
      turtle.turnRight()
    elseif j == a then
      if math.fmod(a,2) == 0 then
        turtle.turnLeft()
        check_ore()
        turtle.turnRight()
      else
        turtle.turnRight()
        check_ore()
        turtle.turnLeft()
      end
    end
    if refill and k > 2 then
      junk = find_junk()
      if junk then
        turtle.select(junk)
        turtle.placeUp()
      end
    end
    if i < a then
      go_forward()
    end
  end
end

function plane(k, digg, refill)
  for j = 1, a do
    line(j, k, digg, refill)
    check_ore()
    if j < a then
      if math.fmod(j, 2) == 0 then
        turtle.turnLeft()
        go_forward()
        turtle.turnLeft()
      else
        turtle.turnRight()
        go_forward()
        turtle.turnRight()
      end
    end
  end
end


for k = 1, n do
  plane(k, true, REFILL)
  turtle.turnRight()
  if math.fmod(a, 2) ~= 0 then
    turtle.turnRight()
  end
  turtle.down()
  print("Progress: ", math.floor(k*100.0/n + 0.5))
  if k == n then
    plane(k, false)
  end
end

if RETURN then
  for k = 1, n do
    go_up()
    if REFILL then
      junk = find_junk()
      if junk then
        turtle.select(junk)
        turtle.placeDown()
      end
    end
  end
end
