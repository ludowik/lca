// OpenGL


#include "ogl.hpp"
#include "tools.hpp"
#include "matrix.hpp"

// tools
void print(const char* string, ...) {
    va_list args;
    va_start(args, string);
    vfprintf(stderr, string, args);
    fprintf(stderr, "\n");
    fflush(stderr);
}

// functions
#define def1enum(name) \
static int l_##name(lua_State *L) { \
    GLenum v = (GLenum)luaL_checkunsigned(L, 1); \
    name(v); \
    return 0; \
}

#define def2enum(name) \
static int l_##name(lua_State *L) { \
    GLenum v1 = (GLenum)luaL_checkunsigned(L, 1); \
    GLenum v2 = (GLenum)luaL_checkunsigned(L, 2); \
    name(v1, v2); \
    return 0; \
}

def1enum(glEnable);

def1enum(glDepthFunc);
def1enum(glFrontFace);
def1enum(glCullFace);

def1enum(glActiveTexture);
def1enum(glGenerateMipmap);
def2enum(glBlendFunc);

static int l_glGetString(lua_State *L) {
    GLenum name = (GLenum)luaL_checkunsigned(L, 1);
    lua_pushstring(L, (const char*)glGetString(name));
    return 0;
}

// FrameBuffer

static int l_glGenFramebuffer(lua_State *L) {
    GLuint ids[1];
    glGenFramebuffers(1, ids);
    lua_pushunsigned(L, ids[0]);
    return 1;
}

static int l_glDeleteFramebuffer(lua_State *L) {
    GLuint ids[1];
    ids[0] = (GLuint)luaL_checkunsigned(L, 1);
    glDeleteFramebuffers(1, ids);
    return 0;
}

static int l_glIsFramebuffer(lua_State *L) {
    GLenum id = (GLenum)luaL_checkunsigned(L, 1);
    lua_pushunsigned(L, glIsFramebuffer(id));
    return 1;
}

static int l_glBindFramebuffer(lua_State *L) {
    GLenum target = (GLenum)luaL_checkunsigned(L, 1);
    GLuint framebuffer = (GLuint)luaL_checkunsigned(L, 2);
    glBindFramebuffer(target, framebuffer);
    return 0;
}

static int l_glFramebufferRenderbuffer(lua_State *L) {
    GLenum target = (GLenum)luaL_checkunsigned(L, 1);
    GLenum attachment = (GLenum)luaL_checkunsigned(L, 2);
    GLenum renderbuffertarget = (GLenum)luaL_checkunsigned(L, 3);
    GLuint renderbuffer = (GLuint)luaL_checkunsigned(L, 4);
    glFramebufferRenderbuffer(target, attachment, renderbuffertarget, renderbuffer);
    return 0;
}

static int l_glFramebufferTexture(lua_State *L) {
    GLenum target = (GLenum)luaL_checkunsigned(L, 1);
    GLenum attachment = (GLenum)luaL_checkunsigned(L, 2);
    GLuint texture = (GLuint)luaL_checkunsigned(L, 3);
    GLint level = (GLint)luaL_checkinteger(L, 4);
    glFramebufferTexture(target, attachment, texture, level);
    return 0;
}

static int l_glDrawBuffer(lua_State *L) {
    GLsizei n = 1;
    GLenum bufs[1];
    bufs[0] = (GLenum)luaL_checkunsigned(L, 1);
    glDrawBuffers(n, bufs);
    return 0;
}

static int l_glCheckFramebufferStatus(lua_State *L) {
    GLenum target = (GLenum)luaL_checkunsigned(L, 1);
    GLenum res = glCheckFramebufferStatus(target);
    lua_pushunsigned(L, res);
    return 1;
}

// RenderBuffer

static int l_glGenRenderbuffer(lua_State *L) {
    GLuint ids[1];
    glGenRenderbuffers(1, ids);
    lua_pushunsigned(L, ids[0]);
    return 1;
}

static int l_glDeleteRenderbuffer(lua_State *L) {
    GLuint ids[1];
    ids[0] = (GLuint)luaL_checkunsigned(L, 1);
    glDeleteRenderbuffers(1, ids);
    return 0;
}

