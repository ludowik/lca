//
//  body.cpp
//  Lca
//
//  Created by lca pro on 24/12/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#include "physics.hpp"

#define BODY "luaL_body"

#define MAX_VERTICES 8

int l_body(lua_State *L) {
    int narg = lua_gettop(L);

    ShapeType shapeType = lua_check(1, ShapeType, integer);

    b2Body *body = NULL;

    b2BodyDef bodyDef;

    b2FixtureDef fixtureDef;
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.3f;

    b2CircleShape circle;
    b2PolygonShape polygon;
    b2ChainShape chain;
    b2EdgeShape edge;

    switch ( shapeType ) {
        case CIRCLE: {
            bodyDef.type = b2_dynamicBody;
            circle.m_radius = p2m(lua_check(2, float, number));
            fixtureDef.shape = &circle;
            break;
        }
        case POLYGON: {
            bodyDef.type = b2_dynamicBody;
            int vecCount = MIN(MAX_VERTICES, narg-1);
            b2Vec2 vertices[MAX_VERTICES];
            for (int i = 0; i < vecCount; i++) {
                b2Vec2 &v = p2m(l_b2Vec2_get(L, i+2));
                vertices[i].Set(v.x, v.y);
            }
            polygon.Set(vertices, vecCount);
            fixtureDef.shape = &polygon;
            break;
        }
        case CHAIN: {
            bodyDef.type = b2_staticBody;
            bool loop = lua_toboolean(L, 2);
            int vecCount = narg-2;
            b2Vec2 *vertices = new b2Vec2[vecCount];
            for (int i = 0; i < vecCount; i++) {
                b2Vec2 &v = p2m(l_b2Vec2_get(L, i+3));
                vertices[i].Set(v.x, v.y);
            }
            if (loop)
                chain.CreateLoop(vertices, vecCount);
            else
                chain.CreateChain(vertices, vecCount);
            fixtureDef.shape = &chain;
            delete []vertices;
            break;
        }
        case EDGE: {
            bodyDef.type = b2_staticBody;
            b2Vec2 &v1 = p2m(l_b2Vec2_get(L, 2));
            b2Vec2 &v2 = p2m(l_b2Vec2_get(L, 3));
            edge.Set(v1, v2);
            fixtureDef.shape = &edge;
            break;
        }
        default: {
            lua_writestringerror("body %s", "Unknown ShapeType");
            break;
        }
    }

    bodyDef.position.Set(0.0f, 0.0f);
    body = world->CreateBody(&bodyDef);
    body->CreateFixture(&fixtureDef);

    if (body) {
        return l_body_push(L, body);
    }

    return 0;
}

int l_body_push(lua_State *L, b2Body *body) {
    b2Body **ref = (b2Body **)body->GetUserData();
    if (ref == NULL) {
        ref = (b2Body**)lua_newuserdata(L, sizeof(b2Body*));
        lua_newtable(L);
        lua_setuservalue(L, -2);
        body->SetUserData(ref);
        *ref = body;
    } else {
        lua_pushlightuserdata(L, ref);
    }
    luaL_getmetatable(L, BODY);
    lua_setmetatable(L, -2);
    return 1;
}

b2Body *l_body_check(lua_State *L, int n) {
    b2Body **ref = (b2Body **)luaL_checkudata(L, n, BODY);
    if (ref) {
        return (b2Body*)*ref;
    }
    return NULL;
}

