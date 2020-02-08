const char *fallbackShader_texturecolor_fp =
"uniform sampler2D u_DiffuseMap;\n"
"uniform vec4      u_Color;\n"
"\n"
"varying vec2      var_Tex1;\n"
"\n"
"\n"
"void main()\n"
"{\n"
"	gl_FragColor = texture2D(u_DiffuseMap, var_Tex1) * u_Color;\n"
"}\n"
;
