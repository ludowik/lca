//
//  main.h
//  Lca
//
//  Created by lca pro on 22/11/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#ifndef main_h
#define main_h

#include <stdio.h>
#include <stdbool.h>

extern "C" {
    int luaopen_lfs(lua_State *L);
    int luaopen_SDL(lua_State *L);
    int luaopen_Box2D(lua_State *L);

    int docall (lua_State *L, int narg, int nres);

    int lcaSetup(lua_State *L, int argc, char **argv);
    int lcaMain(lua_State *L);
};

int luaopen_OGL(lua_State *L);

#define call(f) \
    lua_getglobal(L, #f); \
    result = docall(L, 0, 0); \
    if ( result != LUA_OK ) { \
        return result; \
    }

#define call1s(f, str) \
    lua_getglobal(L, #f); \
    lua_pushstring(L, str);\
    result = docall(L, 1, 0); \
    if ( result != LUA_OK ) { \
        return result; \
    }

enum {
    BEGAN = 1,
    MOVING = 2,
    ENDED = 3,
    CANCELLED = 4
};

extern Uint32 deltaTime;
extern Uint32 elapsedTime;

#endif /* main_h */