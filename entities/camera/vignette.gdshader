shader_type canvas_item;

uniform float vignette_intensity = 0.05;
uniform float vignette_roundness = 1.0;
uniform vec2 vignette_center = vec2(0.5, 0.35);

// The Godot 4 way to access the screen texture
uniform sampler2D screen_texture : hint_screen_texture, filter_linear;

void fragment() {
    // Calculate the distance from the center of the screen
    vec2 pos = UV - vignette_center;
    float dist = length(pos * vec2(1.0, 1.0 / vignette_roundness));

    // Create the vignette effect
    float vignette = smoothstep(1, 0.7 - vignette_intensity, dist);

    // Apply the vignette to the screen color
    vec4 original_color = texture(screen_texture, SCREEN_UV);
    COLOR = vec4(original_color.rgb * vignette, 1.0);
}