static int l_glIsRenderbuffer(lua_State *L) {
    GLenum id = (GLenum)luaL_checkunsigned(L, 1);
    lua_pushunsigned(L, glIsRenderbuffer(id));
    return 1;
}

static int l_glBindRenderbuffer(lua_State *L) {
    GLenum target = (GLenum)luaL_checkunsigned(L, 1);
    GLuint renderbuffer = (GLuint)luaL_checkunsigned(L, 2);
    glBindRenderbuffer(target, renderbuffer);
    return 0;
}

static int l_glRenderbufferStorage(lua_State *L) {
    GLenum target = (GLenum)luaL_checkunsigned(L, 1);
    GLenum internalformat = (GLenum)luaL_checkunsigned(L, 2);
    GLsizei width = (GLsizei)luaL_checkinteger(L, 3);
    GLsizei height = (GLsizei)luaL_checkinteger(L, 4);
    glRenderbufferStorage(target, internalformat, width, height);
    return 0;
}

// Texture

static int l_glGenTexture(lua_State *L) {
    GLuint ids[1];
    glGenTextures(1, ids);
    lua_pushunsigned(L, ids[0]);
    return 1;
}

static int l_glDeleteTexture(lua_State *L) {
    GLuint ids[1];
    ids[0] = (GLuint)luaL_checkunsigned(L, 1);
    glDeleteTextures(1, ids);
    return 0;
}

static int l_glIsTexture(lua_State *L) {
    GLenum id = (GLenum)luaL_checkunsigned(L, 1);
    lua_pushunsigned(L, glIsTexture(id));
    return 1;
}

static int l_glBindTexture(lua_State *L) {
    GLenum target = (GLenum)luaL_checkunsigned(L, 1);
    GLuint texture = (GLuint)luaL_checkunsigned(L, 2);
    glBindTexture(target, texture);
    return 0;
}

static int l_glTexImage2D(lua_State *L) {
    int i = 1;
    GLenum target = (GLenum)luaL_checkunsigned(L, i++);
    GLint level = (GLint)luaL_checkinteger(L, i++);
    GLint internalformat = (GLint)luaL_checkinteger(L, i++);
    GLsizei width = (GLsizei)luaL_checkinteger(L, i++);
    GLsizei height = (GLsizei)luaL_checkinteger(L, i++);
    GLint border = (GLint)luaL_checkinteger(L, i++);
    GLenum format = (GLenum)luaL_checkunsigned(L, i++);
    GLenum type = (GLenum)luaL_checkunsigned(L, i++);
    const GLvoid *pixels = (const GLvoid *)luaL_checkunsigned(L, i++);
    glTexImage2D(target, level, internalformat, width, height, border, format, type, pixels);
    return  0;
}

static int l_glTexParameteri(lua_State *L) {
    GLenum target = (GLenum)luaL_checkunsigned(L, 1);
    GLenum pname = (GLenum)luaL_checkunsigned(L, 2);
    GLint param = (GLint)luaL_checkinteger(L, 3);
    glTexParameteri(target, pname, param);
    return 0;
}

// Shader

static int l_glCreateShader(lua_State *L) {
    GLenum type = (GLenum)luaL_checkunsigned(L, 1);
    lua_pushunsigned(L, glCreateShader(type));
    return 1;
}

static int l_glDeleteShader(lua_State *L) {
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    glDeleteShader(id);
    return 0;
}

static int l_glIsShader(lua_State *L) {
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    lua_pushunsigned(L, glIsShader(id));
    return 1;
}

static int l_glShaderSource(lua_State *L) {
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    const GLchar *string[1];
    string[0] = (const GLchar *)luaL_checkstring(L, 2);
    GLint length = -1;
    glShaderSource(id, 1, string, &length);
    return 0;
}

static int l_glCompileShader(lua_State *L) {
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    glCompileShader(id);
    return 0;
}

static int l_glGetShaderiv(lua_State *L) {
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    GLenum pname = (GLenum)luaL_checkunsigned(L, 2);
    GLint params = 0;
    glGetShaderiv(id, pname, &params);
    lua_pushinteger(L, params);
    return 1;
}

