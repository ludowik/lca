//
//  joint.cpp
//  Lca
//
//  Created by lca pro on 30/12/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#include "physics.hpp"
#include "main.hpp"

#define JOINT "luaL_joint"

int l_joint_new(lua_State *L, b2Joint *joint, int bodyRefA, int bodyRefB) {
    *(b2Joint **)lua_newuserdata(L, sizeof(b2Joint*)) = joint;
    luaL_getmetatable(L, JOINT);
    lua_setmetatable(L, -2);
    return 1;
}

int l_join_gc(lua_State *L) {
    b2Joint *joint = l_joint_check(L, 1);
    if (joint) {
        //        luaL_unref(L, LUA_REGISTRYINDEX, joint->bodyRefA);
        //        luaL_unref(L, LUA_REGISTRYINDEX, joint->bodyRefB);
        //        world->DestroyJoint(joint);
    }
    return 0;
}

int l_joint(lua_State *L) {
    JointType jointType = lua_check(1, JointType, integer);

    b2Joint *joint = NULL;

    b2Body *bodyA = l_body_check(L, 2);
    b2Body *bodyB = l_body_check(L, 3);

    l_body_push(L, bodyA);
    int bodyRefA = luaL_ref(L, LUA_REGISTRYINDEX);

    l_body_push(L, bodyB);
    int bodyRefB = luaL_ref(L, LUA_REGISTRYINDEX);

    switch ( jointType ) {
        case REVOLUTE: {
            b2RevoluteJointDef revoluteJoint;
            revoluteJoint.Initialize(bodyA, bodyB, p2m(l_b2Vec2_get(L, 4)));
            joint = world->CreateJoint(&revoluteJoint);
            break;
        }
        case PRISMATIC: {
            b2PrismaticJointDef prismaticJoint;
            prismaticJoint.Initialize(bodyA, bodyB, p2m(l_b2Vec2_get(L, 4)), p2m(l_b2Vec2_get(L, 5)));
            joint = world->CreateJoint(&prismaticJoint);
            break;
        }
        case DISTANCE: {
            b2DistanceJointDef distanceJoint;
            distanceJoint.Initialize(bodyA, bodyB, p2m(l_b2Vec2_get(L, 4)), p2m(l_b2Vec2_get(L, 5)));
            joint = world->CreateJoint(&distanceJoint);
            break;
        }
        case WELD: {
            b2WeldJointDef weldDef;
            weldDef.Initialize(bodyA, bodyB, p2m(l_b2Vec2_get(L, 4)));
            joint = world->CreateJoint(&weldDef);
            break;
        }
        case ROPE: {
            b2RopeJointDef ropeDef;

            ropeDef.bodyA = bodyA;
            ropeDef.bodyB = bodyB;

            ropeDef.localAnchorA = ropeDef.bodyA->GetLocalPoint(p2m(l_b2Vec2_get(L, 4)));
            ropeDef.localAnchorB = ropeDef.bodyB->GetLocalPoint(p2m(l_b2Vec2_get(L, 5)));

            ropeDef.maxLength = p2m(luaL_checknumber(L, 6));

            joint = world->CreateJoint(&ropeDef);
            break;
        }
    }

    if (joint) {
        return l_joint_new(L, joint, bodyRefA, bodyRefB);
    }
    
    return 0;
}

b2Joint *l_joint_check(lua_State *L, int n) {
    return *(b2Joint **)luaL_checkudata(L, n, JOINT);
}

