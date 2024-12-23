-- Core API functions implemented in Lua
dofile('data/lib/core/core.lua')

-- Compatibility library for our old Lua API
dofile('data/lib/compat/compat.lua')
dofile('data/lib/compat/korelin.lua')

-- Debugging helper function for Lua developers
dofile('data/lib/debugging/dump.lua')
dofile('data/lib/debugging/lua_version.lua')

-- Equipment Storage
Storage = {
    Equipment = {
        HealthBonus = 20001,
        EquipStatus = 30001  -- Nova storage para status do equip
    }
}
