local MP = minetest.get_modpath("guilds_redo")

guilds = {
    -- default_color for the new guilds
    default_color = minetest.settings:get("guilds.default_color") or "#57F287",
    color_palette = {
        "#1f78b4", "#33a02c", "#e31a1c", "#ff7f00",
        "#6a3d9a", "#a6cee3", "#b2df8a", "#fb9a99",
        "#fdbf6f", "#cab2d6", "#ffff99", "#b15928"
    },
    -- xp costs for the mod
	join_xp = tonumber(minetest.settings:get("guilds.join_xp") or 50000),
	create_xp = tonumber(minetest.settings:get("guilds.create_xp") or 200000),
}


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
    local prefixed_msg = " <" .. name .. "> " .. message

    -- If the player is in a guild, modify the chat message
    if current_guild then
        local guild_data = guilds.get_guild(current_guild)

        -- Ensure the guild data exists before accessing it
        if guild_data then
            local guild_prefix = " {" .. current_guild .. "}"
            guild_prefix = minetest.colorize(guild_data.color, guild_prefix)
            prefixed_msg = guild_prefix .. prefixed_msg
        else
            -- If guild data is nil, clear the player's attribute
            meta:set_string("guild", "")
        end
    end
    if minetest.get_modpath("ranks") then
        -- disable the chat modifier in ranks mod
        -- ranks.prefix_chat = false
        local rank = ranks.get_rank(name)
        if rank ~= nil then
            local def = ranks.get_def(rank)
            if def and def.prefix then
                local colour = guilds.fix_color(def.colour)
                local rank_prefix = minetest.colorize(colour, def.prefix)
                prefixed_msg =rank_prefix .. prefixed_msg
            end
        end
    end
    if minetest.get_modpath("censor") then
        prefixed_msg = censor.corrected_message(name,prefixed_msg)
        -- if player kicked then no need to broadcast their message
        -- censor mod design bug + mention highlight is not working
        -- i should really redesign that mod :) as an api
        -- this is not working :) maybe make it a hook who knows lol
        if censor.kick(name) then
            minetest.log("action", "CHAT: ".."<"..name.."> "..message)
            return true
        end
    end
    minetest.chat_send_all(prefixed_msg)
    minetest.log("action", "CHAT: ".."<"..name.."> "..message)

    -- If the player is not in a guild, send the chat message as usual
    return true
end)