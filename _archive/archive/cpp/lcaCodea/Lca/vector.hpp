//
//  vector.hpp
//  Lca
//
//  Created by lca pro on 22/12/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#ifndef vector_hpp
#define vector_hpp

#include "tools.hpp"

typedef float Float;
typedef Float* vector;

Float *vector_new(lua_State *L);

int l_vector_push(lua_State *L, Float *v);
int l_vector_push(lua_State *L, Float x, Float y, Float z=0, Float w=0);

Float *l_vector_check(lua_State *L, int n);
Float *l_vector_test(lua_State *L, int n);

void register_vector(lua_State *L, const char *name);

#endif /* vector_hpp */