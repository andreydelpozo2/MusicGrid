///////////////////////////////////////////////////////////////////////////////
// Flat Shader (GLT_SHADER_FLAT)
// This shader applies the given model view matrix to the verticies,
// and uses a uniform color value.

uniform mat4 mvpMatrix;
attribute vec4 vVertex;

void main(void)
{
   gl_Position = mvpMatrix * vVertex;
}
