//
//  vector.cpp
//  Lca
//
//  Created by lca pro on 22/12/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#include "vector.hpp"

#define VECTOR "luaL_vector"

Float *vector_new(lua_State *L) {
    Float *pv = (Float*)lua_newuserdata(L, sizeof(Float)*4);

    luaL_getmetatable(L, VECTOR);
    lua_setmetatable(L, -2);

    return pv;
}

int l_vector_push(lua_State *L, Float x, Float y, Float z, Float w) {
    Float *pv = vector_new(L);
    pv[0] = x;
    pv[1] = y;
    pv[2] = z;
    pv[3] = w;

    return 1;
}

int l_vector_push(lua_State *L, Float *v) {
    return l_vector_push(L, v[0], v[1], v[2], v[3]);
}

int l_vector_new(lua_State *L) {
    Float x=0., y=0., z=0., w=0.;

    int n = narg(L);
    if (n == 2) {
        if (lua_isuserdata(L, 2)) {
            Float *pv = l_vector_check(L, 2);
            x = pv[0];
            y = pv[1];
            z = pv[2];
            w = pv[3];
        }
    } else {
        x = lua_option(2, Float, number, 0.0);
        y = lua_option(3, Float, number, 0.0);
        z = lua_option(4, Float, number, 0.0);
        w = lua_option(5, Float, number, 0.0);
    }

    return l_vector_push(L, x, y, z, w);
}

Float *l_vector_check(lua_State *L, int n) {
    return (Float *)luaL_checkudata(L, n, VECTOR);
}

Float *l_vector_test(lua_State *L, int n) {
    return (Float *)luaL_testudata(L, n, VECTOR);
}

int l_vector_delete(lua_State *L) {
    //delete *l_vector_check(L, 1);
    return 0;
}

int l_vector_tostring(lua_State *L) {
    Float *v = l_vector_check(L, 1);

    char str[64];
    sprintf(str, "x=%f, y=%f, z=%f, w=%f", v[0], v[1], v[2], v[3]);
    lua_pushstring(L, str);
    return 1;
}

int l_vector_length(lua_State *L) {
    lua_pushunsigned(L, 0);
    return 1;
}

int l_vector_get(lua_State *L) {
    Float *v = l_vector_check(L, 1);

    const char *name = luaL_checkstring(L, 2);
    char var = 0;
    if (name[1] == 0) {
        var = *name;
    }

    switch (var) {
        case '1':
        case 'x':
            lua_pushnumber(L, v[0]);
            break;
        case '2':
        case 'y':
            lua_pushnumber(L, v[1]);
            break;
        case '3':
        case 'z':
            lua_pushnumber(L, v[2]);
            break;
        case '4':
        case 'w':
            lua_pushnumber(L, v[3]);
            break;
        default:
            luaL_getmetatable(L, VECTOR);
            lua_pushstring(L, name);
            lua_gettable(L, -2);
            break;
    }
    return 1;
}

int l_vector_set(lua_State *L) {
    Float *v = l_vector_check(L, 1);

    const char *name = luaL_checkstring(L, 2);
    char var = 0;
    if (name[1] == 0) {
        var = *name;
    }

    switch (var) {
        case '1':
        case 'x':
            v[0] = luaL_checknumber(L,3);
            break;
        case '2':
        case 'y':
            v[1] = luaL_checknumber(L,3);
            break;
        case '3':
        case 'z':
            v[2] = luaL_checknumber(L,3);
            break;
        case '4':
        case 'w':
            v[3] = luaL_checknumber(L,3);
            break;
    }
    return 1;
}

void vec_add(Float *v1, Float *v2, Float *v) {
    v[0] = v1[0] + v2[0];
    v[1] = v1[1] + v2[1];
    v[2] = v1[2] + v2[2];
    v[3] = v1[3] + v2[3];
}

void vec_sub(Float *v1, Float *v2, Float *v) {
    v[0] = v1[0] - v2[0];
    v[1] = v1[1] - v2[1];
    v[2] = v1[2] - v2[2];
    v[3] = v1[3] - v2[3];
}

void vec_mul(Float *v1, Float coef, Float *v) {
    v[0] = v1[0] * coef;
    v[1] = v1[1] * coef;
    v[2] = v1[2] * coef;
    v[3] = v1[3] * coef;
}

void vec_div(Float *v1, Float coef, Float *v) {
    if (coef != 0) {
        vec_mul(v1, 1.0 / coef, v);
    }
}

int l_vector_add(lua_State *L) {
    Float *v1 = l_vector_check(L, 1);
    Float *v2 = l_vector_check(L, 2);

    Float v[4] = {0,0,0,0};
    vec_add(v1, v2, v);

    return l_vector_push(L, v);
}

int l_vector_sub(lua_State *L) {
    Float *v1 = l_vector_check(L, 1);
    Float *v2 = l_vector_check(L, 2);

    Float v[4] = {0,0,0,0};
    vec_sub(v1, v2, v);

    return l_vector_push(L, v);
}

int l_vector_mul(lua_State *L) {
    Float *v1;
    Float coef;
    if (lua_isuserdata(L, 1) == 1) {
        v1 = l_vector_check(L, 1);
        coef = luaL_checknumber(L, 2);
    } else {
        coef = luaL_checknumber(L, 1);
        v1 = l_vector_check(L, 2);
    }

    Float v[4] = {0,0,0,0};
    vec_mul(v1, coef, v);

    return l_vector_push(L, v);
}

