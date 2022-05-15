//
//  lua.cpp
//  Lca
//
//  Created by lca pro on 22/12/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#include "tools.hpp"

int narg(lua_State *L) {
    return lua_gettop(L);
}

bool luaL_checkboolean(lua_State *L, int narg) {
    if ( lua_isboolean(L, narg) ) {
        return lua_toboolean(L, narg);
    }
    return false;
}

lua_Number getNumber(lua_State *L, const char *name) {
    lua_getglobal(L, name);
    int number = lua_tonumber(L, -1);
    lua_pop(L, 1);
    return number;
}

int setGlobal(lua_State *L, const char *name, lua_Number number) {
    lua_pushnumber(L, number);
    lua_setglobal(L, name);
    return 0;
}

void register_lib(lua_State *L, const luaL_Reg *funcs, const CommonEnum *enums) {
    if (funcs) {
        for (const luaL_Reg *reg = funcs; reg->name ; ++reg) {
            lua_pushcfunction(L, reg->func);
            lua_setglobal(L, reg->name);
        }
    }

    if (enums) {
        for (const CommonEnum *reg = enums; reg->name ; ++reg) {
            lua_pushunsigned(L, reg->value);
            lua_setglobal(L, reg->name);
        }
    }
}