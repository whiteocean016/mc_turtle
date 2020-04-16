--[[ Block checker ]]--

-- Checks and prints block details for
-- front, up and down blocks


local success, data = turtle.inspect()

print("Block infront:")
if success then
    print(textutils.serialize(data))
else
    print("fail")
end


-- check down
local success, data = turtle.inspectDown()

print("Block down:")
if success then
    print(textutils.serialize(data))
else
    print("fail")
end


-- check up
local success, data = turtle.inspectUp()

print("Block up:")
if success then
    print(textutils.serialize(data))
else
    print("fail")
end
