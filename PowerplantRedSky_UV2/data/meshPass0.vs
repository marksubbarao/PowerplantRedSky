in vec3 uv_vertexAttrib;
uniform mat4 uv_modelViewProjectionMatrix;

//Pass though
  
 void main()
 {
   gl_Position = uv_modelViewProjectionMatrix*vec4(uv_vertexAttrib,1.0);
 }
