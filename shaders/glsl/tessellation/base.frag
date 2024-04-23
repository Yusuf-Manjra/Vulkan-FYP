#version 450

layout (set = 1, binding = 0) uniform sampler2D samplerColorMap;

layout (location = 0) in vec3 inNormal;
layout (location = 1) in vec2 inUV;

layout (location = 0) out vec4 outFragColor;

void main()
{
	vec3 N = normalize(inNormal);
	vec3 L = normalize(vec3(-4.0, -4.0, 0.0));

	vec4 color = texture(samplerColorMap, inUV);
	
	//outFragColor.rgb =  color.rgb;
	
	outFragColor =  vec4(inUV.x, inUV.y, 0, 1);
}
