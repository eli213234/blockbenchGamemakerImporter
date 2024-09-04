//
// Simple passthrough vertex shader
#define MAX_ARRAY 350
attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)
attribute float meshId;						 // (i)


varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float time;
uniform vec4 rotations[MAX_ARRAY];
uniform vec4 translations[MAX_ARRAY];
uniform vec2 locationIDs[MAX_ARRAY]; 
uniform float obj_amount;
vec3 rotationMatrix(vec3 vector, float xang, float yang, float zang)
{
    
    float xx = vector.x;
    float yy = vector.y;
    float zz = vector.z;
	vec3 newVector = vec3(0,0,0);
	newVector.z = zz*(cos(zang) * cos(yang) )   +   yy*( cos(zang)*sin(yang)*sin(xang) - sin(zang)*cos(xang) ) 
												+   xx*( cos(zang)*sin(yang)*cos(xang) + sin(zang)*sin(xang));
		
	newVector.y = zz*(sin(zang) * cos(yang) )   +   yy*( sin(zang)*sin(yang)*sin(xang) + cos(zang)*cos(xang) )
												+	xx*( sin(zang)*sin(yang)*cos(xang) - cos(zang)*sin(xang));
		
	newVector.x = zz*(-sin(yang) )		+	yy*(cos(yang)*sin(xang)  )		+	 xx*( cos(yang) * cos(xang) );
	
	
   return( newVector);
}

void main()
{
	vec4 col = in_Colour;
    vec3 temp = vec3(in_Position.x, in_Position.y, in_Position.z);
	int id  = int(meshId);
	int startID = int(locationIDs[id-1].x);
	int endID   = int(locationIDs[id-1].y);
	for(int i = startID; i <= endID ; i += 1){	
		
		vec4 rots  = rotations[i];
		vec4 trans = translations[i];
		if(rots.b != 0.0)
			temp = rotationMatrix( temp ,	 0.0,	 0.0, rots.b);
		if(rots.r != 0.0)
			temp = rotationMatrix( temp , rots.r,	 0.0,    0.0);
		if(rots.g != 0.0)
			temp = rotationMatrix( temp ,	 0.0, rots.g,	 0.0);
			
		temp.x += trans.r;
		temp.y += trans.g;
		temp.z += trans.b;			
	}	
    vec4 object_space_pos = vec4( temp.x, temp.y, temp.z, 1.0);
	
	v_vColour = vec4(col.rgb, 1.0); 
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;

    v_vTexcoord = in_TextureCoord;
}
