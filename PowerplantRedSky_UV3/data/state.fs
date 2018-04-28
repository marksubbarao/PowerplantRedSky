uniform sampler2D stateTexture;
uniform float dT;
uniform float yearPlot;
uniform vec2 timeRange;
out vec4 FragColor;

void main(){
	vec4 currentColor = texture(stateTexture, vec2(0.5));
	float currentTime = max(currentColor.r,timeRange[0]);
	float newTime = currentTime + ((yearPlot >currentTime) ?  min(yearPlot-currentTime,0.1*dT) : max(yearPlot-currentTime,-0.1*dT));
	newTime = clamp(newTime,timeRange[0],timeRange[1]);
	FragColor = vec4(newTime,currentColor.gba);
}