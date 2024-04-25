#version 450

precision mediump float;

// PN patch data
struct PnPatch
{
 float b210;
 float b120;
 float b021;
 float b012;
 float b102;
 float b201;
 float b111;
 float n110;
 float n011;
 float n101;
};

layout (binding = 0) uniform UBO 
{
    mat4 projection;
    mat4 model;
    float tessAlpha;
    float tessLevel;
} ubo;

layout(triangles, fractional_odd_spacing, cw) in;

layout(location = 0) in vec3 iNormal[];
layout(location = 3) in vec2 iTexCoord[];
layout(location = 6) in PnPatch iPnPatch[];

layout(location = 0) out vec3 oNormal;
layout(location = 1) out vec2 oTexCoord;

#define uvw gl_TessCoord

float random (vec2 st)
{
    return fract(sin(dot(st.xy,vec2(12.9898, 78.233)))* 43758.5453123);
}

float random (vec3 st)
{
    //return fract(sin(dot(st.xyz, vec3(12.9898, 78.233, 55.18924)))* 43758.5453123);
	
	return (sin(dot(st.xyz, vec3(12.9898, 78.233, 55.18924))));
}

void main()
{
    vec3 uvwSquared = uvw * uvw;
    vec3 uvwCubed   = uvwSquared * uvw;

    // extract control points
    vec3 b210 = vec3(iPnPatch[0].b210, iPnPatch[1].b210, iPnPatch[2].b210);
    vec3 b120 = vec3(iPnPatch[0].b120, iPnPatch[1].b120, iPnPatch[2].b120);
    vec3 b021 = vec3(iPnPatch[0].b021, iPnPatch[1].b021, iPnPatch[2].b021);
    vec3 b012 = vec3(iPnPatch[0].b012, iPnPatch[1].b012, iPnPatch[2].b012);
    vec3 b102 = vec3(iPnPatch[0].b102, iPnPatch[1].b102, iPnPatch[2].b102);
    vec3 b201 = vec3(iPnPatch[0].b201, iPnPatch[1].b201, iPnPatch[2].b201);
    vec3 b111 = vec3(iPnPatch[0].b111, iPnPatch[1].b111, iPnPatch[2].b111);

    // extract control normals
    vec3 n110 = normalize(vec3(iPnPatch[0].n110, iPnPatch[1].n110, iPnPatch[2].n110));
    vec3 n011 = normalize(vec3(iPnPatch[0].n011, iPnPatch[1].n011, iPnPatch[2].n011));
    vec3 n101 = normalize(vec3(iPnPatch[0].n101, iPnPatch[1].n101, iPnPatch[2].n101));

    // compute texcoords
    oTexCoord  = gl_TessCoord[2]*iTexCoord[0] + gl_TessCoord[0]*iTexCoord[1] + gl_TessCoord[1]*iTexCoord[2];

    // normal
    // Barycentric normal
    vec3 barNormal = gl_TessCoord[2]*iNormal[0] + gl_TessCoord[0]*iNormal[1] + gl_TessCoord[1]*iNormal[2];
    vec3 pnNormal  = iNormal[0]*uvwSquared[2] + iNormal[1]*uvwSquared[0] + iNormal[2]*uvwSquared[1]
                   + n110*uvw[2]*uvw[0] + n011*uvw[0]*uvw[1]+ n101*uvw[2]*uvw[1];
    oNormal = ubo.tessAlpha*pnNormal + (1.0-ubo.tessAlpha) * barNormal;

    // compute interpolated pos
    vec3 barPos = gl_TessCoord[2]*gl_in[0].gl_Position.xyz
                + gl_TessCoord[0]*gl_in[1].gl_Position.xyz
                + gl_TessCoord[1]*gl_in[2].gl_Position.xyz;

    // save some computations
    uvwSquared *= 3.0;

    // compute PN position
    vec3 pnPos  = gl_in[0].gl_Position.xyz*uvwCubed[2]
                + gl_in[1].gl_Position.xyz*uvwCubed[0]
                + gl_in[2].gl_Position.xyz*uvwCubed[1]
                + b210*uvwSquared[2]*uvw[0]
                + b120*uvwSquared[0]*uvw[2]
                + b201*uvwSquared[2]*uvw[1]
                + b021*uvwSquared[0]*uvw[1]
                + b102*uvwSquared[1]*uvw[2]
                + b012*uvwSquared[1]*uvw[0]
                + b111*6.0*uvw[0]*uvw[1]*uvw[2];
	
	// create random variance using variables
	//vec2 randomInput = vec2(iNormal[0], iNormal[1]);
	//vec2 randomInput = vec2(ubo.tessAlpha, ubo.tessLevel);
	//vec2 randomInputX = vec2(pnNormal[0] + pnNormal[1] + pnNormal[2], barNormal[0] + barNormal[1] + barNormal[2]);
	
	
	vec2 randomInputX = vec2(pnNormal[0], ubo.tessLevel) * 10;
	vec2 randomInputY = vec2(pnNormal[1], ubo.tessLevel) * 10;
	vec2 randomInputZ = vec2(pnNormal[2], ubo.tessLevel) * 10;

	
	/*
	vec2 randomInputX = vec2(pnNormal[0], pnNormal[1]) * 10;
	vec2 randomInputY = vec2(pnNormal[1], pnNormal[2]) * 10;
	vec2 randomInputZ = vec2(pnNormal[2], pnNormal[0]) * 10;
	*/
	
	/*
	vec2 randomInputX = vec2(barNormal[0], barNormal[1]) * 10;
	vec2 randomInputY = vec2(barNormal[1], barNormal[2]) * 10;
	vec2 randomInputZ = vec2(barNormal[2], barNormal[0]) * 10;
	*/
	
	/*
	vec2 randomInputX = vec2(pnNormal[0], barNormal[0]) * 10;
	vec2 randomInputY = vec2(pnNormal[1], barNormal[1]) * 10;
	vec2 randomInputZ = vec2(pnNormal[2], barNormal[2]) * 10;
	*/
	
	/*
	float randomVarX = random (randomInputX);
	float randomVarY = random (randomInputY);
	float randomVarZ = random (randomInputZ);
	*/
	
	//vec3 normalVariance = (iNormal[0] * randomVarX, iNormal[1] * randomVarY, iNormal[2] * randomVarZ) ; 
	
	float normalVariance = random (oNormal); 
	
    // final position and normal
    //vec3 finalPos = (1.0-ubo.tessAlpha)*barPos + ubo.tessAlpha*pnPos + normalVariance;
	
	vec3 finalPos = (1.0-ubo.tessAlpha)*barPos + ubo.tessAlpha*pnPos + barNormal*normalVariance;
	
	gl_Position = ubo.projection * ubo.model * vec4(finalPos,1.0);
}