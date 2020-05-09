--[[ Rednet dispatcher ]]--
-- Opens rednet modem and sends commands to excavators

block_coords = {
    vector.new(0,0,0),
    vector.new(1,0,3),
    vector.new(2,0,1),
    vector.new(3,0,4),
    vector.new(4,0,2)
}

block_0 = vector.new(263, 67, 351)

rednet.open("right")
for i=1,5 do
    task_done = false
    vector_exc = block_0 + block_coords[i]
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
