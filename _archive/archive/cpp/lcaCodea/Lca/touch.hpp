//
//  touch.hpp
//  Lca
//
//  Created by lca pro on 03/01/2016.
//  Copyright © 2016 lca. All rights reserved.
//

#ifndef touch_hpp
#define touch_hpp

#include <stdio.h>

int lcaTouched(lua_State *L, int state, SDL_Event *event);

int touchIndex(lua_State *L);

int init_currentTouch(lua_State *L);

#endif /* touch_hpp */
