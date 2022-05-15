//
//  contact.cpp
//  Lca
//
//  Created by lca pro on 26/12/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#include "tools.hpp"
#include "main.hpp"
#include "physics.hpp"

#define CONTACT "luaL_contact"

class lcaContact {
public:
    lcaContact(b2Contact *contact, lua_Unsigned state, const b2ContactImpulse *impulse=NULL) {
        b2WorldManifold worldManifold;
        contact->GetWorldManifold(&worldManifold);

        b2Manifold *manifold = contact->GetManifold();

        this->contact = contact;

        this->state = state;

        this->position = b2Vec2(0,0);
        this->normal = worldManifold.normal;

        this->normalImpulse = 0;
        this->tangentImpulse = 0;

        this->pointCount = manifold->pointCount;

        for (int i = 0; i < manifold->pointCount; i++) {
            this->position += worldManifold.points[i];
            if (impulse) {
                this->normalImpulse += impulse->normalImpulses[i];
                this->tangentImpulse += impulse->tangentImpulses[i];
            }
        }

        this->position.x /= manifold->pointCount;
        this->position.y /= manifold->pointCount;

        this->normalImpulse /= manifold->pointCount;
        this->tangentImpulse /= manifold->pointCount;
    }

    b2Contact *contact;

    lua_Unsigned state;

    b2Vec2 position;
    b2Vec2 normal;

    float normalImpulse;
    float tangentImpulse;

    int pointCount;
};

int l_contact_push(lua_State *L, b2Contact *contact, lua_Unsigned state, const b2ContactImpulse *impulse=NULL) {
    lcaContact **pv = (lcaContact **)lua_newuserdata(L, sizeof(lcaContact*));
    *pv = new lcaContact(contact, state);

    luaL_getmetatable(L, CONTACT);
    lua_setmetatable(L, -2);

    return 1;
}

lcaContact *l_contact_check(lua_State *L, int n) {
    return *(lcaContact **)luaL_checkudata(L, n, CONTACT);
}

int l_contact_delete(lua_State *L) {
    delete l_contact_check(L, 1);
    return 0;
}

int l_contact_get(lua_State *L) {
    lcaContact *contact = l_contact_check(L, 1);

    const char *name = luaL_checkstring(L, 2);
    if (strcmp(name, "id") == 0) {
        lua_pushunsigned(L, (lua_Unsigned)contact->contact);
    }
    else if (strcmp(name, "state") == 0) {
        lua_pushunsigned(L, contact->state);
    }
    else if (strcmp(name, "touching") == 0) {
        lua_pushboolean(L, contact->contact->IsTouching()?1:0);
    }
    else if (strcmp(name, "position") == 0) {
        l_b2Vec2_push(L, m2p(contact->position));
    }
    else if (strcmp(name, "normal") == 0) {
        l_b2Vec2_push(L, m2p(contact->normal));
    }
    else if (strcmp(name, "normalImpulse") == 0) {
        lua_pushnumber(L, contact->normalImpulse);
    }
    else if (strcmp(name, "tangentImpulse") == 0) {
        lua_pushnumber(L, contact->tangentImpulse);
    }
    else if (strcmp(name, "pointCount") == 0) {
        lua_pushinteger(L, contact->pointCount);
    }
    else if (strcmp(name, "points") == 0) {
        b2WorldManifold worldManifold;
        contact->contact->GetWorldManifold(&worldManifold);

        lua_createtable(L, contact->pointCount, 0);
        for (int i = 0; i < contact->pointCount; i++) {
            l_vector_push(L,
                       m2p(worldManifold.points[i].x),
                       m2p(worldManifold.points[i].y));
            lua_rawseti(L, -2, i+1);
        }
    }
    else if (strcmp(name, "bodyA") == 0) {
        l_body_push(L, contact->contact->GetFixtureA()->GetBody());
    }
    else if (strcmp(name, "bodyB") == 0) {
        l_body_push(L, contact->contact->GetFixtureB()->GetBody());
    }
    return 1;
}

luaL_Reg contactRegs[] = {
    { "__gc", l_contact_delete },
    { "__index", l_contact_get },

    { NULL, NULL }
};

void register_contact(lua_State *L) {
    lua_newtable(L);

    luaL_newmetatable(L, CONTACT);
    luaL_setfuncs(L, contactRegs, 0);

    lua_pushstring(L, "contact");
    lua_setfield(L, -2, "className");

    lua_setmetatable(L, -2);
}

MyContactListener::MyContactListener(lua_State *L) {
    this->L = L;
}

void MyContactListener::Collide(b2Contact *contact, lua_Unsigned state, const b2ContactImpulse *impulse) {
    lua_getglobal(L, "collide");

    l_contact_push(L, contact, state, impulse);

    int result = docall(L, 1, 0);
    if ( result != LUA_OK ) {
    }
}

void MyContactListener::BeginContact(b2Contact *contact) {
    Collide(contact, BEGAN);
}

void MyContactListener::EndContact(b2Contact *contact) {
    Collide(contact, ENDED);
}

void MyContactListener::PreSolve(b2Contact *contact, const b2Manifold *oldManifold) {
}

void MyContactListener::PostSolve(b2Contact *contact, const b2ContactImpulse *impulse) {
    Collide(contact, MOVING);
}