int l_joint_get(lua_State *L) {
    b2Joint *joint = l_joint_check(L, 1);

    const char *name = luaL_checkstring(L, 2);

    if (strcmp(name, "type") == 0 ) {
        lua_pushinteger(L, joint->GetType());
    }
    else if (strcmp(name, "bodyA") == 0 ) {
        l_body_push(L, joint->GetBodyA());
    }
    else if (strcmp(name, "bodyB") == 0 ) {
        l_body_push(L, joint->GetBodyB());
    }
    else if (strcmp(name, "anchorA") == 0 ) {
        l_b2Vec2_push(L, m2p(joint->GetAnchorA()));
    }
    else if (strcmp(name, "anchorB") == 0 ) {
        l_b2Vec2_push(L, m2p(joint->GetAnchorB()));
    }
    else if (strcmp(name, "reactionForce") == 0 ) {
        l_b2Vec2_push(L, m2p(joint->GetReactionForce(1./deltaTime)));
    }
    else if (strcmp(name, "reactionTorque") == 0 ) {
        lua_pushnumber(L, joint->GetReactionTorque(1./deltaTime));
    }
    else if (strcmp(name, "enableLimit") == 0 ) {
        switch (joint->GetType()) {
            case REVOLUTE:
                lua_pushboolean(L, ((b2RevoluteJoint*)joint)->IsLimitEnabled()?1:0);
                break;
            case PRISMATIC:
                lua_pushboolean(L, ((b2PrismaticJoint*)joint)->IsLimitEnabled()?1:0);
                break;
            default: break;
        }
    }
    else if (strcmp(name, "lowerLimit") == 0 ) {
        switch (joint->GetType()) {
            case REVOLUTE:
                lua_pushnumber(L, degree(((b2RevoluteJoint*)joint)->GetLowerLimit()));
                break;
            case PRISMATIC:
                lua_pushnumber(L, m2p(((b2PrismaticJoint*)joint)->GetLowerLimit()));
                break;
            default: break;
        }
    }
    else if (strcmp(name, "upperLimit") == 0 ) {
        switch (joint->GetType()) {
            case REVOLUTE:
                lua_pushnumber(L, degree(((b2RevoluteJoint*)joint)->GetUpperLimit()));
                break;
            case PRISMATIC:
                lua_pushnumber(L, m2p(((b2PrismaticJoint*)joint)->GetUpperLimit()));
                break;
            default: break;
        }
    }
    else if (strcmp(name, "enableMotor") == 0 ) {
        switch (joint->GetType()) {
            case REVOLUTE:
                lua_pushboolean(L, ((b2RevoluteJoint*)joint)->IsMotorEnabled()?1:0);
                break;
            case PRISMATIC:
                lua_pushboolean(L, ((b2PrismaticJoint*)joint)->IsMotorEnabled()?1:0);
                break;
            default: break;
        }
    }
    else if (strcmp(name, "motorSpeed") == 0 ) {
        switch (joint->GetType()) {
            case REVOLUTE:
                lua_pushnumber(L, degree(((b2RevoluteJoint*)joint)->GetMotorSpeed()));
                break;
            case PRISMATIC:
                lua_pushnumber(L, m2p(((b2PrismaticJoint*)joint)->GetMotorSpeed()));
                break;
            default: break;
        }
    }
    else if (strcmp(name, "maxMotorTorque") == 0 ) {
        switch (joint->GetType()) {
            case REVOLUTE:
                lua_pushnumber(L, ((b2RevoluteJoint*)joint)->GetMaxMotorTorque());
                break;
            default: break;
        }
    }
    else if (strcmp(name, "maxMotorForce") == 0 ) {
        switch (joint->GetType()) {
            case PRISMATIC:
                lua_pushnumber(L, m2p(((b2PrismaticJoint*)joint)->GetMaxMotorForce()));
                break;
            default: break;
        }
    }
    else if (strcmp(name, "length") == 0 ) {
        switch (joint->GetType()) {
            case DISTANCE:
                lua_pushnumber(L, m2p(((b2DistanceJoint*)joint)->GetLength()));
                break;
            default: break;
        }
    }
    else if (strcmp(name, "frequency") == 0 ) {
        switch (joint->GetType()) {
            case DISTANCE:
                lua_pushnumber(L, ((b2DistanceJoint*)joint)->GetFrequency());
                break;
            case WELD:
                lua_pushnumber(L, ((b2WeldJoint*)joint)->GetFrequency());
                break;
            default: break;
        }
    }
    else if (strcmp(name, "dampingRatio") == 0 ) {
        switch (joint->GetType()) {
            case DISTANCE:
                lua_pushnumber(L, ((b2DistanceJoint*)joint)->GetDampingRatio());
                break;
            case WELD:
                lua_pushnumber(L, ((b2WeldJoint*)joint)->GetDampingRatio());
                break;
            default: break;
        }
    }
    else if (strcmp(name, "maxLength") == 0 ) {
        switch (joint->GetType()) {
            case ROPE:
                lua_pushnumber(L, m2p(((b2RopeJoint*)joint)->GetMaxLength()));
                break;
            default: break;
        }
    } else {
        luaL_getmetatable(L, JOINT);
        lua_pushstring(L, name);
        lua_gettable(L, -2);
    }

    return 1;
}

