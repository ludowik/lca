//
//  contact.hpp
//  Lca
//
//  Created by lca pro on 26/12/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#ifndef contact_hpp
#define contact_hpp

#include "tools.hpp"

extern "C" {
    void register_contact(lua_State *L);
};

class MyContactListener : public b2ContactListener
{
private:
    lua_State *L;

public:
    MyContactListener(lua_State *L);

    void Collide(b2Contact *contact, lua_Unsigned state, const b2ContactImpulse* impulse=NULL);
    
    void BeginContact(b2Contact* contact);
    void EndContact(b2Contact* contact);
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);

};

#endif /* contact_hpp */
