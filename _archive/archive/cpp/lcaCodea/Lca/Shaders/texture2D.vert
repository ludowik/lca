#version 330 core

uniform mat4 model;

in vec3 in_Vertex;
in vec2 in_TexCoord0;

out vec2 coordTexture;

void main() {
    gl_Position = model * vec4(in_Vertex.xy, 0.0, 1.0);    
    coordTexture = in_TexCoord0;
}