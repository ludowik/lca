#version 330 core

in vec3 normal;
in vec4 color;

out vec4 out_Color;

void main() {
    out_Color = vec4(gl_FragCoord.z);
}