int l_joint_set(lua_State *L) {
    b2Joint *joint = l_joint_check(L, 1);

    const char *name = luaL_checkstring(L, 2);

    if (strcmp(name, "type") == 0 ) {
        // read only
    }
    else if (strcmp(name, "bodyA") == 0 ) {
        // read only
    }
    else if (strcmp(name, "bodyB") == 0 ) {
        // read only
    }
    else if (strcmp(name, "anchorA") == 0 ) {
        // read only
    }
    else if (strcmp(name, "anchorB") == 0 ) {
        // read only
    }
    else if (strcmp(name, "reactionForce") == 0 ) {
        // read only
    }
    else if (strcmp(name, "reactionTorque") == 0 ) {
        // read only
    }
    else if (strcmp(name, "enableLimit") == 0 ) {
        switch (joint->GetType()) {
            case REVOLUTE:
                ((b2RevoluteJoint*)joint)->EnableLimit(luaL_checkboolean(L, 3));
                break;
            case PRISMATIC:
                ((b2PrismaticJoint*)joint)->EnableLimit(luaL_checkboolean(L, 3));
                break;
            default: break;
        }
    }
    else if (strcmp(name, "lowerLimit") == 0 ) {
        switch (joint->GetType()) {
            case REVOLUTE:
                ((b2RevoluteJoint*)joint)->SetLimits(radian(luaL_checknumber(L, 3)), ((b2RevoluteJoint*)joint)->GetUpperLimit());
                break;
            case PRISMATIC:
                ((b2PrismaticJoint*)joint)->SetLimits(p2m(luaL_checknumber(L, 3)), ((b2RevoluteJoint*)joint)->GetUpperLimit());
                break;
            default: break;
        }
    }
    else if (strcmp(name, "upperLimit") == 0 ) {
        switch (joint->GetType()) {
            case REVOLUTE:
                ((b2RevoluteJoint*)joint)->SetLimits(((b2RevoluteJoint*)joint)->GetLowerLimit(), radian(luaL_checknumber(L, 3)));
                break;
            case PRISMATIC:
                ((b2PrismaticJoint*)joint)->SetLimits(((b2RevoluteJoint*)joint)->GetLowerLimit(), p2m(luaL_checknumber(L, 3)));
                break;
            default: break;
        }
    }
    else if (strcmp(name, "enableMotor") == 0 ) {
        switch (joint->GetType()) {
            case REVOLUTE:
                ((b2RevoluteJoint*)joint)->EnableMotor(luaL_checkboolean(L, 3));
                break;
            case PRISMATIC:
                ((b2PrismaticJoint*)joint)->EnableMotor(luaL_checkboolean(L, 3));
                break;
            default: break;
        }
    }
    else if (strcmp(name, "motorSpeed") == 0 ) {
        switch (joint->GetType()) {
            case REVOLUTE:
                ((b2RevoluteJoint*)joint)->SetMotorSpeed(radian(luaL_checknumber(L, 3)));
                break;
            case PRISMATIC:
                ((b2PrismaticJoint*)joint)->SetMotorSpeed(p2m(luaL_checknumber(L, 3)));
                break;
            default: break;
        }
    }
    else if (strcmp(name, "maxMotorTorque") == 0 ) {
        switch (joint->GetType()) {
            case REVOLUTE:
                ((b2RevoluteJoint*)joint)->SetMaxMotorTorque(luaL_checknumber(L, 3));
                break;
            default: break;
        }
    }
    else if (strcmp(name, "maxMotorForce") == 0 ) {
        switch (joint->GetType()) {
            case PRISMATIC:
                ((b2PrismaticJoint*)joint)->SetMaxMotorForce(p2m(luaL_checknumber(L, 3)));
                break;
            default: break;
        }
    }
    else if (strcmp(name, "length") == 0 ) {
        switch (joint->GetType()) {
            case DISTANCE:
                ((b2DistanceJoint*)joint)->SetLength(p2m(luaL_checknumber(L, 3)));
                break;
            default: break;
        }
    }
    else if (strcmp(name, "frequency") == 0 ) {
        switch (joint->GetType()) {
            case DISTANCE:
                ((b2DistanceJoint*)joint)->SetFrequency(luaL_checknumber(L, 3));
                break;
            case WELD:
                ((b2WeldJoint*)joint)->SetFrequency(luaL_checknumber(L, 3));
                break;
            default: break;
        }
    }
    else if (strcmp(name, "dampingRatio") == 0 ) {
        switch (joint->GetType()) {
            case DISTANCE:
                ((b2DistanceJoint*)joint)->SetDampingRatio(luaL_checknumber(L, 3));
                break;
            case WELD:
                ((b2WeldJoint*)joint)->SetDampingRatio(luaL_checknumber(L, 3));
                break;
            default: break;
        }
    }
    else if (strcmp(name, "maxLength") == 0 ) {
        switch (joint->GetType()) {
            case ROPE:
                ((b2RopeJoint*)joint)->SetMaxLength(p2m(luaL_checknumber(L, 3)));
                break;
            default: break;
        }
    } else {
        luaL_getmetatable(L, JOINT);
        lua_pushstring(L, name);
        lua_gettable(L, -2);
    }

    return 0;
}

// functions
static const luaL_Reg jointFunctions[] = {
    { "__gc", l_join_gc },

    { "__index", l_joint_get },
    { "__newindex", l_joint_set },

    { NULL, NULL }
};

void register_joint(lua_State *L) {
    luaL_newmetatable(L, JOINT);
    luaL_setfuncs(L, jointFunctions, 0);

    lua_pushstring(L, "joint");
    lua_setfield(L, -2, "className");
}