int l_body_get(lua_State *L) {
    b2Body *body = l_body_check(L, 1);
    b2Fixture *fixture = body->GetFixtureList();

    const char *name = luaL_checkstring(L, 2);
    if (strcmp(name, "type") == 0 ) {
        lua_pushinteger(L, body->GetType());
    }
    else if (strcmp(name, "shapeType") == 0 ) {
        lua_pushinteger(L, body->GetFixtureList()->GetType());
    }
    else if (strcmp(name, "radius") == 0 ) {
        if (fixture->GetType() == b2Shape::e_circle) {
            b2CircleShape* circle = (b2CircleShape*)fixture->GetShape();
            lua_pushinteger(L, m2p(circle->m_radius));
        }
    }
    else if (strcmp(name, "points") == 0 ) {
        switch (fixture->GetType()) {
            case b2Shape::e_polygon: {
                b2PolygonShape *polygon = (b2PolygonShape*)fixture->GetShape();

                lua_newtable(L);

                for (int i = 0; i < polygon->m_count; i++) {
                    lua_pushnumber(L, i+1);
                    l_b2Vec2_push(L, m2p(polygon->m_vertices[i]));
                    lua_settable(L, -3);
                }
                break;
            }
            case b2Shape::e_chain: {
                b2ChainShape *chain = (b2ChainShape*)fixture->GetShape();

                lua_newtable(L);

                for (int i = 0; i < chain->m_count; i++) {
                    lua_pushnumber(L, i+1);
                    l_b2Vec2_push(L, m2p(chain->m_vertices[i]));
                    lua_settable(L, -3);
                }
                break;
            }
            case b2Shape::e_edge: {
                b2EdgeShape *edge = (b2EdgeShape*)fixture->GetShape();

                lua_newtable(L);

                lua_pushnumber(L, 1);
                l_b2Vec2_push(L, m2p(edge->m_vertex1));
                lua_settable(L, -3);

                lua_pushnumber(L, 2);
                l_b2Vec2_push(L, m2p(edge->m_vertex2));
                lua_settable(L, -3);
                break;
            }
            default: {
                break;
            }
        }
    }
    else if (strcmp(name, "x") == 0 ) {
        lua_pushnumber(L, m2p(body->GetPosition().x));
    }
    else if (strcmp(name, "y") == 0 ) {
        lua_pushnumber(L, m2p(body->GetPosition().y));
    }
    else if (strcmp(name, "position") == 0 ) {
        l_b2Vec2_push(L, m2p(body->GetPosition()));
    }
    else if (strcmp(name, "angle") == 0 ) {
        lua_pushnumber(L, degree(body->GetAngle()));
    }
    else if (strcmp(name, "worldCenter") == 0 ) {
        l_b2Vec2_push(L, m2p(body->GetWorldCenter()));
    }
    else if (strcmp(name, "localCenter") == 0 ) {
        l_b2Vec2_push(L, m2p(body->GetLocalCenter()));
    }
    else if (strcmp(name, "linearVelocity") == 0 ) {
        l_b2Vec2_push(L, m2p(body->GetLinearVelocity()));
    }
    else if (strcmp(name, "angularVelocity") == 0 ) {
        lua_pushnumber(L, degree(body->GetAngularVelocity()));
    }
    else if (strcmp(name, "density") == 0 ) {
        lua_pushnumber(L, fixture->GetDensity());
    }
    else if (strcmp(name, "mass") == 0 ) {
        lua_pushnumber(L, body->GetMass());
    }
    else if (strcmp(name, "inertia") == 0 ) {
        lua_pushnumber(L, body->GetInertia());
    }
    else if (strcmp(name, "restitution") == 0 ) {
        lua_pushnumber(L, fixture->GetRestitution());
    }
    else if (strcmp(name, "friction") == 0 ) {
        lua_pushnumber(L, fixture->GetFriction());
    }
    else if (strcmp(name, "categories") == 0 ) {
        b2Filter filter(fixture->GetFilterData());
        lua_newtable(L);
        for (int i = 0, count = 1; i <= 15; i++) {
            if (filter.categoryBits & (1 << i)) {
                lua_pushinteger(L, i);
                lua_rawseti(L, -2, count++);
            }
        }
    }
    else if (strcmp(name, "mask") == 0 ) {
        b2Filter filter(fixture->GetFilterData());
        lua_newtable(L);
        for (int i = 0, count = 1; i <= 15; i++) {
            if (filter.maskBits & (1 << i)) {
                lua_pushinteger(L, i);
                lua_rawseti(L, -2, count++);
            }
        }
    }
    else if (strcmp(name, "fixedRotation") == 0 ) {
        lua_pushboolean(L, body->IsFixedRotation()?1:0);
    }
    else if (strcmp(name, "active") == 0 ) {
        lua_pushnumber(L, body->IsActive()?1:0);
    }
    else if (strcmp(name, "sensor") == 0 ) {
        lua_pushboolean(L, fixture->IsSensor()?1:0);
    }
    else if (strcmp(name, "awake") == 0 ) {
        lua_pushboolean(L, body->IsAwake()?1:0);
    }
    else if (strcmp(name, "sleepingAllowed") == 0 ) {
        lua_pushboolean(L, body->IsSleepingAllowed()?1:0);
    }
    else if (strcmp(name, "bullet") == 0 ) {
        lua_pushboolean(L, body->IsBullet()?1:0);
    }
    else if (strcmp(name, "gravityScale") == 0 ) {
        lua_pushnumber(L, body->GetGravityScale());
    }
    else if (strcmp(name, "linearDamping") == 0 ) {
        lua_pushnumber(L, body->GetLinearDamping());
    }
    else if (strcmp(name, "angularDamping") == 0 ) {
        lua_pushnumber(L, body->GetAngularDamping());
    }
    else if (strcmp(name, "interpolate") == 0 ) {
        lua_pushboolean(L, 0);
    }
    else if (strcmp(name, "joints") == 0 ) {
        // TODO?
    }
    else {
        luaL_getmetatable(L, BODY);
        lua_pushvalue(L, 2);
        lua_gettable(L, -2);

        if (lua_isnil(L, -1)) {
            lua_getuservalue(L, 1);
            lua_pushvalue(L, 2);
            lua_gettable(L, -2);
        }
    }

    return 1;
}

