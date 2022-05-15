//
//  graphics.cpp
//  Lca
//
//  Created by lca pro on 12/12/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#include "tools.hpp"
#include "color.hpp"
#include "graphics.hpp"
#include "ogl.hpp"

lua_Integer WIDTH = 1280;
lua_Integer HEIGHT = 960;

struct CodeaStyle {
    CodeaStyle *previousStyle;

    bool supportedOrientations[4];

    AlignMode textAlign;

    AlignMode textMode;
    AlignMode rectMode;
    AlignMode ellipseMode;
    AlignMode spriteMode;

    DisplayMode displayMode;

    LineCapMode lineCapMode;

    BlendMode blendMode;

    float strokeWidth;
    float textWrapWidth;
    float fontSize;

    lua_Number stroke[4];
    lua_Number fill[4];
};

CodeaStyle &style = *new CodeaStyle();

int l_resetStyle(lua_State *L) {
    style.textMode = CENTER;
    style.rectMode = CORNER;
    style.ellipseMode = CENTER;
    style.spriteMode = CENTER;

    style.displayMode = STANDARD;

    style.lineCapMode = ROUND;

    style.blendMode = NORMAL;

    style.strokeWidth = 1.1;
    style.textWrapWidth = WIDTH;
    style.fontSize = 12;

    style.stroke[0] = style.stroke[1] = style.stroke[2] = style.stroke[3] = 255;
    style.fill[0] = style.fill[1] = style.fill[2] = style.fill[3] = 0;

    return 0;
}

int l_pushStyle(lua_State *L) {
    CodeaStyle &top = *new CodeaStyle();
    memcpy(&top, &style, sizeof(CodeaStyle));
    top.previousStyle = &style;
    style = top;
    return 0;
}

int l_popStyle(lua_State *L) {
    CodeaStyle &top = style;
    if (top.previousStyle) {
        style = *top.previousStyle;
        delete &top;
    }
    return 0;
}

int l_supportedOrientations(lua_State *L) {
    int narg = lua_gettop(L);
    if (narg >= 1) {
        style.supportedOrientations[PORTRAIT] =
        style.supportedOrientations[PORTRAIT_UPSIDE_DOWN] =
        style.supportedOrientations[LANDSCAPE_LEFT] =
        style.supportedOrientations[LANDSCAPE_RIGHT] = false;

        for (int i = 1; i <= narg; ++i) {
            switch (luaL_checkunsigned(L, i)) {
                case ANY:
                    style.supportedOrientations[PORTRAIT] =
                    style.supportedOrientations[PORTRAIT_UPSIDE_DOWN] =
                    style.supportedOrientations[LANDSCAPE_LEFT] =
                    style.supportedOrientations[LANDSCAPE_RIGHT] = true;
                    break;
                case PORTRAIT_ANY:
                    style.supportedOrientations[PORTRAIT] = true;
                    style.supportedOrientations[PORTRAIT_UPSIDE_DOWN] = true;
                    break;
                case PORTRAIT:
                    style.supportedOrientations[PORTRAIT] = true;
                    break;
                case PORTRAIT_UPSIDE_DOWN:
                    style.supportedOrientations[PORTRAIT_UPSIDE_DOWN] = true;
                    break;
                case LANDSCAPE_ANY:
                    style.supportedOrientations[LANDSCAPE_LEFT] = true;
                    style.supportedOrientations[LANDSCAPE_RIGHT] = true;
                    break;
                case LANDSCAPE_LEFT:
                    style.supportedOrientations[LANDSCAPE_LEFT] = true;
                    break;
                case LANDSCAPE_RIGHT:
                    style.supportedOrientations[LANDSCAPE_RIGHT] = true;
                    break;
            }
        }
    }
    else {
        int n = 0;
        for (int i = 0; i < 4; ++i) {
            if (style.supportedOrientations[i]) {
                lua_pushunsigned(L, i);
                n++;
            }
        }
        return n;
    }
    return 0;
}

int l_textAlign(lua_State *L) {
    int narg = lua_gettop(L);
    if (narg == 1) {
        style.textAlign = (AlignMode)luaL_checkunsigned(L, 1);
    }
    lua_pushunsigned(L, style.textAlign);
    return 1;
}

int l_textMode(lua_State *L) {
    int narg = lua_gettop(L);
    if (narg == 1) {
        style.textMode = (AlignMode)luaL_checkunsigned(L, 1);
    }
    lua_pushunsigned(L, style.textMode);
    return 1;
}

int l_rectMode(lua_State *L) {
    int narg = lua_gettop(L);
    if (narg == 1) {
        style.rectMode = (AlignMode)luaL_checkunsigned(L, 1);
    }
    lua_pushunsigned(L, style.rectMode);
    return 1;
}

int l_ellipseMode(lua_State *L) {
    int narg = lua_gettop(L);
    if (narg == 1) {
        style.ellipseMode = (AlignMode)luaL_checkunsigned(L, 1);
    }
    lua_pushunsigned(L, style.ellipseMode);
    return 1;
}

