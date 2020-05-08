--[[ Update scripts ]]--
-- Removes scripts and pulls latest from git
-- Also updates itself

shell.run("rm", "*.lua")

shell.run("wget", "https://raw.githubusercontent.com/whiteocean016/mc_turtle/master/v_exc.lua")
shell.run("wget", "https://raw.githubusercontent.com/whiteocean016/mc_turtle/master/gps_go_to.lua")
shell.run("wget", "https://raw.githubusercontent.com/whiteocean016/mc_turtle/master/rednet_listen.lua")
shell.run("wget", "https://raw.githubusercontent.com/whiteocean016/mc_turtle/master/update.lua")

