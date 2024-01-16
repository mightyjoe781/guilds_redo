-- api.lua
local storage = minetest.get_mod_storage()

-- Ensure that the 'guilds' key exists in mod storage
if not storage:get_string("guilds") then
    storage:set_string("guilds", minetest.serialize({}))
end

-- Function to get all guilds
function guilds.get_data(tname)
    return minetest.deserialize(storage:get_string(tname))
end

-- Function to save all guild data
function guilds.save_data(tname,table)
    return storage:set_string(tname, minetest.serialize(table))
end

-- Function to get all guild names
function guilds.get_all_guilds()
    local guilds_list = guilds.get_data("guilds") or {}
    local guild_names = {}

    for guild_name, _ in pairs(guilds_list) do
        table.insert(guild_names, guild_name)
    end

    return guild_names
end

-- create a specific guild by name
function guilds.create_guild(gname, members)
    -- create a new guild table
    guilds.save_data(gname, members)
    -- add to the guilds table
    local glist = guilds.get_data("guilds")
    glist[gname] = true
    guilds.save_data("guilds", glist)
end

-- get a guild by name
function guilds.get_guild(gname)
    -- check if a valid guild
    local glist = guilds.get_data("guilds")
    if not glist[gname] then
        return false
    end
    return guilds.get_data(gname)
end

-- Function to remove a guild by name
function guilds.remove_guild(gname)
    local glist = guilds.get_data("guilds")
    if not glist[gname] then
        return false
    end
    -- Remove the guild from the guilds list
    glist[gname] = nil
    -- Remove guild data
    storage:set_string(gname, "")
    -- Save the updated guilds list
    guilds.save_data("guilds", glist)
    return true
end

-- Function to update a guild
function guilds.update_guild(gname, newGuildData)
    local glist = guilds.get_data("guilds")
    if not glist[gname] then
        return false  -- Guild not found
    end
    -- Update the guild data
    guilds.save_data(gname, newGuildData)
    return true  -- Guild successfully updated
end

-- Function to add a member to a guild
function guilds.add_member(gname, member)
    local guildData = guilds.get_guild(gname)
    if not guildData then
        return false  -- Guild not found
    end
    table.insert(guildData, member)
    guilds.save_data(gname, guildData)
    return true  -- Member successfully added
end

-- Function to remove a member from a guild
function guilds.remove_member(gname, member)
    local guildData = guilds.get_guild(gname)
    if not guildData then
        return false  -- Guild not found
    end
    local index = table.indexof(guildData, member)
    if not index then
        return false  -- Member not found in the guild
    end
    table.remove(guildData, index)
    guilds.save_data(gname, guildData)

    -- Check if the guild is now empty, if so, delete the guild
    if #guildData == 0 then
        guilds.remove_guild(gname)
    end

    return true  -- Member successfully removed
end
