//
//  Shader.fsh
//  Lca
//
//  Created by Ludovic MILHAU on 10/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}