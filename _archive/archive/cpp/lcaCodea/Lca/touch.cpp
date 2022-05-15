//
//  touch.cpp
//  Lca
//
//  Created by lca pro on 03/01/2016.
//  Copyright © 2016 lca. All rights reserved.
//

#include "tools.hpp"
#include "graphics.hpp"
#include "touch.hpp"

int lcaTouched(lua_State *L, int state, SDL_Event *event) {
    event->motion.y = HEIGHT - event->motion.y;
    event->motion.yrel = - event->motion.yrel;

    lua_getglobal(L, "touched");

    lua_newtable(L);

    lua_pushinteger(L, 1);
    lua_setfield(L, -2, "id");

    lua_pushinteger(L, state);
    lua_setfield(L, -2, "state");

    lua_pushinteger(L, event->motion.x - event->motion.xrel);
    lua_setfield(L, -2, "prevX");

    lua_pushinteger(L, event->motion.y - event->motion.yrel);
    lua_setfield(L, -2, "prevY");

    lua_pushinteger(L, event->motion.x);
    lua_setfield(L, -2, "x");

    lua_pushinteger(L, event->motion.y);
    lua_setfield(L, -2, "y");

    lua_pushinteger(L, event->motion.xrel);
    lua_setfield(L, -2, "deltaX");

    lua_pushinteger(L, event->motion.yrel);
    lua_setfield(L, -2, "deltaY");

    lua_pushinteger(L, 1);
    lua_setfield(L, -2, "tapCount");

    return lua_pcall(L, 1, LUA_MULTRET, 0);
}

int touchIndex(lua_State *L) {
    const char *name = luaL_checkstring(L, 2);
    if ( !strcmp(name, "x") ) {
        static int x;
        SDL_GetMouseState(&x, 0);
        lua_pushinteger(L, x);
        return 1;
    }
    else if ( !strcmp(name, "y") ) {
        static int y;
        SDL_GetMouseState(0, &y);
        lua_pushinteger(L, HEIGHT-y);
        return 1;
    }
    return 0;
}

int init_currentTouch(lua_State *L) {
    lua_newuserdata(L, sizeof (void *));

    lua_newtable(L);
    lua_pushcfunction(L, touchIndex);
    lua_setfield(L, -2, "__index");
    lua_setmetatable(L, -2);
    lua_setglobal(L, "CurrentTouch");

    return 0;
}