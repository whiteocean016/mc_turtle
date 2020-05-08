--[[ Rednet listener ]]--
-- Opens rednet modem and listens to incoming messages.
-- Executes any message in a shell
-- source: https://gaming.stackexchange.com/questions/247948/how-to-make-a-turtle-run-a-program-over-the-modem-api-in-computercraft

rednet.open("right")
while true do
    senderID, message, distance = rednet.receive()
    print("Executing message: " .. message)
    if message == "exit" then
        break
    end
    shell.run(message)
end
rednet.close("right")
