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
        for _, member in ipairs(guild_data) do
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

        local guild_name = param:trim()
        local meta = player:get_meta()
        local current_guild = meta:get_string("guild")
        if current_guild and current_guild ~= guild_name then
            return false, "You are already a member of a guild. Leave your current guild first."
        end

        local guild_data = guilds.get_guild(guild_name)

        if guild_data then
            return false, "Guild name already exists"
        end

        -- Check if the player has enough xp or guild_priv
        -- local xp_required = 1000 -- Set the required xp amount or adjust as needed
        -- local player_xp = meta:get_int("xp")

        -- if player_xp and player_xp < xp_required and not minetest.check_player_privs(name, {guild_priv = true}) then
        --     return false, "Insufficient xp or missing guild_priv to create a guild"
        -- end

        -- Deduct xp if guild_priv is not present
        -- if player_xp and not minetest.check_player_privs(name, {guild_priv = true}) then
        --     player:set_int("xp", player_xp - xp_required)
        -- end

        -- Create the guild
        guilds.create_guild(guild_name, {name})

        -- Update player's attributes
        meta:set_string("guild", guild_name)

        return true, "You have successfully created the guild: " .. guild_name
    end,
})
