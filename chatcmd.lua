-- Chat command to join a guild
minetest.register_chatcommand("join_guild", {
    params = "<guild_name>",
    description = "Join a guild",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Player not found"
        end
        local guild_name = param:trim()

        local meta = player:get_meta()
        local current_guild = meta:get_string("guild")
        if current_guild and current_guild ~= "" then
            return false, "You are already a member of a guild. Leave your current guild first."
        end

        local guild_data = guilds.get_guild(guild_name)

        if not guild_data then
            return false, "Guild not found"
        end

        if minetest.get_modpath("xp_redo") then
            local xp_required = 50000
            local player_xp = xp_redo.get_xp(name)
            if player_xp < xp_required then
                return false, "You don't have enough xp to join guilds. Required xp: "..(xp_required - player_xp)
            else
                -- Deduct xp
                xp_redo.add_xp(name, -xp_required)
            end
        end

        -- Update player's attributes
        meta:set_string("guild", guild_name)

        -- Add the player to the guild
        guilds.add_member(guild_name, name)

        return true, "You have successfully joined the guild: " .. guild_name
    end,
})

-- Chat command to leave a guild
minetest.register_chatcommand("leave_guild", {
    params = "",
    description = "Leave your current guild",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Player not found"
        end

        local meta = player:get_meta()
        local current_guild = meta:get_string("guild")
        if not current_guild or current_guild == "" then
            return false, "You are not a member of any guild"
        end

        -- Remove the player from the guild
        guilds.remove_member(current_guild, name)

        -- Update player's attributes
        meta:set_string("guild", "")

        return true, "You have left the guild: " .. current_guild
    end,
})

-- Chat command to send a message to all guild members
minetest.register_chatcommand("gm", {
    params = "<message>",
    description = "Send a message to all guild members",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Player not found"
        end

        local meta = player:get_meta()
        local current_guild = meta:get_string("guild")
        if not current_guild then
            return false, "You are not a member of any guild"
        end

        local guild_data = guilds.get_guild(current_guild)
        if not guild_data then
            return false, "Guild not found"
        end

        local online_members = {}
        for _, member in ipairs(guild_data.members) do
            local member_player = minetest.get_player_by_name(member)
            if member_player then
                table.insert(online_members, member)
                minetest.chat_send_player(member, "[Guild] " .. name .. ": " .. param)
            end
        end

        if #online_members == 0 then
            return false, "No online guild members to message"
        end

        return true, "Message sent to guild members: " .. table.concat(online_members, ", ")
    end,
})

-- Chat command to create a guild
minetest.register_chatcommand("create_guild", {
    params = "<guild_name>",
    description = "Create a guild",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Player not found"
        end

        local guild_name, color = param:match("(%S+)%s*(%S*)")
        color = color ~= "" and color or nil

        local meta = player:get_meta()
        local current_guild = meta:get_string("guild")
        if current_guild and current_guild ~= "" then
            return false, "You are already a member of a guild. Leave your current guild first."
        end

        local guild_data = guilds.get_guild(guild_name)

        if guild_data then
            return false, "Guild name already exists"
        end

        -- Check if a valid color is passed
        if color and not color:match("^#%x%x%x%x%x%x$") then
            return false, "Invalid color format. Please use a valid hexadecimal color (e.g., #57F287)"
        end


        if minetest.get_modpath("xp_redo") then
            -- Check if the player has enough xp or guild_priv
            local xp_required = 200000 -- Set the required xp amount or adjust as needed
            local player_xp = xp_redo.get_xp(name)
            if player_xp < xp_required then
                return false, "You don't have enough xp to join guilds. Required xp: "..(xp_required - player_xp)
            else
                -- Deduct xp
                xp_redo.add_xp(name, -xp_required)
            end
        end

        -- Create the guild
        guilds.create_guild(guild_name, name, color)

        -- Update player's attributes
        meta:set_string("guild", guild_name)

        return true, "You have successfully created the guild: " .. guild_name
    end,
})


-- Chat command to get all guild names
minetest.register_chatcommand("list_guilds", {
    params = "",
    description = "List all guilds",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Player not found"
        end

        local all_guilds = guilds.get_all_guilds()

        if #all_guilds == 0 then
            return false, "No guilds found"
        end

        local guild_list_str = "Guilds: " .. table.concat(all_guilds, ", ")
        return true, guild_list_str
    end,
})

-- Chat command to get information about a specific guild
minetest.register_chatcommand("guild_info", {
    params = "<guild_name>",
    description = "Get information about a guild",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Player not found"
        end

        local guild_name = param:trim()
        local guild_data = guilds.get_guild(guild_name)

        if not guild_data then
            return false, "Guild not found"
        end

        local member_list = table.concat(guild_data.members, ", ")

        return true, "Guild Name: " .. guild_name .. "\nMembers: " .. (member_list ~= "" and member_list or "None").. "\nColor: "..guild_data.color
    end,
})
-- Chat command to remove a guild
minetest.register_chatcommand("remove_guild", {
    params = "<guild_name>",
    description = "Remove a guild",
    func = function(name, param)
        local guild_name = param:trim()

        -- Check if the player has the necessary privilege or is the guild owner
        if not minetest.check_player_privs(name, {guild_priv = true}) then
            return false, "You don't have the privilege to remove this guild"
        end

        -- Remove the guild
        if guilds.remove_guild(guild_name) then
            return true, "Guild '" .. guild_name .. "' has been removed"
        else
            return false, "Failed to remove the guild"
        end
    end,
})

