#version 330 core

uniform vec3 light_direction;
uniform vec3 light_ambient_color;

uniform float light_ambient_intensity;

in vec3 normal;
in vec4 color;

out vec4 out_Color;

void main() {
    out_Color = color;
/*    if ( light_ambient_intensity != 0.0 ) {
        float light_diffuse_intensity = max(0.0, dot(normal, light_direction));
        out_Color = color * 
            vec4(light_ambient_color * ( light_ambient_intensity + light_diffuse_intensity ), 1.0);
    } else {
        out_Color = color;
    }
*/
}