int l_vector_div(lua_State *L) {
    Float *v1 = l_vector_check(L, 1);
    Float coef = luaL_checknumber(L, 2);

    Float v[4] = {0,0,0,0};
    vec_div(v1, coef, v);

    return l_vector_push(L, v);
}

int l_vector_unm(lua_State *L) {
    Float *v1 = l_vector_check(L, 1);

    Float v[4] = {0,0,0,0};
    vec_mul(v1, -1, v);

    return l_vector_push(L, v);
}

int l_vector_eq(lua_State *L) {
    Float *v1 = l_vector_check(L, 1);
    Float *v2 = l_vector_check(L, 2);

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

Float vec_lenSqr(Float *v) {
    return (v[0] * v[0] +
            v[1] * v[1] +
            v[2] * v[2]);
}

Float vec_len(Float *v) {
    return sqrt(vec_lenSqr(v));
}

int l_vector_dot(lua_State *L) {
    Float *v1 = l_vector_check(L, 1);
    Float *v2 = l_vector_check(L, 2);

    Float n = (v1[0] * v2[0] +
                    v1[1] * v2[1] +
                    v1[2] * v2[2] +
                    v1[3] * v2[3]);
    lua_pushnumber(L, n);
    return 1;
}

int l_vector_lenSqr(lua_State *L) {
    Float *v = l_vector_check(L, 1);

    lua_pushnumber(L, vec_lenSqr(v));
    return 1;
}

int l_vector_len(lua_State *L) {
    Float *v = l_vector_check(L, 1);

    lua_pushnumber(L, vec_len(v));
    return 1;
}

int l_vector_distSqr(lua_State *L) {
    Float *v1 = l_vector_check(L, 1);
    Float *v2 = l_vector_check(L, 2);

    Float v[4] = {0,0,0,0};
    vec_sub(v1, v2, v);
    lua_pushnumber(L, vec_lenSqr(v));
    return 1;
}

int l_vector_dist(lua_State *L) {
    Float *v1 = l_vector_check(L, 1);
    Float *v2 = l_vector_check(L, 2);

    Float v[4] = {0,0,0,0};
    vec_sub(v1, v2, v);
    lua_pushnumber(L, vec_len(v));
    return 1;
}

int l_vector_normalize(lua_State *L) {
    Float *v1 = l_vector_check(L, 1);

    Float v[4] = {0,0,0,0};
    Float len = vec_len(v1);
    Float coef = 1.0 / len;
//    vec_div(v1, len, v);
    v[0] = v1[0] * coef;
    v[1] = v1[1] * coef;
    v[2] = v1[2] * coef;

    return l_vector_push(L, v);
}

int l_vector_cross(lua_State *L) {
    Float *v1 = l_vector_check(L, 1);
    Float *v2 = l_vector_check(L, 2);

    Float v[4] = {0,0,0,0};
    v[0] = v1[1] * v2[2] - v1[2] * v2[1];
    v[1] = v1[2] * v2[0] - v1[0] * v2[2];
    v[2] = v1[0] * v2[1] - v1[1] * v2[0];

    return l_vector_push(L, v);
}

int l_vector_rotate(lua_State *L) {
    Float *v1 = l_vector_check(L, 1);
    Float deg = luaL_checknumber(L, 2);
    Float rad = deg / 360 * 2 * 3.1415927;

    Float c = cosf(rad);
    Float s = sinf(rad);

    Float v[4] = {0,0,0,0};
    v[0] = v1[0] * c - v1[1] * s;
    v[1] = v1[0] * s + v1[1] * c;

    return l_vector_push(L, v);
}

int l_vector_angleBetween(lua_State *L) {
    Float *v1 = l_vector_check(L, 1);
    Float *v2 = l_vector_check(L, 2);

    Float angle = atan2(v2[1], v2[0]) - atan2(v1[1], v1[0]);

    if (fabs(angle) > PI ) {
        angle += (2 * PI * (angle < 0 ? 1 : -1));
    }

    lua_pushnumber(L, angle);
    return 1;
}

int l_vector_rotate90(lua_State *L) {
    Float *v1 = l_vector_check(L, 1);

    Float v[4] = {0,0,0,0};
    v[0] = -v1[1];
    v[1] = v1[0];

    return l_vector_push(L, v);
}

luaL_Reg vectorFunctions[] = {
    { "__call", l_vector_new },
//  { "__gc", l_vector_delete },
    { "__index", l_vector_get },
    { "__newindex", l_vector_set },
    { "__len", l_vector_length },
    { "__tostring", l_vector_tostring },
    { "__add", l_vector_add },
    { "__sub", l_vector_sub },
    { "__mul", l_vector_mul },
    { "__div", l_vector_div },
    { "__unm", l_vector_unm },
    { "__eq", l_vector_eq },
    { "dot", l_vector_dot },
    { "normalize", l_vector_normalize },
    { "len", l_vector_len },
    { "lenSqr", l_vector_lenSqr },
    { "dist", l_vector_dist },
    { "distSqr", l_vector_distSqr },
    { "cross", l_vector_cross },
    { "rotate", l_vector_rotate },
    { "rotate90", l_vector_rotate90 },
    { "angleBetween", l_vector_angleBetween },
    { NULL, NULL }
};

void register_vector(lua_State *L, const char *name) {
    lua_newtable(L);

    luaL_newmetatable(L, VECTOR);
    luaL_setfuncs(L, vectorFunctions, 0);

    lua_pushstring(L, "vector");
    lua_setfield(L, -2, "className");

    lua_setmetatable(L, -2);

    lua_setglobal(L, name);
}
