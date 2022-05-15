//
//  matrix.cpp
//  Lca
//
//  Created by lca pro on 18/01/2016.
//  Copyright © 2016 lca. All rights reserved.
//

#include "vector.hpp"
#include "matrix.hpp"
#include "graphics.hpp"

#define MATRIX "luaL_matrix"

#include "glm/glm.hpp"
#include "glm/gtc/matrix_transform.hpp"
#include "glm/gtc/type_ptr.hpp"

#include <list>
#include <vector>
#include <stack>

inline int ref(int l, int c) {
    return l * 4 + c;
}

Float *matrix_new(lua_State *L) {
    Float *m = (Float*)lua_newuserdata(L, sizeof(Float)*16);
//    Float *m = new Float[16];
    memset(m, 0, sizeof(Float)*16);
    m[0] = m[5] = m[10] = m[15] = 1.0;

//    lua_pushlightuserdata(L, m);
    luaL_getmetatable(L, MATRIX);
    lua_setmetatable(L, -2);

    return m;
}

void matrix_delete(Float *m) {
    if (m) {
        //delete [] m;
    }
}

int l_matrix_push(lua_State *L, Float *data=NULL) {
    int n = narg(L);

    Float *m = matrix_new(L);

    if (data) {
        memcpy(m, data, sizeof(Float)*16);
    }
    else {
        if (n == 1 && l_matrix_test(L, 1)) {
            Float *m2 = l_matrix_check(L, 1);
            memcpy(m, m2, sizeof(Float)*16);
        }
        else if (n > 0) {
            for (int i = 0; i < n; ++i) {
                m[i] = lua_option(i+1, Float, number, 0.0);
            }
        }
    }

    return 1;
}

int l_matrix_create(lua_State *L) {
    return l_matrix_push(L);
}

int l_matrix_gc(lua_State *L) {
    Float *m = l_matrix_check(L, 1);
    matrix_delete(m);
    return 0;
}

int l_matrix_eq(lua_State *L) {
    Float *m1 = l_matrix_check(L, 1);
    Float *m2 = l_matrix_check(L, 2);

    if (m1 == NULL || m2 == NULL) {
        return 0;
    }

    for (int i = 0; i < 16; ++i) {
        if (m1[i] != m2[i]) {
            return 0;
        }
    }

    lua_pushboolean(L, true);
    return 1;
}

int l_matrix_tostring(lua_State *L) {
    Float *v = l_matrix_check(L, 1);

    char str[256];
    sprintf(str, "%f, %f, %f, %f\n%f, %f, %f, %f\n%f, %f, %f, %f\n%f, %f, %f, %f\n",
            v[ 0], v[ 1], v[ 2], v[ 3],
            v[ 4], v[ 5], v[ 6], v[ 7],
            v[ 8], v[ 9], v[10], v[11],
            v[12], v[13], v[14], v[15]);
    lua_pushstring(L, str);
    return 1;
}

Float *l_matrix_check(lua_State *L, int n) {
    return (Float *)luaL_checkudata(L, n, MATRIX);
}

Float *l_matrix_test(lua_State *L, int n) {
    return (Float *)luaL_testudata(L, n, MATRIX);
}

int l_matrix_get(lua_State *L) {
    Float *v = l_matrix_check(L, 1);

    bool isnumber = lua_isnumber(L, 2);
    if (isnumber) {
        int i = luaL_checkinteger(L, 2);
        lua_pushnumber(L, v[i-1]);
    }
    else {
        const char* name = luaL_checkstring(L, 2);
        luaL_getmetatable(L, MATRIX);
        lua_pushstring(L, name);
        lua_gettable(L, -2);
    }

    return 1;
}

int l_matrix_set(lua_State *L) {
    Float *v = l_matrix_check(L, 1);

    int i = luaL_checkinteger(L, 2);
    v[i-1] = luaL_checknumber(L, 3);

    return 1;
}

