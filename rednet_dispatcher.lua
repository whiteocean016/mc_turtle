--[[ Rednet dispatcher ]]--
-- Opens rednet modem and sends commands to excavators

rednet.open("right")
while true do
    local message = "test"
    print("Sending message: " .. message)
    rednet.broadcast(message)
end
rednet.close("right")