static int l_glGetShaderInfoLog(lua_State *L) {
    static GLchar infoLog[1024];
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    GLint len = 0;
    glGetShaderiv(id, GL_INFO_LOG_LENGTH, &len);
    glGetShaderInfoLog(id, len, &len, infoLog);
    lua_pushlstring(L, infoLog, len);
    return 1;
}

static int l_glAttachShader(lua_State *L) {
    GLuint program = (GLuint)luaL_checkunsigned(L, 1);
    GLuint shader = (GLuint)luaL_checkunsigned(L, 2);
    glAttachShader(program, shader);
    return 0;
}

// Program

static int l_glCreateProgram(lua_State *L) {
    lua_pushunsigned(L, glCreateProgram());
    return 1;
}

static int l_glDeleteProgram(lua_State *L) {
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    glDeleteProgram(id);
    return 0;
}

static int l_glIsProgram(lua_State *L) {
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    lua_pushunsigned(L, glIsProgram(id));
    return 1;
}

static int l_glGetUniformLocation(lua_State *L) {
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    GLchar *name = (GLchar *)luaL_checkstring(L, 2);
    lua_pushinteger(L, glGetUniformLocation(id, name));
    return 1;
}

static int l_glBindAttribLocation(lua_State *L) {
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    GLuint index = (GLuint)luaL_checkunsigned(L, 2);
    GLchar *name = (GLchar *)luaL_checkstring(L, 3);
    glBindAttribLocation(id, index, name);
    return 0;
}

static int l_glLinkProgram(lua_State *L) {
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    glLinkProgram(id);
    return 0;
}

static int l_glGetProgramiv(lua_State *L) {
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    GLenum pname = (GLenum)luaL_checkunsigned(L, 2);
    GLint params = 0;
    glGetProgramiv(id, pname, &params);
    lua_pushinteger(L, params);
    return 1;
}

static int l_glGetProgramInfoLog(lua_State *L) {
    static GLchar infoLog[1024];
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    GLint len = 0;
    glGetProgramiv(id, GL_INFO_LOG_LENGTH, &len);
    glGetProgramInfoLog(id, len, NULL, infoLog);
    lua_pushlstring(L, infoLog, len);
    return 1;
}

static int l_glUseProgram(lua_State *L) {
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    glUseProgram(id);
    return 0;
}

typedef void (*totype)(lua_State *, int *, void *);

static void tonumber(lua_State *L, int *i, void *data) {
    ((GLfloat*)data)[*i] = (GLfloat)lua_tonumber(L, -1);
    *i = *i+1;
}

static void tounsigned(lua_State *L, int *i, void *data) {
    ((GLushort*)data)[*i] = (GLushort)lua_tonumber(L, -1);
    *i = *i+1;
}

typedef void (*pushtype)(lua_State *, int, const void *);

static void pushnumber(lua_State *L, int i, const void *data) {
    lua_pushnumber(L, ((GLfloat*)data)[i]);
}

/*static void pushunsigned(lua_State *L, int i, const void *data) {
    lua_pushnumber(L, ((GLushort*)data)[i]);
}
*/

static void l_glUniformCoord(lua_State *L, int narg, const char *field, const char *field2, int *i, void *data, totype f) {
    lua_getfield(L, narg, field);
    if ( lua_isnil(L, -1) == 1 ) {
        lua_pop(L, 1);
        field = field2;
        lua_getfield(L, narg, field);
    }

    f(L, i, data);

    lua_pop(L, 1);
}

static void l_glUniformVector(lua_State *L, int narg, int ncoords, int *i, void *data, totype f) {
    l_glUniformCoord(L, narg, "x", "r", i, data, f);
    if ( ncoords > 1 ) {
        l_glUniformCoord(L, narg, "y", "g", i, data, f);
    }
    if ( ncoords > 2 ) {
        l_glUniformCoord(L, narg, "z", "b", i, data, f);
    }
    if ( ncoords > 3 ) {
        l_glUniformCoord(L, narg, "w", "a", i, data, f);
    }
}

