uniform vec2 u_resolution;

uniform sampler2D texture;


void main(void) {
		
	vec2 uv = gl_FragCoord.xy / u_resolution.xy;

	vec3 sourcePixel;
	sourcePixel.r = texture2D(texture, uv-vec2(.001,.0001)).r;
	sourcePixel.g = texture2D(texture, uv).g;
	sourcePixel.b = texture2D(texture, uv+vec2(.001,.0001)).b;

	
	float amt=1.;
	float vignette = (1.-amt*(uv.y-.5)*(uv.y-.5))*(1.-amt*(uv.x-.5)*(uv.x-.5));
	sourcePixel *= vignette;

	
	
	gl_FragColor = vec4(sourcePixel,1.0);
	
}

