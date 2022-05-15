//
//  joint.hpp
//  Lca
//
//  Created by lca pro on 30/12/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#ifndef joint_hpp
#define joint_hpp

#include "tools.hpp"

extern "C" {
    void register_joint(lua_State *L);
};

int l_joint(lua_State *L);

b2Joint *l_joint_check(lua_State *L, int n);

#endif /* joint_hpp */