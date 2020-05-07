--[[ Update scripts ]]--
-- Removes script and pulls latest from git


shell.run("rm", "v_exec.lua")
shell.run("wget", "https://raw.githubusercontent.com/whiteocean016/mc_turtle/master/v_exc.lua")