static void* l_glUniformv(lua_State *L, int narg, int count, int nelems, int ncoords, int sizecoord, totype f) {
    void *data = NULL;

    // Push another reference to the table on top of the stack (so we know
    // where it is, and this function can work for negative, positive and
    // pseudo indices
    lua_pushvalue(L, narg);
    if ( lua_isnil(L, -1) == 0 ) {
        size_t size = count * nelems * ncoords * sizecoord;

        data = (void*)malloc(size);
        memset(data, 0, size);

        int i = 0;

        // stack now contains: -1 => table
        if ( lua_istable(L, -1) == 1 ) {
            lua_pushnil(L);
            // stack now contains: -1 => nil; -2 => table
            for (int j = 0; j < nelems; ++j) {
                lua_next(L, -2);
                // stack now contains: -1 => value; -2 => key; -3 => table
                // copy the key so that lua_tostring does not modify the original

                if ( lua_istable(L, -1) == 1 || lua_isuserdata(L, -1) == 1 ) {
                    l_glUniformVector(L, -1, ncoords, &i, data, f);
                }
                else {
                    f(L, &i, data);
                }

                // pop value, leaving original key
                lua_pop(L, 1);
                // stack now contains: -1 => key; -2 => table
                }
        } else {
            f(L, &i, data);
        }
    }
    // stack now contains: -1 => table (when lua_next returns 0 it pops the key
    // but does not push anything.)
    // Pop table
    lua_pop(L, 1);
    // Stack is now the same as it was on entry to this function

    return data;
}

static void *l_glUniformfv(lua_State *L, int narg, int count, int nelems, int ncoords) {
    return l_glUniformv(L, narg, count, nelems, ncoords, sizeof(GLfloat), tonumber);
}

static void *l_glUniformiv(lua_State *L, int narg, int count, int nelems, int ncoords) {
    return l_glUniformv(L, narg, count, nelems, ncoords, sizeof(GLushort), tounsigned);
}

static int l_glData(lua_State *L, int n, const void *data, pushtype f) {
    lua_newtable(L);
    for (int i = 0; i < n; i++) {
        f(L, i, data);
        lua_rawseti(L, -2, i + 1);
    }

    return 1;
}

static int l_glUniformMatrix4fv(lua_State *L) {
    GLint location = (GLint)luaL_checkinteger(L, 1);
    GLsizei count = (GLsizei)luaL_checkinteger(L, 2);
    GLboolean transpose = (GLboolean)luaL_checkunsigned(L, 3);
    const Float *value;
    if (lua_istable(L, 4) == 1) {
        value = (const Float *)l_glUniformfv(L, 4, count, 16, 1);
    }
    else {
        value = (const Float *)l_matrix_check(L, 4);
    }
    glUniformMatrix4fv(location, count, transpose, value);
    return l_glData(L, 16, value, pushnumber);
}

static int l_glUniform4fv(lua_State *L) {
    GLint location = (GLint)luaL_checkinteger(L, 1);
    GLsizei count = (GLsizei)luaL_checkinteger(L, 2);
    luaL_checktype(L, 3, LUA_TTABLE);
    const GLfloat *value = (const GLfloat *)l_glUniformfv(L, 3, count, 4, 1);
    glUniform4fv(location, count, value);
    return l_glData(L, 4, value, pushnumber);
}

static int l_glUniform1iv(lua_State *L) {
    GLint location = (GLint)luaL_checkinteger(L, 1);
    GLsizei count = (GLsizei)luaL_checkinteger(L, 2);
    const char *string = (const char*)luaL_checkstring(L, 3);
    GLint value[1024];
    int i = 0;
    for (; i < count; ++i) {
        value[i] = string[i];
    }
    value[i] = 0;
    glUniform1iv(location, count+1, value);
    return 0;
}

static int l_glUniform1fv(lua_State *L) {
    GLint location = (GLint)luaL_checkinteger(L, 1);
    GLsizei count = (GLsizei)luaL_checkinteger(L, 2);
    GLfloat value[1];
    value[0] = (GLfloat)luaL_checknumber(L, 3);
    glUniform1fv(location, count, value);
    return 0;
}

static int l_glUniform1f(lua_State *L) {
    GLint location = (GLint)luaL_checkinteger(L, 1);
    GLfloat value = (GLfloat)luaL_checknumber(L, 2);
    glUniform1f(location, value);
    return 0;
}

