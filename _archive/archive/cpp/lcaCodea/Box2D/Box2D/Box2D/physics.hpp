//
//  physics.hpp
//  Lca
//
//  Created by lca pro on 24/12/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#ifndef physics_hpp
#define physics_hpp

#include "tools.hpp"
#include "vector.hpp"
#include "box2d.h"
#include "body.hpp"
#include "joint.hpp"
#include "contact.hpp"

extern "C" {
    int luaopen_physics(lua_State *L);
};

enum ShapeType {
    CIRCLE = b2Shape::e_circle,
    EDGE = b2Shape::e_edge,
    POLYGON = b2Shape::e_polygon,
    CHAIN = b2Shape::e_chain
};

enum BodyType {
    STATIC = b2_staticBody,
    KINEMATIC = b2_kinematicBody,
    DYNAMIC = b2_dynamicBody
};

enum JointType {
    REVOLUTE = e_revoluteJoint,
    DISTANCE = e_distanceJoint,
    PRISMATIC = e_prismaticJoint,
    WELD = e_weldJoint,
    ROPE = e_ropeJoint
};

b2Vec2 & next_b2Vec2();

b2Vec2 & l_b2Vec2_get(lua_State *L, int idx = 3);
int l_b2Vec2_push(lua_State *L, const b2Vec2 &v);

int b2Update(lua_State *L, float32 timeStep);

extern b2World *world;

float p2m(float pixel);
float m2p(float meter);

b2Vec2 & p2m(const b2Vec2 &v);
b2Vec2 & m2p(const b2Vec2 &v);

float degree(float radian);
float radian(float degree);

#endif /* physics_hpp */
