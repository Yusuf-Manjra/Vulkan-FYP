#version 450
#extension GL_EXT_debug_printf : enable

layout (triangles) in;
layout (triangle_strip, max_vertices = 128) out;
//layout (line_strip, max_vertices = 128) out;


layout (binding = 0) uniform UBO 
{
	mat4 projection;
	mat4 model;
} ubo;

layout (location = 0) out vec3 outColor;

void main(void)
{	
	float normalLength = 0.02;
	for(int i=0; i<gl_in.length(); i=i+3)
	{
		/////////////////////
		/// Vertex Stuff ///
		///////////////////
		
		// Get Vertexes For Triangle
		vec3 vertex0 = gl_in[i].gl_Position.xyz;
		vec3 vertex1 = gl_in[i+1].gl_Position.xyz;
		vec3 vertex2 = gl_in[i+2].gl_Position.xyz;
		
		/*
		// Emit Each Vertex Point
		gl_Position = ubo.projection * (ubo.model * vec4(vertex0, 1.0));
		outColor = vec3(0.0, 0.0, 1.0);
		EmitVertex();
		
		gl_Position = ubo.projection * (ubo.model * vec4(vertex1, 1.0));
		outColor = vec3(0.0, 0.0, 1.0);
		EmitVertex();
		
		gl_Position = ubo.projection * (ubo.model * vec4(vertex2, 1.0));
		outColor = vec3(0.0, 0.0, 1.0);
		EmitVertex();
		
		gl_Position = ubo.projection * (ubo.model * vec4(vertex0, 1.0));
		outColor = vec3(0.0, 0.0, 1.0);
		EmitVertex();
		*/
		
			
		//vec3 vertex0_1_dist = vertex0 - vertex1;
		//vec3 vertex1_2_dist = vertex1 - vertex2;
		//vec3 vertex2_0_dist = vertex2 - vertex0;
		
		//vec3 vertex0_1 = vertex0 + (vertex0_1_dist / 2);
		//vec3 vertex1_2 = vertex1 + (vertex1_2_dist / 2);
		//vec3 vertex2_0 = vertex2 + (vertex2_0_dist / 2);
		
		
		/////////////////////////////////////
		/// Get MidPoint Vertices & Area ///
		///////////////////////////////////
		
		// Create vec3s For Midpoints
		vec3 vertex0_1 = (vertex0 / 2) + (vertex1 / 2);
		vec3 vertex1_2 = (vertex1 / 2) + (vertex2 / 2);
		vec3 vertex2_0 = (vertex2 / 2) + (vertex0 / 2);
		
		// Create Floats For Areas
		//float tri_area = 0.5 * (abs((vertex0[0] * (vertex1[1] - vertex2[1])) + (vertex1[0] * (vertex2[1] - vertex0[1])) + (vertex2[0] * (vertex0[1] - vertex1[1])) ) );
		//float tri_area_subdiv = 0.5 * (abs((vertex0_1[0] * (vertex1_2[1] - vertex2_0[1])) + (vertex1_2[0] * (vertex2_0[1] - vertex0_1[1])) + (vertex2_0[0] * (vertex0_1[1] - vertex1_2[1])) ) );
		
		
		///////////////////////////////////////////
		/// Emit Vertex Based On Triangle Area ///
		/////////////////////////////////////////
		//if ((0.3 * tri_area) <= tri_area_subdiv)
		if (tri_area < 0.1)
		{
			// Emit Each Vertex Mid Point
			gl_Position = ubo.projection * (ubo.model * vec4(vertex0_1, 1.0));
			outColor = vec3(0.0, 1.0, 0.0);
			EmitVertex();
			
			gl_Position = ubo.projection * (ubo.model * vec4(vertex1_2, 1.0));
			outColor = vec3(0.0, 1.0, 0.0);
			EmitVertex();
			
			gl_Position = ubo.projection * (ubo.model * vec4(vertex2_0, 1.0));
			outColor = vec3(0.0, 1.0, 0.0);
			EmitVertex();
			
			gl_Position = ubo.projection * (ubo.model * vec4(vertex0_1, 1.0));
			outColor = vec3(0.0, 1.0, 0.0);
			EmitVertex();
		}
		

		EndPrimitive();
	}
}