int l_body_set(lua_State *L) {
    b2Body *body = l_body_check(L, 1);
    b2Fixture *fixture = body->GetFixtureList();

    const char *name = luaL_checkstring(L, 2);
    if (strcmp(name, "type") == 0 ) {
        body->SetType((b2BodyType)luaL_checkinteger(L, 3));
    }
    else if (strcmp(name, "shapeType") == 0 ) {
        // read only
    }
    else if (strcmp(name, "radius") == 0 ) {
        // read only
    }
    else if (strcmp(name, "points") == 0 ) {
        // read only
    }
    else if (strcmp(name, "x") == 0 ) {
        b2Vec2 &v = (b2Vec2 &)body->GetPosition();
        v.x = p2m(luaL_checknumber(L, 3));
        body->SetTransform(v, body->GetAngle());
    }
    else if (strcmp(name, "y") == 0 ) {
        b2Vec2 &v = (b2Vec2 &)body->GetPosition();
        v.y = p2m(luaL_checknumber(L, 3));
        body->SetTransform(v, body->GetAngle());
    }
    else if (strcmp(name, "position") == 0 ) {
        body->SetTransform(p2m(l_b2Vec2_get(L)), body->GetAngle());
    }
    else if (strcmp(name, "angle") == 0 ) {
        body->SetTransform(body->GetPosition(), radian(luaL_checknumber(L, 3)));
    }
    else if (strcmp(name, "worldCenter") == 0 ) {
        // read only
    }
    else if (strcmp(name, "localCenter") == 0 ) {
        // read only
    }
    else if (strcmp(name, "linearVelocity") == 0 ) {
        body->SetLinearVelocity(p2m(l_b2Vec2_get(L)));
    }
    else if (strcmp(name, "angularVelocity") == 0 ) {
        body->SetAngularVelocity(radian(luaL_checknumber(L, 3)));
    }
    else if (strcmp(name, "density") == 0 ) {
        fixture->SetDensity(luaL_checknumber(L, 3));
    }
    else if (strcmp(name, "mass") == 0 ) {
        b2MassData massData;
        body->GetMassData(&massData);
        massData.mass = luaL_checknumber(L, 3);
        body->SetMassData(&massData);
    }
    else if (strcmp(name, "inertia") == 0 ) {
        // read only
    }
    else if (strcmp(name, "restitution") == 0 ) {
        float restitution = CLAMP(luaL_checknumber(L,3), 0, b2_maxFloat);
        for (b2Fixture* f = body->GetFixtureList(); f; f = f->GetNext()) {
            f->SetRestitution(restitution);
        }
    }
    else if (strcmp(name, "friction") == 0 ) {
        float friction = CLAMP(luaL_checknumber(L,3), 0, b2_maxFloat);
        for (b2Fixture* f = body->GetFixtureList(); f; f = f->GetNext()) {
            f->SetFriction(friction);
        }
    }
    else if (strcmp(name, "categories") == 0 ) {
        luaL_checktype(L, 3, LUA_TTABLE);
        int n = lua_objlen(L, 3);
        if (body && n >= 1) {
            b2Filter filter(fixture->GetFilterData());
            filter.categoryBits = 0;
            for (int i = 1; i <= n; i++) {
                // Make sure bit shifts are clamped in range of 16 bit integer
                lua_rawgeti(L, 3, i);
                filter.categoryBits |= 1 << CLAMP(luaL_checkinteger(L, -1), 0, 15);
                lua_pop(L, 1);
            }
            for (b2Fixture* f = body->GetFixtureList(); f; f = f->GetNext()) {
                f->SetFilterData(filter);
            }
        }
    }
    else if (strcmp(name, "mask") == 0 ) {
        luaL_checktype(L, 3, LUA_TTABLE);
        int n = lua_objlen(L, 3);
        if (body && n >= 1) {
            b2Filter filter(fixture->GetFilterData());
            filter.maskBits = 0;
            for (int i = 1; i <= n; i++) {
                lua_rawgeti(L, 3, i);
                filter.maskBits |= 1 << CLAMP(luaL_checkinteger(L, -1), 0, 15);
                lua_pop(L, 1);
            }
            for (b2Fixture* f = body->GetFixtureList(); f; f = f->GetNext()) {
                f->SetFilterData(filter);
            }
        }
    }
    else if (strcmp(name, "fixedRotation") == 0 ) {
        body->SetFixedRotation(luaL_checkboolean(L,3));
    }
    else if (strcmp(name, "active") == 0 ) {
        body->SetActive(luaL_checkboolean(L,3));
    }
    else if (strcmp(name, "sensor") == 0 ) {
        fixture->SetSensor(luaL_checkboolean(L,3));
    }
    else if (strcmp(name, "awake") == 0 ) {
        body->SetAwake(luaL_checkboolean(L,3));
    }
    else if (strcmp(name, "sleepingAllowed") == 0 ) {
        body->SetSleepingAllowed(luaL_checkboolean(L,3));
    }
    else if (strcmp(name, "bullet") == 0 ) {
        body->SetBullet(luaL_checkboolean(L,3));
    }
    else if (strcmp(name, "gravityScale") == 0 ) {
        body->SetGravityScale(luaL_checknumber(L, 3));
    }
    else if (strcmp(name, "linearDamping") == 0 ) {
        body->SetLinearDamping(luaL_checknumber(L, 3));
    }
    else if (strcmp(name, "angularDamping") == 0 ) {
        body->SetAngularDamping(luaL_checknumber(L, 3));
    }
    else if (strcmp(name, "interpolate") == 0 ) {
        // TODO?
    }
    else if (strcmp(name, "joints") == 0 ) {
        // TODO?
    }
    else {
        lua_getuservalue(L, 1);
        lua_pushvalue(L, 2);
        lua_pushvalue(L, 3);
        lua_settable(L, -3);
    }

    return 1;
}

