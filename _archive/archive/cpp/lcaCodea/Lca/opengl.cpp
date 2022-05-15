//
//  main.cpp
//  Lca
//
//  Created by lca pro on 28/11/2015.
//  Copyright © 2015 lca. All rights reserved.
//

#include "tools.hpp"
#include "opengl.hpp"

void error(const char *str, ...) {
    //    std::cout << str << std::endl;
}

void exitOnGLError(string str_error) {
    GLenum error = glGetError();
    if ( error != GL_NO_ERROR ) {
        cout << str_error << "(" << error << ")" << endl;
        exit(error);
    }
}

SDL_Window *m_wnd = NULL;

SDL_GLContext m_contextOpenGL = 0;

int init_sdl(lua_Integer *w, lua_Integer *h) {
    // Initialisation de la SDL
    if ( SDL_Init(SDL_INIT_VIDEO) < 0 ) {
        error("Erreur lors de l'initialisation de la SDL : {1}", SDL_GetError());
        SDL_Quit();
        return false;
    }

    // Version d'OpenGL
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);

    // Double Buffer
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
    SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);

    // Création de la fenêtre
    m_wnd = SDL_CreateWindow("LOVE",
                             SDL_WINDOWPOS_CENTERED,
                             SDL_WINDOWPOS_CENTERED,
                             *w, *h,
                             SDL_WINDOW_BORDERLESS | SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE | SDL_WINDOW_OPENGL/*| SDL_WINDOW_FULLSCREEN*/);

    if ( m_wnd == 0 ) {
        error(SDL_GetError());
        SDL_Quit();
        return false;
    }

    //SDL_SetWindowFullscreen(m_wnd, SDL_TRUE);

    int ww, hh;
    SDL_GetWindowSize(m_wnd, &ww, &hh);
    *w = (lua_Integer)ww;
    *h = (lua_Integer)hh;

    // Création du contexte OpenGL
    m_contextOpenGL = SDL_GL_CreateContext(m_wnd);

    if ( m_contextOpenGL == 0 ) {
        error(SDL_GetError());
        
        SDL_DestroyWindow(m_wnd);
        SDL_Quit();
        return false;
    }

//    SDL_GL_SetSwapInterval(0);
    
    return 0;
}

int init_gl() {
    // Activation du Depth Buffer
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LEQUAL);

    exitOnGLError("ERROR: Could not set OpenGL depth testing options");

    // Activation du Culling
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);
    glFrontFace(GL_CCW);
    exitOnGLError("ERROR: Could not set OpenGL culling options");

    // Blend
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);

    glEnable(GL_LINE_SMOOTH);
    glEnable(GL_POLYGON_SMOOTH);

    glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
    glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);

    glEnable(GL_TEXTURE_2D);

    return 0;
}

int clear_gl() {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    return 0;
}

int swap_gl() {
    SDL_GL_SwapWindow(m_wnd);
    return 0;
}
