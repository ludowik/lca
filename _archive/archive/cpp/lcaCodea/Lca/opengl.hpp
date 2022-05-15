//
//  main.hpp
//  Lca
//
//  Created by lca pro on 28/11/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#ifndef main_hpp
#define main_hpp

#include <stdio.h>
#include <iostream>

#define GL3_PROTOTYPES
#include <OpenGL/gl3.h>
#include <CoreFoundation/CoreFoundation.h>
#include <SDL2/SDL.h>
#include <SDL2_image/SDL_image.h>

int init_sdl(lua_Integer *w, lua_Integer *h);
int init_gl();
int clear_gl();
int swap_gl();

#endif /* main_hpp */