static int l_glUniform1i(lua_State *L) {
    GLint location = (GLint)luaL_checkinteger(L, 1);
    GLint value = (GLint)luaL_checkinteger(L, 2);
    glUniform1i(location, value);
    return 0;
}

// Buffer

static int l_glGenBuffer(lua_State *L) {
    GLuint id[1];
    glGenBuffers(1, id);
    lua_pushunsigned(L, id[0]);
    return 1;
}

static int l_glDeleteBuffer(lua_State *L) {
    GLuint ids[1];
    ids[0] = (GLuint)luaL_checkunsigned(L, 1);
    glDeleteBuffers(1, ids);
    return 0;
}

static int l_glIsBuffer(lua_State *L) {
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    lua_pushunsigned(L, glIsBuffer(id));
    return 1;
}

static int l_glBindBuffer(lua_State *L) {
    GLenum target = (GLenum)luaL_checkunsigned(L, 1);
    GLuint id = (GLuint)luaL_checkunsigned(L, 2);
    glBindBuffer(target, id);
    return 0;
}

static int l_glBufferData(lua_State *L) {
    GLenum target = (GLenum)luaL_checkunsigned(L, 1);
    GLsizeiptr size = (GLsizeiptr)luaL_checkinteger(L, 2);

    const GLvoid *data = NULL;
    switch (target) {
        case GL_ARRAY_BUFFER:
            data = NULL; // l_glUniformfv(L, 3, 1, nelems, ncoords);
            break;

        case GL_ELEMENT_ARRAY_BUFFER: {
            int ncoords = 1;
            int nelems = size / ncoords / sizeof(GLushort);
            data = l_glUniformiv(L, 3, 1, nelems, ncoords);
            break;
        }
    }

    GLenum usage = (GLenum)luaL_checkunsigned(L, 4);
    glBufferData(target, size, data, usage);
    return 0;
}

static int l_glBufferSubData(lua_State *L) {
    GLenum target = (GLenum)luaL_checkunsigned(L, 1);
    GLintptr offset = (GLintptr)luaL_checkunsigned(L, 2);
    GLint nelems = (GLint)luaL_checkinteger(L, 3);
    GLint ncoords = (GLint)luaL_checkinteger(L, 4);
    GLsizeiptr sizeelem = (GLsizeiptr)luaL_checkinteger(L, 5);
    //GLchar *typelem = (GLchar *)luaL_checkstring(L, 6);

    GLsizeiptr size = nelems * ncoords * sizeelem;
    GLfloat *value = (GLfloat *)l_glUniformfv(L, 7, 1, nelems, ncoords);
    glBufferSubData(target, offset, size, value);

    return l_glData(L, nelems * ncoords, value, pushnumber);
}

// Vertex Array

static int l_glGenVertexArray(lua_State *L) {
    GLuint id[1];
    glGenVertexArrays(1, id);
    lua_pushunsigned(L, id[0]);
    return 1;
}

static int l_glDeleteVertexArray(lua_State *L) {
    GLuint ids[1];
    ids[0] = (GLuint)luaL_checkunsigned(L, 1);
    glDeleteVertexArrays(1, ids);
    return 0;
}

static int l_glIsVertexArray(lua_State *L) {
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    lua_pushunsigned(L, glIsVertexArray(id));
    return 1;
}

static int l_glBindVertexArray(lua_State *L) {
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    glBindVertexArray(id);
    return 0;
}

static int l_glVertexAttribPointer(lua_State *L) {
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    GLint size = (GLint)luaL_checkinteger(L, 2);
    GLenum type = (GLenum)luaL_checkunsigned(L, 3);
    GLboolean normalized = (GLboolean)luaL_checkunsigned(L, 4);
    GLsizei stride = (GLsizei)luaL_checkinteger(L, 5);
    const GLvoid *pointer = (const GLvoid *)luaL_checkunsigned(L, 6);
    glVertexAttribPointer(id, size, type, normalized, stride, pointer);
    return 0;
}

static int l_glEnableVertexAttribArray(lua_State *L) {
    GLuint id = (GLuint)luaL_checkunsigned(L, 1);
    glEnableVertexAttribArray(id);
    return 0;
}

// Draw

