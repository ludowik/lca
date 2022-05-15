//
//  color.hpp
//  Lca
//
//  Created by lca pro on 06/01/2016.
//  Copyright © 2016 lca. All rights reserved.
//

#ifndef color_hpp
#define color_hpp

#include "tools.hpp"

typedef lua_Integer* color;

int l_color_param(lua_State *L, lua_Number &r, lua_Number &g, lua_Number &b, lua_Number &a);

int l_color_push(lua_State *L, lua_Number *v);
int l_color_push(lua_State *L, lua_Number r, lua_Number g, lua_Number b=0, lua_Number a=255);

lua_Number *l_color_check(lua_State *L, int n);

void register_color(lua_State *L, const char *name);

#endif /* color_hpp */
