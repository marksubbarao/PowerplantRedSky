in vec2 TexCoord;
uniform float uv_fade;
uniform float alpha;
uniform int uv_simulationtimeDays;
uniform sampler2D stateTexture;
uniform sampler2D yearLabels;
uniform sampler2D co2Labels;
uniform sampler2D KeelingTitle;
uniform sampler2D tempData;
out vec4 fragColor;

void main(void)
{
    // INITALIZE VARIABLES
	float yearPlot=texture(stateTexture, vec2(0.5)).r;	
    vec4 dataColor;
	float years = uv_simulationtimeDays/365.25+1970.;
	const vec2 llim = vec2(0.1,0.1);
	const vec2 ulim = vec2(0.99,0.99);
	const vec2 yearLims = vec2(1958.25,2018.25);
	vec2 yearSpan = yearLims;
	vec2 co2Lims = vec2(305.0,420.0);
	vec2 co2Span=co2Lims;
	const vec4 graphColor = vec4(0.5,0.5,0.5,1.0);
	const vec4 tickColor = vec4(0.75,0.75,0.75,1.0);
	const vec4 pointColor = vec4(1.,1.,0.,1.);
	const float border=0.01;
	float graphAlpha=0.65;
	fragColor = vec4(0.);
	// DRAW FRAMING BOX
	float xPlace=TexCoord[0];
	if (!gl_FrontFacing) xPlace=(1-TexCoord[0]);
	if (xPlace<llim[0]&&xPlace>(llim[0]-0.5*border)&&TexCoord[1]<(ulim[1]+border)&&TexCoord[1]>(llim[1]-border)) fragColor=graphColor; 	
	if (xPlace>ulim[0]&&xPlace<(ulim[0]+0.5*border)&&TexCoord[1]<(ulim[1]+border)&&TexCoord[1]>(llim[1]-border)) fragColor=graphColor; 	
	if (xPlace>(llim[0]-0.5*border)&&xPlace<(ulim[0]+0.5*border)&&TexCoord[1]>(llim[1]-border)&&TexCoord[1]<llim[1]) fragColor=graphColor; 	
	if (xPlace>(llim[0]-0.5*border)&&xPlace<(ulim[0]+0.5*border)&&TexCoord[1]<(ulim[1]+border)&&TexCoord[1]>ulim[1]) fragColor=graphColor; 	

    // SET GRAPH SCALE
	yearSpan[0]=yearLims[0]-0.25;
	yearSpan[1]=clamp(yearPlot+0.5,yearLims[0]+1.1,yearLims[1]+0.25);
	co2Span[1]=co2Lims[0]+1.8*(yearSpan[1]-yearSpan[0])+20.;
	
    // DRAW POINTS
	float yearFrag= mix(yearSpan[0],yearSpan[1],(xPlace-llim[0])/(ulim[0]-llim[0]));
	float co2Frag = mix(co2Span[0],co2Span[1],(TexCoord[1]-llim[1])/(ulim[1]-llim[1]));
	if (xPlace>llim[0] && xPlace<ulim[0] && TexCoord[1]>llim[1] && TexCoord[1]<ulim[1])
	{
		fragColor=vec4(0.0,0.0,0.0,graphAlpha);
		float xSample=(yearFrag - yearLims[0])/(yearLims[1] - yearLims[0]);
		float yearSample=int((yearLims[0]+xSample*(yearLims[1] - yearLims[0]))*12.)/12.+1./24.;
		if (yearSample>yearSpan[0] && yearSample < yearSpan[1] &&xSample>0.0 && xSample<1.0)
		{
			dataColor=textureGrad(tempData,vec2(xSample,0.5), vec2(0.), vec2(0.));
			float co2Value=300.+256.*dataColor.r+dataColor.g;//unpacking the texture encoding
			vec2 graphOffset = vec2((yearFrag-yearSample)/(yearSpan[1]-yearSpan[0]),.5*(co2Frag-co2Value)/(co2Span[1]-co2Span[0]));
			if (length(graphOffset)<0.015/sqrt(yearSpan[1]-yearSpan[0]))
				fragColor=pointColor;
			vec4 dataColorp1=textureGrad(tempData, vec2(xSample+(1./(12*(yearLims[1] - yearLims[0]))),0.5), vec2(0.), vec2(0.));
			float co2Valuep1=300.+256.*dataColorp1.r+dataColorp1.g;//unpacking the texture encoding
			vec2 graphOffsetp1 = vec2((yearFrag-(yearSample+1./12))/(yearSpan[1]-yearSpan[0]),.5*(co2Frag-co2Valuep1)/(co2Span[1]-co2Span[0]));
			if (length(graphOffsetp1)<0.015/sqrt(yearSpan[1]-yearSpan[0]))
				fragColor=pointColor;
			vec4 dataColorm1=textureGrad(tempData, vec2(xSample-(1./(12*(yearLims[1] - yearLims[0])))+1e-5,0.5), vec2(0.), vec2(0.));
			float co2Valuem1=300.+256.*dataColorm1.r+dataColorm1.g;//unpacking the texture encoding
			vec2 graphOffsetm1 = vec2((yearFrag-(yearSample-1./12))/(yearSpan[1]-yearSpan[0]),.5*(co2Frag-co2Valuem1)/(co2Span[1]-co2Span[0]));
			if (length(graphOffsetm1)<0.015/sqrt(yearSpan[1]-yearSpan[0]))
				fragColor=pointColor;

		}
	  }
	  
    // DRAW TICKMARKS
	vec2 xTickLims = vec2(0.075,0.15);
	vec2 xsmTickLims = vec2(0.075,0.125);
	if (TexCoord[1]>xTickLims[0]&&TexCoord[1]<xTickLims[1]&& xPlace>llim[0]&&xPlace<ulim[0]) {
	  float xTickWidth=0.004*(yearSpan[1]-yearSpan[0]);
	  if (fract(yearFrag+xTickWidth/2.)<xTickWidth) {
	    if (fract(yearFrag/10.)>0.95 ||fract(yearFrag/10.)<0.05 ||TexCoord[1]<xsmTickLims[1]) { 
          fragColor=tickColor;
		}
	  }
	}
	vec2 yTickLims = vec2(0.0875,0.125);
	if (xPlace>yTickLims[0]&&xPlace<yTickLims[1]&& TexCoord[1]>llim[1]&&TexCoord[1]<ulim[1]) {
	  float yTickWidth=0.001*(co2Span[1]-co2Span[0]);
	  if (fract(co2Frag/10.+yTickWidth/2.)<yTickWidth) {
		fragColor=tickColor;
	  }
	}
	
	// DRAW YEAR LABELS
	vec4 sampleColor = vec4 (0.);
	float yearTicks[11] = float[11](-999,-999,1958,1959,1960,1970,1980,1990,2000,2010,2020);
	if (TexCoord[1]<0.075){
	  float labelWidth = 0.1*(yearSpan[1]-yearSpan[0]);
	  for (int i=0;i<11;i++) {
		  if (abs(yearFrag-yearTicks[i])<labelWidth/2.) {
			sampleColor=texture(yearLabels,vec2((i+0.5)/11.+((yearFrag-yearTicks[i])/labelWidth)/11.,TexCoord[1]/0.075));
			if (i<4&&(yearSpan[1]-yearSpan[0])>10) sampleColor.a*=clamp(12.-(yearSpan[1]-yearSpan[0]),0,1);
		  }
	  }
	}
	
	// DRAW CO2 LABELS
	float co2Ticks[12] = float[12](310,320,330,340,350,360,370,380,390,400,410,420);
	if (xPlace<0.09&&xPlace>0.03){
	  float labelHeight = 0.075*(co2Span[1]-co2Span[0]);
	  for (int i=0;i<12;i++) {
		  if (abs(co2Frag-co2Ticks[i])<labelHeight/2.) {
			sampleColor=texture(co2Labels,vec2(i/12.+((xPlace-0.03)/0.06)/12.,0.5+(co2Frag-co2Ticks[i])/labelHeight));
		  }
	  }
	}
	
	// DRAW TITLE
	if (xPlace>0.15&&xPlace<0.95 && TexCoord[1]>0.875 &&TexCoord[1]<0.95){
		sampleColor=texture(KeelingTitle,vec2((xPlace-0.15)/0.8,(TexCoord[1]-0.875)/0.075));
		sampleColor.rgb*=sampleColor.a;
		//fragColor.a=max(graphAlpha-sampleColor.a,0.0);
	}
	
	fragColor += sampleColor;
	fragColor.a*=alpha*uv_fade;
}
