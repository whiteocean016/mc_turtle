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

-- check blocks TODO
blocks_todo = {}
for line in io.lines("data_mining/todo.dat") do
    blocks_todo[#blocks_todo + 1] = line
end

blocks_done = {}
for line in io.lines("data_mining/done.dat") do
    blocks_done[#blocks_done + 1] = line
end

-- if all done, add new block
if #blocks_todo == 0 then
    

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
block_current = block_origin + 5 * block_coord

rednet.open("right")
for i=1,5 do
    task_done = false
    vector_exc = block_current + hole_coords[i]
    print("Exacavating: ", vector_exc)
    command = "digg_process " .. vector_exc.x .. " " .. vector_exc.y .. " " .. vector_exc.z
    rednet.broadcast(command)
    
    -- wait for reply
    while not task_done do
        senderID, message, distance = rednet.receive(1)
        if message == "done" then
            task_done = true
        end
    end
end
rednet.close("right")
print("Block done")
