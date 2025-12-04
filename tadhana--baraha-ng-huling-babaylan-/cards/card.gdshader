shader_type canvas_item;

uniform float burn_amount : hint_range(0.0, 1.0) = 0.0; // 0 = normal, 1 = gone
uniform float edge_width : hint_range(0.0, 0.3) = 0.12;
uniform vec4 edge_color : source_color = vec4(1.0, 0.35, 0.05, 1.0); // hotter orange
uniform float noise_strength = 0.15; // jagged burn line
uniform float flicker_speed = 12.0; // glow flicker

// cheap pseudo-noise using sin/cos
float noise(vec2 uv){
    return fract(sin(dot(uv.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    float y = UV.y;

    // Add noise variation to burn threshold
    float n = noise(UV * 40.0) * noise_strength;
    float burn_line = burn_amount + n;

    // Dissolve region check
    if (y < burn_line) {
        float fade = smoothstep(burn_line - 0.08, burn_line, y);
        tex.a *= fade;
    }

    // Glowing edge zone
    float edge_start = burn_line;
    float edge_end = burn_line + edge_width;

    if (y >= edge_start && y <= edge_end) {
        float t = (y - edge_start) / edge_width;
        float glow_strength = (1.0 - t);

        // flicker using time
        glow_strength *= (0.85 + 0.15 * sin(TIME * flicker_speed));

        tex.rgb = mix(tex.rgb, edge_color.rgb, glow_strength);
    }

    COLOR = tex;
}