int l_spriteMode(lua_State *L) {
    int narg = lua_gettop(L);
    if (narg == 1) {
        style.spriteMode = (AlignMode)luaL_checkunsigned(L, 1);
    }
    lua_pushunsigned(L, style.spriteMode);
    return 1;
}

int l_displayMode(lua_State *L) {
    int narg = lua_gettop(L);
    if (narg == 1) {
        style.displayMode = (DisplayMode)luaL_checkunsigned(L, 1);
    }
    lua_pushunsigned(L, style.displayMode);
    return 1;
}

int l_lineCapMode(lua_State *L) {
    int narg = lua_gettop(L);
    if (narg == 1) {
        style.lineCapMode = (LineCapMode)luaL_checkunsigned(L, 1);
    }
    lua_pushunsigned(L, style.lineCapMode);
    return 1;
}

int l_blendMode(lua_State *L) {
    int narg = lua_gettop(L);
    if (narg == 1) {
        style.blendMode = (BlendMode)luaL_checkunsigned(L, 1);
    }
    lua_pushunsigned(L, style.blendMode);
    return 1;
}

int l_strokeWidth(lua_State *L) {
    int narg = lua_gettop(L);
    if (narg == 1) {
        style.strokeWidth = luaL_checknumber(L, 1);
    }
    lua_pushnumber(L, style.strokeWidth);
    return 1;
}

int l_textWrapWidth(lua_State *L) {
    int narg = lua_gettop(L);
    if (narg == 1) {
        style.textWrapWidth = luaL_checknumber(L, 1);
    }
    lua_pushnumber(L, style.textWrapWidth);
    return 1;
}

int l_fontSize(lua_State *L) {
    int narg = lua_gettop(L);
    if (narg == 1) {
        style.fontSize = luaL_checknumber(L, 1);
    }
    lua_pushnumber(L, style.fontSize);
    return 1;
}

int l_stroke(lua_State *L) {
    int narg = lua_gettop(L);
    if (narg == 1) {
        lua_Number *v = l_color_check(L, 1);
        memcpy(style.stroke, v, sizeof(lua_Number)*4);
    }
    l_color_push(L, style.stroke);
    return 1;
}

int l_noStroke(lua_State *L) {
    style.stroke[0] = style.stroke[1] = style.stroke[2] = style.stroke[3] = 0;
    return 0;
}

int l_fill(lua_State *L) {
    int narg = lua_gettop(L);
    if (narg == 1) {
        lua_Number *v = l_color_check(L, 1);
        memcpy(style.fill, v, sizeof(lua_Number)*4);
    }
    l_color_push(L, style.fill);
    return 1;
}

int l_noFill(lua_State *L) {
    style.fill[0] = style.fill[1] = style.fill[2] = style.fill[3] = 0;
    return 0;
}

int l_tint(lua_State *L) {
    return 0;
}

int l_noTint(lua_State *L) {
    return 0;
}

int l_smooth(lua_State *L) {
    return 0;
}

int l_noSmooth(lua_State *L) {
    return 0;
}

int l_background(lua_State *L) {
    lua_Number r, g, b, a;
    l_color_param(L, r, g, b, a);

    glClearColor(r/255., g/255., b/255., a/255.);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    return 0;
}

static const luaL_Reg graphicsFunctions[] = {
    Function(resetStyle)
    Function(pushStyle)
    Function(popStyle)

    Function(supportedOrientations)
    
    Function(textAlign)

    Function(textMode)
    Function(rectMode)
    Function(ellipseMode)
    Function(spriteMode)

    Function(displayMode)

    Function(lineCapMode)

    Function(blendMode)

    Function(strokeWidth)
    Function(textWrapWidth)

    Function(fontSize)

    Function(stroke)
    Function(noStroke)

    Function(fill)
    Function(noFill)

    Function(tint)
    Function(noTint)

    Function(smooth)
    Function(noSmooth)

    Function(background)
    
    { NULL, NULL }
};

static const CommonEnum graphicsEnums[] = {
    Enum(ANY)
    Enum(LANDSCAPE_ANY)
    Enum(LANDSCAPE_LEFT)
    Enum(LANDSCAPE_RIGHT)
    Enum(PORTRAIT_ANY)
    Enum(PORTRAIT)
    Enum(PORTRAIT_UPSIDE_DOWN)

    Enum(CORNER)
    Enum(CORNERS)
    Enum(CENTER)
    Enum(RADIUS)
    Enum(LEFT)
    Enum(RIGHT)

    Enum(STANDARD)
    Enum(FULLSCREEN)
    Enum(FULLSCREEN_NO_BUTTONS)

    Enum(ROUND)
    Enum(SQUARE)
    Enum(PROJECT)

    Enum(NORMAL)
    Enum(ADDITIVE)
    Enum(MULTIPLY)

    { NULL, NULL }
};

void register_graphics(lua_State *L) {
    register_lib(L, graphicsFunctions, graphicsEnums);

    l_resetStyle(L);

    style.previousStyle = NULL;

    style.supportedOrientations[PORTRAIT] =
    style.supportedOrientations[PORTRAIT_UPSIDE_DOWN] =
    style.supportedOrientations[LANDSCAPE_LEFT] =
    style.supportedOrientations[LANDSCAPE_RIGHT] = true;
}