int l_applyForce(lua_State *L) {
    int numArgs = lua_gettop(L);

    b2Body *body = l_body_check(L, 1);
    b2Vec2 &force = l_b2Vec2_get(L, 2);

    if (numArgs == 2) {
        body->ApplyForceToCenter(force, false);
    }
    else if (numArgs == 3) {
        b2Vec2 &center = l_b2Vec2_get(L, 3);
        body->ApplyForce(force, p2m(center), false);
    }
    return 0;
}

int l_applyTorque(lua_State *L) {
    b2Body *body = l_body_check(L, 1);
    lua_Number torque = luaL_checknumber(L, 2);
    body->ApplyTorque(torque, false);
    return 0;
}

static int l_destroy(lua_State *L) {
    b2Body *body = l_body_check(L, 1);
    world->DestroyBody(body);
    return 0;
}

int l_testPoint(lua_State *L) {
    b2Body *body = l_body_check(L, 1);
    b2Vec2 &worldPoint = p2m(l_b2Vec2_get(L, 2));

    bool test = false;
    for (b2Fixture* f = body->GetFixtureList(); f; f = f->GetNext()) {
        if (f->TestPoint(worldPoint)) {
            test = true;
            break;
        }
    }
    lua_pushboolean(L, test);
    return 1;
}

