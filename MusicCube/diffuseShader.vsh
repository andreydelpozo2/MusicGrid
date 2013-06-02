///////////////////////////////////////////////////////////////////////////////
// GLT_SHADER_SHADED
// Point light, diffuse lighting only
static const char *szShadedVP =		"uniform mat4 mvpMatrix;"
"attribute vec4 vColor;"
"attribute vec4 vVertex;"
"varying vec4 vFragColor;"
"void main(void) {"
"vFragColor = vColor; "
" gl_Position = mvpMatrix * vVertex; "
"}";

static const char *szShadedFP =
#ifdef OPENGL_ES
"precision mediump float;"
#endif
"varying vec4 vFragColor; "
"void main(void) { "
" gl_FragColor = vFragColor; "
"}";
