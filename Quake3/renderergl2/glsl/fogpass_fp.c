const char *fallbackShader_fogpass_fp =
"uniform vec4  u_Color;\n"
"\n"
"varying float var_Scale;\n"
"\n"
"void main()\n"
"{\n"
"	gl_FragColor = u_Color;\n"
"	gl_FragColor.a = sqrt(clamp(var_Scale, 0.0, 1.0));\n"
"}\n"
;
