//
//  color.cpp
//  Lca
//
//  Created by lca pro on 06/01/2016.
//  Copyright © 2016 lca. All rights reserved.
//

#include "color.hpp"

#define COLOR "luaL_color"

int l_color_push(lua_State *L, lua_Number r, lua_Number g, lua_Number b, lua_Number a) {
    lua_Number *pv = (lua_Number *)lua_newuserdata(L, sizeof(lua_Number)*4);
    pv[0] = r;
    pv[1] = g;
    pv[2] = b;
    pv[3] = a;

    luaL_getmetatable(L, COLOR);
    lua_setmetatable(L, -2);

    return 1;
}

int l_color_push(lua_State *L, lua_Number *v) {
    return l_color_push(L, v[0], v[1], v[2], v[3]);
}

int l_color_param(lua_State *L, lua_Number &r, lua_Number &g, lua_Number &b, lua_Number &a) {
    int narg = lua_gettop(L);
    if (narg == 0) {
        r = g = b = 0;
        a = 255;
    } else if (narg == 1) {
        if (lua_isuserdata(L, 1)) {
            lua_Number *pv = l_color_check(L, 1);
            r = pv[0];
            g = pv[1];
            b = pv[2];
            a = pv[3];
        } else {
            r = g = b = lua_check(1, float, number);
            a = 255;
        }
    } else if (narg == 2) {
        r = g = b = lua_check(1, float, number);
        a = lua_check(2, float, number);
    } else {
        r = lua_check(1, float, number);
        g = lua_check(2, float, number);
        b = lua_check(3, float, number);
        a = lua_option(4, float, number, 255);
    }
    return 0;
}

int l_color_create(lua_State *L) {
    lua_Number r, g, b, a;
    l_color_param(L, r, g, b, a);
    return l_color_push(L, r, g, b, a);
}

int l_color_gc(lua_State *L) {
    //delete *l_color_check(L, 1);
    return 0;
}

lua_Number *l_color_check(lua_State *L, int n) {
    return (lua_Number *)luaL_checkudata(L, n, COLOR);
}

int l_color_tostring(lua_State *L) {
    lua_Number *v = l_color_check(L, 1);

    char str[64];
    sprintf(str, "r=%d, g=%d, b=%d, a=%d", (int)v[0], (int)v[1], (int)v[2], (int)v[3]);
    lua_pushstring(L, str);
    return 1;
}

int l_color_length(lua_State *L) {
    lua_pushunsigned(L, 0);
    return 1;
}

int l_color_get(lua_State *L) {
    lua_Number *v = l_color_check(L, 1);

    const char *name = luaL_checkstring(L, 2);
    char var = 0;
    if (name[1] == 0) {
        var = *name;
    }

    switch (var) {
        case '1':
        case 'r':
            lua_pushnumber(L, v[0]);
            break;
        case '2':
        case 'g':
            lua_pushnumber(L, v[1]);
            break;
        case '3':
        case 'b':
            lua_pushnumber(L, v[2]);
            break;
        case '4':
        case 'a':
            lua_pushnumber(L, v[3]);
            break;
        default:
            lua_getuservalue(L, 1);
            break;
    }
    return 1;
}

int l_color_set(lua_State *L) {
    lua_Number *v = l_color_check(L, 1);

    const char *name = luaL_checkstring(L, 2);
    char var = 0;
    if (name[1] == 0) {
        var = *name;
    }

    switch (var) {
        case '1':
        case 'r':
            v[0] = luaL_checknumber(L,3);
            break;
        case '2':
        case 'g':
            v[1] = luaL_checknumber(L,3);
            break;
        case '3':
        case 'b':
            v[2] = luaL_checknumber(L,3);
            break;
        case '4':
        case 'a':
            v[3] = luaL_checknumber(L,3);
            break;
        default:
            lua_pushvalue(L, 3);
            lua_setuservalue(L, 1);
            break;
    }
    return 1;
}

void color_add(lua_Number *v1, lua_Number *v2, lua_Number *v) {
    v[0] = v1[0] + v2[0];
    v[1] = v1[1] + v2[1];
    v[2] = v1[2] + v2[2];
    v[3] = v1[3] + v2[3];
}

void color_sub(lua_Number *v1, lua_Number *v2, lua_Number *v) {
    v[0] = v1[0] - v2[0];
    v[1] = v1[1] - v2[1];
    v[2] = v1[2] - v2[2];
    v[3] = v1[3] - v2[3];
}

void color_mul(lua_Number *v1, lua_Number coef, lua_Number *v) {
    v[0] = v1[0] * coef;
    v[1] = v1[1] * coef;
    v[2] = v1[2] * coef;
    v[3] = v1[3] * coef;
}

void color_div(lua_Number *v1, lua_Number coef, lua_Number *v) {
    if (coef != 0) {
        color_mul(v1, 1.0 / coef, v);
    }
}

int l_color_add(lua_State *L) {
    lua_Number *v1 = l_color_check(L, 1);
    lua_Number *v2 = l_color_check(L, 2);

    lua_Number v[4] = {0,0,0,0};
    color_add(v1, v2, v);

    return l_color_push(L, v);
}

int l_color_sub(lua_State *L) {
    lua_Number *v1 = l_color_check(L, 1);
    lua_Number *v2 = l_color_check(L, 2);

    lua_Number v[4] = {0,0,0,0};
    color_sub(v1, v2, v);

    return l_color_push(L, v);
}

int l_color_mul(lua_State *L) {
    lua_Number *v1;
    lua_Number coef;
    if (lua_isuserdata(L, 1) == 1) {
        v1 = l_color_check(L, 1);
        coef = luaL_checknumber(L, 2);
    } else {
        coef = luaL_checknumber(L, 1);
        v1 = l_color_check(L, 2);
    }

    lua_Number v[4] = {0,0,0,0};
    color_mul(v1, coef, v);

    return l_color_push(L, v);
}

int l_color_div(lua_State *L) {
    lua_Number *v1 = l_color_check(L, 1);
    lua_Number coef = luaL_checknumber(L, 2);

    lua_Number v[4] = {0,0,0,0};
    color_div(v1, coef, v);

    return l_color_push(L, v);
}

int l_color_eq(lua_State *L) {
    lua_Number *v1 = l_color_check(L, 1);
    lua_Number *v2 = l_color_check(L, 2);

    if (v1[0] == v2[0] &&
        v1[1] == v2[1] &&
        v1[2] == v2[2] &&
        v1[3] == v2[3]) {
        lua_pushboolean(L, 1);
    } else {
        lua_pushboolean(L, 0);
    }
    return 1;
}

luaL_Reg colorFunctions[] = {
    { "__call", l_color_create },
    //  { "__gc", l_color_gc },

    { "__tostring", l_color_tostring },

    { "__index", l_color_get },
    { "__newindex", l_color_set },

    { "__len", l_color_length },
    { "__add", l_color_add },
    { "__sub", l_color_sub },
    { "__mul", l_color_mul },
    { "__div", l_color_div },
    { "__eq", l_color_eq },

    { NULL, NULL }
};

void register_color(lua_State *L, const char *name) {
    luaL_newmetatable(L, COLOR);
    luaL_setfuncs(L, colorFunctions, 0);
    /*    lua_newtable(L);


     lua_pushstring(L, "color");
     lua_setfield(L, -2, "className");

     lua_setmetatable(L, -2);

     lua_setglobal(L, name);
     */
    
    lua_pushcfunction(L, l_color_create);
    lua_setglobal(L, "color");
}