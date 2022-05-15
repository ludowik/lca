//
//  body.hpp
//  Lca
//
//  Created by lca pro on 24/12/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#ifndef body_hpp
#define body_hpp

#include "tools.hpp"

extern "C" {
    void register_body(lua_State *L);
};

int l_body(lua_State *L);

int l_body_push(lua_State *L, b2Body *body);

b2Body *l_body_check(lua_State *L, int n);

#endif /* body_hpp */