static int l_glViewport(lua_State *L) {
    GLint x = (GLint)luaL_checkinteger(L, 1);
    GLint y = (GLint)luaL_checkinteger(L, 2);
    GLsizei w = (GLsizei)luaL_checkinteger(L, 3);
    GLsizei h = (GLsizei)luaL_checkinteger(L, 4);
    glViewport(x, y, w, h);
    return 0;
}

static int l_glClearColor(lua_State *L) {
    GLfloat r = (GLfloat)luaL_checknumber(L, 1);
    GLfloat g = (GLfloat)luaL_checknumber(L, 2);
    GLfloat b = (GLfloat)luaL_checknumber(L, 3);
    GLfloat a = (GLfloat)luaL_checknumber(L, 4);
    glClearColor(r, g, b, a);
    return 0;
}

static int l_glClear(lua_State *L) {
    GLbitfield mask = (GLbitfield)luaL_checkunsigned(L, 1);
    glClear(mask);
    return 0;
}

static int l_glLineWidth(lua_State *L) {
    GLfloat width = (GLfloat)luaL_checknumber(L, 1);
    glLineWidth(width);
    return 0;
}

static int l_glPolygonMode(lua_State *L) {
    GLenum face = (GLenum)luaL_checkunsigned(L, 1);
    GLenum mode = (GLenum)luaL_checkunsigned(L, 2);
    glPolygonMode(face, mode);
    return 0;
}

static int l_glDrawElements(lua_State *L) {
    GLenum mode = (GLenum)luaL_checkunsigned(L, 1);
    GLsizei count = (GLsizei)luaL_checkinteger(L, 2);
    GLenum type = (GLenum)luaL_checkunsigned(L, 3);
    const GLvoid *indices = (const GLvoid *)luaL_checkunsigned(L, 4);
    glDrawElements(mode, count, type, indices);
    return 0;
}

static int l_glDrawArrays(lua_State *L) {
    GLenum mode = (GLenum)luaL_checkunsigned(L, 1);
    GLint first = (GLint)luaL_checkinteger(L, 2);
    GLsizei count = (GLsizei)luaL_checkinteger(L, 3);
    glDrawArrays(mode, first, count);
    return 0;
}

// Error

static int l_glGetError(lua_State *L) {
    GLenum error = glGetError();
    lua_pushunsigned(L, error);
    return 1;
}

// TODEL ?

static int l_glSizeOfFloat(lua_State *L) {
    lua_pushinteger(L, sizeof(GLfloat));
    return 1;
}

static int l_glSizeOfShort(lua_State *L) {
    lua_pushinteger(L, sizeof(GLushort));
    return 1;
}

static const luaL_Reg functions[] = {
    Function(glGetError)
    Function(glEnable)
    Function(glDepthFunc)
    Function(glCullFace)
    Function(glFrontFace)
    Function(glBlendFunc)
    Function(glGetString)

    Function(glGenFramebuffer)
    Function(glDeleteFramebuffer)
    Function(glIsFramebuffer)
    Function(glBindFramebuffer)
    Function(glFramebufferRenderbuffer)
    Function(glFramebufferTexture)
    Function(glDrawBuffer)
    Function(glCheckFramebufferStatus)

    Function(glGenRenderbuffer)
    Function(glDeleteRenderbuffer)
    Function(glIsRenderbuffer)
    Function(glBindRenderbuffer)
    Function(glRenderbufferStorage)

    Function(glGenTexture)
    Function(glDeleteTexture)
    Function(glIsTexture)
    Function(glBindTexture)
    Function(glActiveTexture)
    Function(glTexParameteri)
    Function(glTexImage2D)
    Function(glGenerateMipmap)

    Function(glCreateShader)
    Function(glDeleteShader)
    Function(glIsShader)
    Function(glShaderSource)
    Function(glCompileShader)
    Function(glGetShaderInfoLog)
    Function(glGetShaderiv)
    Function(glAttachShader)

    Function(glCreateProgram)
    Function(glDeleteProgram)
    Function(glIsProgram)
    Function(glBindAttribLocation)
    Function(glGetUniformLocation)
    Function(glLinkProgram)
    Function(glGetProgramiv)
    Function(glGetProgramInfoLog)
    Function(glUseProgram)
    Function(glUniformMatrix4fv)
    Function(glUniform4fv)
    Function(glUniform1fv)
    Function(glUniform1iv)
    Function(glUniform1f)
    Function(glUniform1i)

    Function(glGenBuffer)
    Function(glDeleteBuffer)
    Function(glIsBuffer)
    Function(glBindBuffer)
    Function(glBufferData)
    Function(glBufferSubData)

    Function(glGenVertexArray)
    Function(glDeleteVertexArray)
    Function(glIsVertexArray)
    Function(glBindVertexArray)
    Function(glVertexAttribPointer)
    Function(glEnableVertexAttribArray)

    Function(glViewport)
    Function(glClearColor)
    Function(glClear)
    Function(glLineWidth)
    Function(glPolygonMode)
    Function(glDrawElements)
    Function(glDrawArrays)

    Function(glSizeOfFloat)
    Function(glSizeOfShort)

    { NULL, NULL }
};

