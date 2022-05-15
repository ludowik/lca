//
//  matrix.hpp
//  Lca
//
//  Created by lca pro on 18/01/2016.
//  Copyright © 2016 lca. All rights reserved.
//

#ifndef matrix_hpp
#define matrix_hpp

#include "tools.hpp"

typedef float Float;
typedef Float* matrix;

Float *l_matrix_check(lua_State *L, int n);
Float *l_matrix_test(lua_State *L, int n);

void register_matrix(lua_State *L, const char *name);

#endif /* matrix_hpp */