int matrix_mul(Float *m1, Float *m2, Float *res, int cmax=4) {
    for (int l = 0; l < 4; ++l) {
        for (int c = 0; c < cmax; ++c) {
            Float val = 0.;

            if (cmax == 4) {
                for (int i = 0 ; i < 4; ++i) {
                    val += m1[ref(l, i)] * m2[ref(i, c)];
                }

                res[ref(l, c)] = val;
            }
            else if (cmax == 1) {
                for (int i = 0 ; i < 4; ++i) {
                    if (i < 3)
                        val += m1[ref(l, i)] * m2[i];
                    else
                        val += m1[ref(l, i)] * 1;
                }

                res[l] = val;
            }
        }
    }

    return 1;
}

Float *l_matrix_mul(lua_State *L, int i, int n, Float *m1) {
    Float *m2 = l_matrix_test(L, i+1);

    if (m2) {
        Float *res = matrix_new(L);
        matrix_mul(m1, m2, res, 4);
        return res;
    }

    Float *v = l_vector_test(L, i+1);

    if (v) {
        Float *res = vector_new(L);
        matrix_mul(m1, v, res, 1);
        return res;
    }

    return NULL;
}

int l_matrix_mul(lua_State *L) {
    int n = narg(L);
    Float *m1 = l_matrix_check(L, 1);
    l_matrix_mul(L, 1, n, m1);

    return 1;
}

int matrix_scale(Float *m, Float *v, Float *res) {
    for (int l = 0; l < 4; ++l) {
        for (int c = 0; c < 4; ++c) {
            res[ref(l, c)] = m[ref(l, c)] * v[l];
        }
    }

    return 1;
}

Float *l_matrix_scale(lua_State *L, int i, int n, Float *m) {
    Float v[4] = {1.0, 1.0, 1.0, 1.0};

    switch (n-i) {
        case 3:
            v[2] = luaL_checknumber(L, i+3);
        case 2:
            v[0] = luaL_checknumber(L, i+1);
            v[1] = luaL_checknumber(L, i+2);
            break;

        case 1:
            v[0] = v[1] = v[2] = luaL_checknumber(L, i+1);
            break;

        default:
            break;
    }

    Float *res = matrix_new(L);
    matrix_scale(m, v, res);

    return res;
}

int l_matrix_scale(lua_State *L) {
    int n = narg(L);
    Float *m = l_matrix_check(L, 1);
    l_matrix_scale(L, 1, n, m);
    return 1;
}

Float *l_matrix_rotate(lua_State *L, int i, int n, Float *m) {
    lua_Number angle = luaL_checknumber(L, i+1);

    lua_Integer x = luaL_optinteger(L, i+2, 0);
    lua_Integer y = luaL_optinteger(L, i+3, 0);
    lua_Integer z = luaL_optinteger(L, i+4, 1);

    Float cos = cosf(radian(angle));
    Float sin = sinf(radian(angle));

    Float *res = matrix_new(L);

    if (x == 1) {
        Float rotation[16] = {
            1,0,0,0,
            0,cos,-sin,0,
            0,sin,cos,0,
            0,0,0,1};
        matrix_mul(m, rotation, res);
    }
    else if (y == 1) {
        Float rotation[16] = {
            cos,0,sin,0,
            0,1,0,0,
            -sin,0,cos,0,
            0,0,0,1};
        matrix_mul(m, rotation, res);
    }
    else if (z == 1) {
        Float rotation[16] = {
            cos,-sin,0,0,
            sin,cos,0,0,
            0,0,1,0,
            0,0,0,1};
        matrix_mul(m, rotation, res);
    }

    return res;
}

int l_matrix_rotate(lua_State *L) {
    int n = narg(L);
    Float *m = l_matrix_check(L, 1);
    l_matrix_rotate(L, 1, n, m);
    return 1;
}

int matrix_translate(Float *m, Float *v, Float *res) {
    memcpy(res, m, sizeof(Float)*16);

    res[ref(0, 3)] += v[0];
    res[ref(1, 3)] += v[1];
    res[ref(2, 3)] += v[2];

    return 1;
}

