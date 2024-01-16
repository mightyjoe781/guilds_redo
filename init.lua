local MP = minetest.get_modpath("guilds_redo")
-- global variable for storing mod data
guilds = {}

dofile(MP.."/api.lua")
dofile(MP.."/chatcmd.lua")
dofile(MP.."/privs.lua")

-- Registering on chat message callback
minetest.register_on_chat_message(function(name, message)
    local player = minetest.get_player_by_name(name)
    if not player then
        return
    end
    local meta = player:get_meta()
    local current_guild = meta:get_string("guild")

    -- If the player is in a guild, modify the chat message
    if current_guild then
        local guild_data = guilds.get_guild(current_guild)

        -- Ensure the guild data exists before accessing it
        if guild_data then
            local guild_prefix = "[ " .. current_guild .. " ]"
            guild_prefix = minetest.colorize(guild_data.color, guild_prefix)
            minetest.chat_send_all(guild_prefix .. " <" .. name .. "> " .. message)
            return true
        else
            -- If guild data is nil, clear the player's attribute
            meta:set_string("guild", "")
        end
    end

    -- If the player is not in a guild, send the chat message as usual
    return false
end)
