--[[ Update scripts ]]--
-- Removes scripts and pulls latest from git
-- Also updates itself


shell.run("rm", "v_exec.lua")
shell.run("rm", "update.lua")

shell.run("wget", "https://raw.githubusercontent.com/whiteocean016/mc_turtle/master/v_exc.lua")
shell.run("wget", "https://raw.githubusercontent.com/whiteocean016/mc_turtle/master/update.lua")