Float *l_matrix_translate(lua_State *L, int i, int n, Float *m) {
    Float v[3] = {0.0, 0.0, 0.0};

    switch (n-i) {
        case 3:
            v[2] = luaL_optnumber(L, i+3, 0.0);
        case 2:
            v[0] = luaL_checknumber(L, i+1);
            v[1] = luaL_checknumber(L, i+2);
            break;

        case 1:
            v[0] = v[1] = v[2] = luaL_checknumber(L, i+1);
            break;

        default:
            break;
    }

    Float *res = matrix_new(L);
    matrix_translate(m, v, res);
    
    return res;
}

int l_matrix_translate(lua_State *L) {
    int n = narg(L);
    Float *m = l_matrix_check(L, 1);
    l_matrix_translate(L, 1, n, m);
    return 1;
}

int l_matrix(lua_State *L, Float *m, Float *&matrix, int &idx) {
    bool param = false;
    if (m == NULL) {
        m = l_matrix_test(L, 1);
        param = true;
    }

    if (m) {
        if (idx) {
            luaL_unref(L, LUA_REGISTRYINDEX, idx);
        }

        matrix = m;
        if (param) {
            lua_pushvalue(L, 1);
        }
/*        else {
            lua_pushvalue(L, -1);
        }*/
        idx = luaL_ref(L, LUA_REGISTRYINDEX);
    }
    else {
        if (matrix == NULL) {
            matrix = matrix_new(L);
        }
        else {
            Float *m = matrix_new(L);
            memcpy(m, matrix, sizeof(Float)*16);
            matrix = m;

            //lua_pushlightuserdata(L, matrix);
            //luaL_getmetatable(L, MATRIX);
            //lua_setmetatable(L, -2);
        }
        return 1;
    }

    return 0;
}

static Float *viewMatrix = NULL;
static int idx_vm = 0;
int l_viewMatrix(lua_State *L) {
    return l_matrix(L, NULL, viewMatrix, idx_vm);
}

static Float *projectionMatrix = NULL;
static int idx_pm = 0;
int l_projectionMatrix(lua_State *L) {
    return l_matrix(L, NULL, projectionMatrix, idx_pm);
}

static Float *modelMatrix = NULL;
static int idx_mm = 0;
int l_modelMatrix(lua_State *L) {
    return l_matrix(L, NULL, modelMatrix, idx_mm);
}

std::stack<void*> test;

int l_pushMatrix(lua_State *L) {
    Float *m = matrix_new(L);
    memcpy(m, modelMatrix, sizeof(Float)*16);
    test.push(modelMatrix);
    return l_matrix(L, m, modelMatrix, idx_mm);
}

int l_popMatrix(lua_State *L) {
    Float *m = (Float*)test.top();
    test.pop();
    return l_matrix(L, m, modelMatrix, idx_mm);
}

int l_resetMatrix(lua_State *L) {
    if (modelMatrix) {
        memset(modelMatrix, 0, sizeof(Float)*16);
        modelMatrix[0] = modelMatrix[5] = modelMatrix[10] = modelMatrix[15] = 1.0;
    }
    return 0;
}

int l_translate(lua_State *L) {
    int n = narg(L);
    Float *res = l_matrix_translate(L, 0, n, modelMatrix);
    l_matrix(L, res, modelMatrix, idx_mm);
    return 0;
}

int l_rotate(lua_State *L) {
    int n = narg(L);
    Float *res = l_matrix_rotate(L, 0, n, modelMatrix);
    l_matrix(L, res, modelMatrix, idx_mm);
    return 0;
}

int l_scale(lua_State *L) {
    int n = narg(L);
    Float *res = l_matrix_scale(L, 0, n, modelMatrix);
    l_matrix(L, res, modelMatrix, idx_mm);
    return 0;
}

