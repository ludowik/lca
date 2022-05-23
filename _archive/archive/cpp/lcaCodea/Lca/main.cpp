//
//  main.c
//  Lca
//
//  Created by lca pro on 22/11/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#include "tools.hpp"
#include "main.hpp"
#include "vector.hpp"
#include "matrix.hpp"
#include "opengl.hpp"
#include "color.hpp"
#include "touch.hpp"
#include "graphics.hpp"
#include "physics.hpp"

// enums
static const CommonEnum enumsTouchState[] = {
    Enum(BEGAN)
    Enum(MOVING)
    Enum(ENDED)
    Enum(CANCELLED)
};

int l_clearOutput(lua_State *L) {
    return 0;
}

int l_setup(lua_State *L) {
    return 0;
}

int l_draw(lua_State *L) {
    return 0;
}

int l_touched(lua_State *L) {
    return 0;
}

int l_collide(lua_State *L) {
    return 0;
}

const luaL_Reg globalFunctions[] = {
    Function(clearOutput)

    Function(setup)
    Function(draw)
    Function(touched)
    Function(collide)

    { NULL, NULL }
};

int lcaSetup(lua_State *L, int argc, char **argv) {
    luaopen_lfs(L);
    luaopen_SDL(L);
    luaopen_OGL(L);
    luaopen_physics(L);

    register_vector(L, "vec2");
    register_vector(L, "vec3");
    register_vector(L, "vec4");

    register_matrix(L, "matrix");

    register_color(L, "color");

    register_graphics(L);

    register_lib(L, globalFunctions);

    init_sdl(&WIDTH, &HEIGHT);
    init_gl();

    setGlobal(L, "WIDTH", WIDTH);
    setGlobal(L, "HEIGHT", HEIGHT);
    
    commonBindEnumGlobal(L, enumsTouchState);

    setGlobal(L, "deltaTime", 0);
    setGlobal(L, "elapsedTime", 0);

    setGlobal(L, "CurrentOrientation", LANDSCAPE_LEFT);

    init_currentTouch(L);

    argv[3] = (char*)"Main.lua";

    int res = luaL_loadfile(L, "/Users/Ludo/Projets/C++/LcaCodea/Lca/Class.lua");

    if (res == 0) {
        res = lua_pcall(L, 0, 0, 0);
    }
    return res;
}

Uint32 deltaTime = 0;
Uint32 elapsedTime = 0;

int lcaMain(lua_State *L) {
    int result = LUA_OK;

    SDL_Event event;

    bool stop = false;

    call(setup);

    Uint32 previousTime = 0;
    Uint32 currentTime = 0;

    deltaTime = 0;
    elapsedTime = 0;

    previousTime = SDL_GetTicks();

    while ( stop == false && result == LUA_OK ) {
        while ( SDL_WaitEventTimeout(&event, 0) == 1 ) {
            switch ( event.type ) {
                case SDL_KEYDOWN: {
                    if ( event.key.keysym.scancode == SDL_SCANCODE_ESCAPE ) {
                        stop = true;
                    } else {
                        call1s(keyboard, SDL_GetScancodeName(event.key.keysym.scancode));
                    }
                    break;
                }
                case SDL_MOUSEBUTTONDOWN: {
                    result = lcaTouched(L, BEGAN, &event);
                    break;
                }
                case SDL_MOUSEMOTION: {
                    if ( event.motion.state & SDL_BUTTON_LMASK ) {
                        result = lcaTouched(L, MOVING, &event);
                    }
                    break;
                }
                case SDL_MOUSEBUTTONUP: {
                    result = lcaTouched(L, ENDED, &event);
                    break;
                }
            }
        }

        clear_gl();
        call(draw);
        swap_gl();

        currentTime = SDL_GetTicks();

        deltaTime = currentTime - previousTime;
        previousTime = currentTime;

        elapsedTime += deltaTime;

        float timeStep = deltaTime/1000.;
        b2Update(L, timeStep);

        setGlobal(L, "deltaTime", timeStep);
        setGlobal(L, "elapsedTime", elapsedTime/1000.);
    }

    call(finish);
    
    return result;
}
