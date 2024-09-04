//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float alpha;
void main()
{
	vec4 sprite_col =  texture2D( gm_BaseTexture, v_vTexcoord );
	sprite_col.a *= alpha;

	if (sprite_col.a < .1) { discard; }
    gl_FragColor = v_vColour * sprite_col;
}
