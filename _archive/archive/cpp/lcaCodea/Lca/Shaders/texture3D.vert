#version 330 core

uniform mat4 modelviewProjection;

uniform int brand;
uniform int seed;

in vec3 in_Vertex;
in vec4 in_Color;
in vec2 in_TexCoord0;

out vec4 color;
out vec2 coordTexture;

void main() {
    gl_Position = modelviewProjection * vec4(in_Vertex, 1.0);
    
    color = in_Color;
    coordTexture = in_TexCoord0;
}