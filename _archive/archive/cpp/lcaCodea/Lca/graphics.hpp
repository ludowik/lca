//
//  graphics.hpp
//  Lca
//
//  Created by lca pro on 12/12/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#ifndef graphics_hpp
#define graphics_hpp

extern lua_Integer WIDTH;
extern lua_Integer HEIGHT;

enum Orientation {
    PORTRAIT             = 0,
    PORTRAIT_UPSIDE_DOWN = 1,
    LANDSCAPE_LEFT       = 2,
    LANDSCAPE_RIGHT      = 3,
    PORTRAIT_ANY         = 4,
    LANDSCAPE_ANY        = 5,
    ANY                  = 6
};

enum AlignMode {
    CORNER = 0,
    CORNERS,
    CENTER = 2,
    LEFT,
    RIGHT,
    RADIUS
};

enum DisplayMode {
    STANDARD              = 0,
    FULLSCREEN            = 1,
    FULLSCREEN_NO_BUTTONS = 2
};

enum LineCapMode {
    ROUND   = 0,
    SQUARE  = 1,
    PROJECT = 2
};

enum BlendMode {
    NORMAL   = 0,
    ADDITIVE = 1,
    MULTIPLY = 2
};

void register_graphics(lua_State *L);

#endif /* graphics_hpp */