int l_applyMatrix(lua_State *L) {
    int n = narg(L);
    Float *res = l_matrix_mul(L, 0, n, modelMatrix);
    l_matrix(L, res, modelMatrix, idx_mm);
    return 0;
}

int l_ortho(lua_State *L) {
    lua_Number l = luaL_optnumber(L, 1, 0);
    lua_Number r = luaL_optnumber(L, 2, WIDTH);

    lua_Number b = luaL_optnumber(L, 3, 0);
    lua_Number t = luaL_optnumber(L, 4, HEIGHT);

    lua_Number n = luaL_optnumber(L, 5, -10);
    lua_Number f = luaL_optnumber(L, 6, +10);

    memset(projectionMatrix, 0, sizeof(Float)*16);

    projectionMatrix[ 0] =  2./(r-l);
    projectionMatrix[ 5] =  2./(t-b);
    projectionMatrix[10] = -2./(f-n);

    projectionMatrix[ 3] = -(r+l)/(r-l);
    projectionMatrix[ 7] = -(t+b)/(t-b);
    projectionMatrix[11] = -(f+n)/(f-n);

    projectionMatrix[15] = 1;

    return 0;
}

int l_perspective(lua_State *L) {
    lua_Number fovy = luaL_optnumber(L, 1, 45);

    lua_Number aspect = luaL_optnumber(L, 2, WIDTH/HEIGHT);

    lua_Number zNear = luaL_optnumber(L, 3, 0.1);
    lua_Number zFar = luaL_optnumber(L, 4, 2000);

    lua_Number range = tan(fovy / 2.) * zNear;

    lua_Number left = -range * aspect;
    lua_Number right = range * aspect;

    lua_Number bottom = -range;
    lua_Number top = range;

    memset(projectionMatrix, 0, sizeof(Float)*16);

    projectionMatrix[ 0] = (2 * zNear) / (right - left);
    projectionMatrix[ 5] = (2 * zNear) / (top - bottom);

    projectionMatrix[10] = -(    zFar + zNear) / (zFar - zNear);
    projectionMatrix[11] = -(2 * zFar * zNear) / (zFar - zNear);

    projectionMatrix[14] = -1;

    return 0;
}

luaL_Reg matrixMethods[] = {
//    { "__call", l_matrix_create },
    { "__gc", l_matrix_gc },

    { "__tostring", l_matrix_tostring },
    { "__index", l_matrix_get },
    { "__newindex", l_matrix_set },
    { "__mul", l_matrix_mul },
    { "__eq", l_matrix_eq },

    { "scale", l_matrix_scale },
    { "rotate", l_matrix_rotate },
    { "translate", l_matrix_translate },

    { NULL, NULL }
};

luaL_Reg matrixFunctions[] = {
    { "viewMatrix", l_viewMatrix },
    { "projectionMatrix", l_projectionMatrix },
    { "modelMatrix", l_modelMatrix },

    { "pushMatrix", l_pushMatrix },
    { "popMatrix", l_popMatrix },
    { "resetMatrix", l_resetMatrix },

    { "translate", l_translate },
    { "rotate", l_rotate },
    { "scale", l_scale },
    { "applyMatrix", l_applyMatrix },
    { "ortho", l_ortho },
    { "perspective", l_perspective },

    { NULL, NULL }
};

void register_matrix(lua_State *L, const char *name) {
//    lua_pushcfunction(L, l_matrix_create);
//    lua_setglobal(L, "matrix");

    register_lib(L, matrixFunctions, NULL);

//    lua_newtable(L);

    luaL_newmetatable(L, MATRIX);
    luaL_openlib(L, NULL, matrixMethods, 0);

    lua_register(L, "matrix", l_matrix_create);

    viewMatrix = matrix_new(L);
    projectionMatrix = matrix_new(L);
    modelMatrix = matrix_new(L);

/*    lua_pushstring(L, "matrix");
    lua_setfield(L, -2, "className");

    lua_setmetatable(L, -2);
*/

}
