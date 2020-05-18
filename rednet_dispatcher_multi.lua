--[[ Rednet dispatcher ]]--
-- Opens rednet modem and sends commands to excavators

block_origin = vector.new(263, 67, 351)

hole_coords = {
    vector.new(0,0,0),
    vector.new(1,0,3),
    vector.new(2,0,1),
    vector.new(3,0,4),
    vector.new(4,0,2)
}

turtle_ids = {
    0,
    5,
    7,
    8,
    9
}

-- check last dugg-up block
local fd = fs.open("data_mining/last_block.dat", "r")
block_id = tonumber(fd.readAll()) + 1
fd.close()
fd = nil

-- convert block id to coordinates via pairing function
function unpair(z)
    a = math.floor( math.sqrt(z) )
    if z - math.pow(a,2) < a then
        return vector.new(z - math.pow(a,2), 0, a)
    else
        return vector.new(a, 0, z - math.pow(a,2) - a)
    end
end

block_coord = unpair(block_id)
block_current = block_origin + block_coord * 5

rednet.open("right")

turtles_done = 0
for i=1,5 do
    vector_exc = block_current + hole_coords[i]
    print("Exacavating: ", vector_exc)
    command = "digg_process " .. vector_exc.x .. " " .. vector_exc.y .. " " .. vector_exc.z
    
    rednet.send(turtle_ids[i], command)
end

-- wait for reply
while turtles_done ~= 5 do
    senderID, message, distance = rednet.receive(1)
    if message == "done" then
        task_done = task_done + 1
    end
end

rednet.close("right")
print("Block done")

-- save id of block
local fd = fs.open("data_mining/last_block.dat", "w")
fd.write(block_id)
fd.close()
fd = nil
