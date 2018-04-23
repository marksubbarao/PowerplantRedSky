uniform float uv_fade;
uniform float uv_alpha;

in vec2 TexCoord;
in float DistanceFade;
in float Scale;out vec4 color;
uniform sampler2D panorama;
uniform vec4 ColorMultiplier;
uniform float displayFraction;
uniform float redInjectValue;
void main()
{	
	//Read the color from the texture and apply the appropreate color and alpha multipliers
	color = texture2D(panorama,vec2(1.-TexCoord.x,TexCoord.y));
	// Here is where we will calculate the new color with tint maybe something like:	
	
	if (color.a<=0.1) 				//Coloration of the ground
		color = mix(color,vec4(color.r,color.g,color.b,1.0),redInjectValue);		
	else if (color.a<=0.2) 			//Coloration of the smoke
		color = mix(color,vec4(color.b*color.a,color.g-color.r/color.a,color.b-color.r/color.a,1.0),redInjectValue);
	else 							//coloration of the non-smoke sky
		color = mix(color,vec4(color.b,color.g-color.r/color.a,color.b-color.r/color.a,1.0),redInjectValue);
				
	color.a = uv_fade*uv_alpha*DistanceFade;

}