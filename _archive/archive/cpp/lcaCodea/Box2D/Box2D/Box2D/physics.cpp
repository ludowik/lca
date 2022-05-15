//
//  physics.cpp
//  Lca
//
//  Created by lca pro on 24/12/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#include "physics.hpp"

b2World *world = NULL;

bool paused = true;

#define M2P_RATIO 32.
#define P2M_RATIO 1./M2P_RATIO

b2Vec2 & next_b2Vec2() {
    static b2Vec2 res[100];
    static int i = -1;
    if (++i == 100) {
        i = 0;
    }
    return res[i];
}

float m2p(float meter) {
    return meter * M2P_RATIO;
}

float p2m(float pixel) {
    return pixel * P2M_RATIO;
}

b2Vec2 & m2p(const b2Vec2 &v) {
    b2Vec2 &res = next_b2Vec2();
    res.x = m2p(v.x);
    res.y = m2p(v.y);
    return res;
}

b2Vec2 & p2m(const b2Vec2 &v) {
    b2Vec2 &res = next_b2Vec2();
    res.x = p2m(v.x);
    res.y = p2m(v.y);
    return res;
}

int l_pause(lua_State *L) {
    paused = true;
    return 0;
}

int l_resume(lua_State *L) {
    paused = false;
    return 0;
}

int l_gravity(lua_State *L) {
    int argCount = narg(L);

    if (argCount == 0) {
        l_b2Vec2_push(L, world->GetGravity());
        return 1;
    }
    else if (argCount == 2) {
        b2Vec2 gravity(luaL_checknumber(L, 1), luaL_checknumber(L, 2));
        world->SetGravity(gravity);
    }
    else if (argCount == 1) {
        world->SetGravity(l_b2Vec2_get(L, 1));
    }
    return 0;
}

class RayCast : public b2RayCastCallback {
public:
    lua_State *L;
    bool all;

    Uint16 m_maskBits;

    int m_tableIndex;

    RayCast(lua_State *L, bool all) {
        this->L = L;
        this->all = all;

        m_maskBits = 0;
        m_tableIndex = 0;

        if (all) {
            lua_newtable(L);
        }
    }

    float32 ReportFixture(b2Fixture* fixture, const b2Vec2& point, const b2Vec2& normal, float32 fraction) {
        // If filtering is enabled, skip filtered fixtures
        if (m_maskBits != 0 && (fixture->GetFilterData().categoryBits & m_maskBits) == 0) {
            return 1;
        }

        m_tableIndex++;

        lua_newtable(L);

        lua_pushstring(L, "body");
        l_body_push(L, fixture->GetBody());
        lua_settable(L, -3);

        lua_pushstring(L, "point");
        l_b2Vec2_push(L, m2p(point));
        lua_settable(L, -3);

        lua_pushstring(L, "normal");
        l_b2Vec2_push(L, normal);
        lua_settable(L, -3);

        lua_pushstring(L, "fraction");
        lua_pushnumber(L, fraction);
        lua_settable(L, -3);

        if (all) {
            lua_rawseti(L, -2, m_tableIndex);
        }

        return fraction;
    }
};

int l_raycast(lua_State *L, bool all) {
    int n = narg(L);

    RayCast rayCast(L, all);

    // If there are more than 2 arguments, treat the rest as filter categories
    if (n > 2) {
        uint16 maskBits = 0;
        for (int i = 3; i <= n; i++) {
            // Make sure bit shifts are clamped in range of 16 bit integer
            luaL_checknumber(L, i);
            maskBits |= 1 << MAX(MIN(luaL_checkinteger(L, -1), 15), 0);
        }
        rayCast.m_maskBits = maskBits;
    }

    world->RayCast(&rayCast, p2m(l_b2Vec2_get(L, 1)), p2m(l_b2Vec2_get(L, 2)));

    if (rayCast.m_tableIndex > 0 || all) {
        return 1;
    }

    return 0;
}

int l_raycastAll(lua_State *L) {
    return l_raycast(L, true);
}

int l_raycast(lua_State *L) {
    return l_raycast(L, false);
}

class QueryAABB : public b2QueryCallback {
public:
    lua_State *L;

    int m_tableIndex;

    QueryAABB(lua_State *L) {
        this->L = L;

        m_tableIndex = 0;
    }

    bool ReportFixture(b2Fixture* fixture) {
        if (m_tableIndex == 0) {
            lua_newtable(L);
        }

        l_body_push(L, fixture->GetBody());

        lua_rawseti(L, -2, ++m_tableIndex);

        return true;
    }
};

int l_queryAABB(struct lua_State *L) {
    QueryAABB queryAABB(L);

    b2AABB aabb;
    aabb.lowerBound = p2m(l_b2Vec2_get(L, 1));
    aabb.upperBound = p2m(l_b2Vec2_get(L, 2));

    world->QueryAABB(&queryAABB, aabb);

    return 1;
}

b2Vec2& l_b2Vec2_get(lua_State *L, int idx) {
    Float *v = l_vector_check(L, idx);

    b2Vec2 &res = next_b2Vec2();
    res.x = v[0];
    res.y = v[1];

    return res;
}

int l_b2Vec2_push(lua_State *L, const b2Vec2& v) {
    return l_vector_push(L, v.x, v.y);
}

// functions
static const luaL_Reg functionsPhysics[] = {
    Function(body)
    Function(joint)
    Function(pause)
    Function(resume)
    Function(gravity)
    Function(raycast)
    Function(raycastAll)
    Function(queryAABB)

    { NULL, NULL }
};

// enums
static const CommonEnum enumsPhysics[] = {
    Enum(CIRCLE)
    Enum(EDGE)
    Enum(POLYGON)
    Enum(CHAIN)

    Enum(STATIC)
    Enum(KINEMATIC)
    Enum(DYNAMIC)

    Enum(REVOLUTE)
    Enum(DISTANCE)
    Enum(PRISMATIC)
    Enum(WELD)
    Enum(ROPE)

    { NULL, 0 }
};

int EXPORT luaopen_physics(lua_State *L) {
    commonNewLibrary(L, functionsPhysics);
    commonBindEnumGlobal(L, enumsPhysics);
    lua_setglobal(L, "physics");

    register_body(L);
    register_contact(L);
    register_joint(L);

    b2Vec2 gravity(0.0f, -10.0f); // -9.8

    bool doSleep = true;
    bool doClearForces = true;

    world = new b2World(gravity);
    world->SetAllowSleeping(doSleep);
    world->SetAutoClearForces(doClearForces);

    world->SetContactListener(new MyContactListener(L));
    
    paused = false;

    return 0;
}

int b2Update(lua_State *L, float32 timeStep) {
    if (paused) {
        return 0;
    }

    int32 velocityIterations = 8;
    int32 positionIterations = 3;

    world->Step(timeStep, velocityIterations, positionIterations);
    //world->ClearForces();
    
    return 1;
}