// enums
static const CommonEnum enums[] = {
    Enum(GL_DEPTH_TEST)
    Enum(GL_LEQUAL)
    Enum(GL_CULL_FACE)
    Enum(GL_BACK)
    Enum(GL_CCW)
    Enum(GL_SRC_ALPHA)
    Enum(GL_ONE_MINUS_SRC_ALPHA)
    Enum(GL_BLEND)
    Enum(GL_NO_ERROR)
    Enum(GL_TEXTURE_2D)
    Enum(GL_TEXTURE0)
    Enum(GL_TEXTURE1)
    Enum(GL_TEXTURE2)
    Enum(GL_COLOR_ATTACHMENT0)
    Enum(GL_COLOR_ATTACHMENT1)
    Enum(GL_COLOR_ATTACHMENT2)
    Enum(GL_TEXTURE_MIN_FILTER)
    Enum(GL_TEXTURE_MAG_FILTER)
    Enum(GL_LINEAR)
    Enum(GL_NEAREST)
    Enum(GL_RGB)
    Enum(GL_BGR)
    Enum(GL_RGBA)
    Enum(GL_BGRA)
    Enum(GL_UNSIGNED_BYTE)
    Enum(GL_UNSIGNED_SHORT)
    Enum(GL_VERTEX_SHADER)
    Enum(GL_FRAGMENT_SHADER)
    Enum(GL_GEOMETRY_SHADER)
    Enum(GL_COMPILE_STATUS)
    Enum(GL_LINK_STATUS)
    Enum(GL_INFO_LOG_LENGTH)
    Enum(GL_TRUE)
    Enum(GL_FALSE)
    Enum(GL_COLOR_BUFFER_BIT)
    Enum(GL_DEPTH_BUFFER_BIT)
    Enum(GL_DEPTH_COMPONENT)
    Enum(GL_DEPTH_COMPONENT24)
    Enum(GL_DEPTH_ATTACHMENT)
    Enum(GL_VERSION)
    Enum(GL_ARRAY_BUFFER)
    Enum(GL_ELEMENT_ARRAY_BUFFER)
    Enum(GL_FRAMEBUFFER)
    Enum(GL_FRAMEBUFFER_COMPLETE)
    Enum(GL_RENDERBUFFER)
    Enum(GL_FLOAT)
    Enum(GL_FRONT_AND_BACK)
    Enum(GL_FILL)
    Enum(GL_LINE)
    Enum(GL_LINE_LOOP)
    Enum(GL_QUADS)
    Enum(GL_LINE_STRIP)
    Enum(GL_TRIANGLE_STRIP)
    Enum(GL_TRIANGLES)
    Enum(GL_LINES)
    Enum(GL_POINTS)
    Enum(GL_STATIC_DRAW)
    Enum(GL_TEXTURE_WRAP_S)
    Enum(GL_TEXTURE_WRAP_T)
    Enum(GL_CLAMP_TO_EDGE)

    { NULL, -1 }
};

int EXPORT luaopen_OGL(lua_State *L) {
    commonNewLibrary(L, functions);
    commonBindEnum(L, 0, NULL, enums);

    lua_setglobal(L, "gl");
    
    return 0;
}