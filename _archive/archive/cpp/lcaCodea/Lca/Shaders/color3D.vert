#version 330 core

uniform mat4 modelviewProjection;
uniform mat4 model;

in vec3 in_Vertex;
in vec3 in_Normal;
in vec4 in_Color;

out vec3 normal;
out vec4 color;

#define FACTOR 4096

int g_rand = 0;
void srand(float x, float y, float z) {
    g_rand = int(( z * FACTOR + x ) * FACTOR + y);
}

#define MAX_RAND 123456789 // 0X7FFFFFFF

int m = MAX_RAND;

float my_random() {
    int a = 16807;
    int b = 0;

    g_rand = ( a * g_rand + b ) % m;
    return g_rand;
}

float rand() {
    float m2 = m;
    return my_random() / m2;
}

void main() {
    gl_Position = modelviewProjection * vec4(in_Vertex, 1.0);

    color = in_Color;
    normal = in_Normal;
}