int l_testOverlap(lua_State *L) {
    b2Body *b1 = l_body_check(L, 1);
    b2Body *b2 = l_body_check(L, 2);

    bool test = false;
    for (b2Fixture* f1 = b1->GetFixtureList(); f1; f1 = f1->GetNext()) {
        for (b2Fixture* f2 = b2->GetFixtureList(); f2; f2 = f2->GetNext()) {
            if (b2TestOverlap(f1->GetShape(), 0,
                              f2->GetShape(), 0,
                              b1->GetTransform(),
                              b2->GetTransform())) {
                test = true;
                break;
            }
        }
        
        if (test) {
            break;
        }
    }
    lua_pushboolean(L, test);
    return 1;
}

int l_getLocalPoint(lua_State *L) {
    b2Body *b = l_body_check(L, 1);
    b2Vec2 &worldPoint = p2m(l_b2Vec2_get(L, 2));

    l_b2Vec2_push(L, m2p(b->GetLocalPoint(worldPoint)));
    return 1;
}

int l_getWorldPoint(lua_State *L) {
    b2Body *b = l_body_check(L, 1);
    b2Vec2 &localPoint = p2m(l_b2Vec2_get(L, 2));

    l_b2Vec2_push(L, m2p(b->GetWorldPoint(localPoint)));
    return 1;
}

int l_getLinearVelocityFromWorldPoint(lua_State *L) {
    b2Body *b = l_body_check(L, 1);
    b2Vec2 &worldPoint = p2m(l_b2Vec2_get(L, 2));

    l_b2Vec2_push(L, m2p(b->GetLinearVelocityFromWorldPoint(worldPoint)));
    return 1;
}

int l_getLinearVelocityFromLocalPoint(lua_State *L) {
    b2Body *b = l_body_check(L, 1);
    b2Vec2 &localPoint = p2m(l_b2Vec2_get(L, 2));

    l_b2Vec2_push(L, m2p(b->GetLinearVelocityFromLocalPoint(localPoint)));
    return 1;
}

// functions
static const luaL_Reg bodyFunctions[] = {
    {"__index", l_body_get},
    {"__newindex", l_body_set},

    Function(applyForce)
    Function(applyTorque)

    Function(destroy)

    Function(testPoint)
    Function(testOverlap)

    Function(getLocalPoint)
    Function(getWorldPoint)

    Function(getLinearVelocityFromWorldPoint)
    Function(getLinearVelocityFromLocalPoint)

    { NULL, NULL }
};

void register_body(lua_State *L) {
    luaL_newmetatable(L, BODY);
    luaL_setfuncs(L, bodyFunctions, 0);

    lua_pushstring(L, "body");
    lua_setfield(L, -2, "className");
}