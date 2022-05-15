//
//  lua.hpp
//  Lca
//
//  Created by lca pro on 22/12/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#ifndef lua_hpp
#define lua_hpp

#include <stdio.h>

extern "C" {
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

#include "lfs.h"
#include "sdl.h"

#include "common/common.h"

int docall (lua_State *L, int narg, int nres);
};

using namespace std;

#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <list>
#include <vector>
#include <map>
#include <thread>

#include "opengl.hpp"

#define CLAMP(x, l, h)  (((x) > (h)) ? (h) : (((x) < (l)) ? (l) : (x)))

#define MIN(x, l) (((x) < (l)) ? (x) : (l))
#define MAX(x, h) (((x) > (h)) ? (x) : (h))

#define Function(name) {#name, l_##name},
#define Enum(name) {#name, name},

#define lua_check(idx, cType, luaType) (cType)luaL_check##luaType(L, idx)
#define lua_option(idx, cType, luaType, defaultValue) (cType)luaL_opt##luaType(L, idx, defaultValue)

int narg(lua_State *L);

bool luaL_checkboolean(lua_State *L, int narg);

lua_Number getNumber(lua_State *L, const char *name);

int setGlobal(lua_State *L, const char *name, lua_Number number);

void register_lib(lua_State *L, const luaL_Reg *funcs=NULL, const CommonEnum *enums=NULL);

#define PI 3.1415927

#define D2R_RATIO PI / 180.
#define R2D_RATIO 180. / PI

inline float degree(float radian) {
    return radian * R2D_RATIO;
}

inline float radian(float degree) {
    return degree * D2R_RATIO;
}

#endif /* lua_hpp */
