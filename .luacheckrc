unused_args = false
allow_defined_top = true
exclude_files = {".luacheckrc"}

globals = {
	"minetest",
	"prismo",
	"default",
	"censor",
	"ranks"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn", "indexof"}},

    -- Builtin
    "vector", "ItemStack",
    "dump", "DIR_DELIM", "VoxelArea", "Settings",
	"screwdriver",

    -- MTG
    "default", "sfinv", "creative", "carts","sethome",

    --depends
    "bonemeal","pipeworks","unified_inventory","irc",
    --for fly manipulation
    "player_monoids",

	-- mod deps
	"technic_cnc", "technic",
	"loot", "mesecon", "skybox",
	"xp_redo", "letters", "toolranks"
}