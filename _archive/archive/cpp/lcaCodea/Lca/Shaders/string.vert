#version 330 core

uniform mat4 model;
uniform vec4 color2D;

in vec3 in_Vertex;

out vec4 geoColor;

void main() {
    gl_Position = model * vec4(in_Vertex.xy, 0.0, 1.0);
    geoColor = color2D;
}