#version 330 core

uniform mat4 model;

uniform vec4 color2D;
uniform float lineWidth;

in vec3 in_Vertex;
in vec3 in_Normal;

out vec4 color;

void main() {
    vec3 normal = normalize(in_Normal);
    
    vec2 vertex = in_Vertex.xy + in_Normal.xy * lineWidth / 2;
    
    gl_Position = model * vec4(vertex.xy, 0.0, 1.0);
    
    color = color2D; // in_Color;
}