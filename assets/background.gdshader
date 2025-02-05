shader_type canvas_item;
render_mode blend_premul_alpha;

uniform float blur_radius : hint_range(0.002, 0.05) = 0.02;
uniform float darkness : hint_range(0.0, 1.0) = 0.6;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec4 sum = vec4(0.0);
    vec2 size = TEXTURE_PIXEL_SIZE * blur_radius;

    // More blur samples for stronger blur effect
    sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-2.0 * size.x, -2.0 * size.y)) * 0.05;
    sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2( 2.0 * size.x, -2.0 * size.y)) * 0.05;
    sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-2.0 * size.x,  2.0 * size.y)) * 0.05;
    sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2( 2.0 * size.x,  2.0 * size.y)) * 0.05;
    
    sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-size.x, -size.y)) * 0.1;
    sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2( size.x, -size.y)) * 0.1;
    sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-size.x,  size.y)) * 0.1;
    sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2( size.x,  size.y)) * 0.1;

    sum += texture(SCREEN_TEXTURE, SCREEN_UV) * 0.4; // Center pixel weight

    // Apply stronger darkening effect
    COLOR = mix(sum, vec4(0, 0, 0, 1.0), darkness);
}
