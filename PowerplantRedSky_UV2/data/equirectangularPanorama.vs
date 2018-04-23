attribute vec3 uv_vertexAttrib;
attribute vec2 uv_texCoordAttrib0;

uniform mat4 uv_modelViewInverseMatrix;
uniform mat4 uv_modelViewProjectionMatrix;
uniform vec4 Rotation;

const float PI = 3.1415926;
const float DEG2PI = PI/180;

out float DistanceFade;
out vec3 VertexDir;
out vec2 TexCoord;

mat4 getRotationMatrix(vec3 axis, float angle)
{
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;
    
    return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
                0.0,                                0.0,                                0.0,                                1.0);
}

void main(void)
{  

  float cameraDistance = length((uv_modelViewInverseMatrix * vec4(0.0, 0.0, 0.0, 1.0)).xyz) ; 
  DistanceFade = smoothstep(1, 0, cameraDistance);  
  
  float angle = Rotation.w * DEG2PI;
  vec3 axis = Rotation.xyz;  
  gl_Position = uv_modelViewProjectionMatrix * getRotationMatrix(axis, angle) * vec4(uv_vertexAttrib, 1.0);    		  
    
  VertexDir = uv_vertexAttrib;
  TexCoord = uv_texCoordAttrib0;
  
}