shader_type canvas_item;

void fragment() {
    vec2 uv = SCREEN_UV;
    float dist = distance(uv, vec2(0.5));
    float circle = smoothstep(0.45, 0.5, dist);
    COLOR = vec4(vec3(circle), 1.0);
}
