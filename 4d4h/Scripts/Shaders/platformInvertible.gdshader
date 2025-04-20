shader_type canvas_item;

render_mode unshaded;

uniform vec4 glow_color : source_color = vec4(2.0, 2.0, 2.0, 1.0); // Super brillante

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Aplicamos color multiplicado por la textura base
    COLOR = tex_color * glow_color;
}
