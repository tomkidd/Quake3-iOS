const char *fallbackShader_lightall_vp =
"attribute vec4 attr_TexCoord0;\n"
"#if defined(USE_LIGHTMAP) || defined(USE_TCGEN)\n"
"attribute vec4 attr_TexCoord1;\n"
"#endif\n"
"attribute vec4 attr_Color;\n"
"\n"
"attribute vec3 attr_Position;\n"
"attribute vec3 attr_Normal;\n"
"attribute vec4 attr_Tangent;\n"
"\n"
"#if defined(USE_VERTEX_ANIMATION)\n"
"attribute vec3 attr_Position2;\n"
"attribute vec3 attr_Normal2;\n"
"attribute vec4 attr_Tangent2;\n"
"#elif defined(USE_BONE_ANIMATION)\n"
"attribute vec4 attr_BoneIndexes;\n"
"attribute vec4 attr_BoneWeights;\n"
"#endif\n"
"\n"
"#if defined(USE_LIGHT) && !defined(USE_LIGHT_VECTOR)\n"
"attribute vec3 attr_LightDirection;\n"
"#endif\n"
"\n"
"#if defined(USE_DELUXEMAP)\n"
"uniform vec4   u_EnableTextures; // x = normal, y = deluxe, z = specular, w = cube\n"
"#endif\n"
"\n"
"#if defined(USE_LIGHT) && !defined(USE_FAST_LIGHT)\n"
"uniform vec3   u_ViewOrigin;\n"
"#endif\n"
"\n"
"#if defined(USE_TCGEN)\n"
"uniform int    u_TCGen0;\n"
"uniform vec3   u_TCGen0Vector0;\n"
"uniform vec3   u_TCGen0Vector1;\n"
"uniform vec3   u_LocalViewOrigin;\n"
"#endif\n"
"\n"
"#if defined(USE_TCMOD)\n"
"uniform vec4   u_DiffuseTexMatrix;\n"
"uniform vec4   u_DiffuseTexOffTurb;\n"
"#endif\n"
"\n"
"uniform mat4   u_ModelViewProjectionMatrix;\n"
"uniform vec4   u_BaseColor;\n"
"uniform vec4   u_VertColor;\n"
"\n"
"#if defined(USE_MODELMATRIX)\n"
"uniform mat4   u_ModelMatrix;\n"
"#endif\n"
"\n"
"#if defined(USE_VERTEX_ANIMATION)\n"
"uniform float  u_VertexLerp;\n"
"#elif defined(USE_BONE_ANIMATION)\n"
"uniform mat4 u_BoneMatrix[MAX_GLSL_BONES];\n"
"#endif\n"
"\n"
"#if defined(USE_LIGHT_VECTOR)\n"
"uniform vec4   u_LightOrigin;\n"
"uniform float  u_LightRadius;\n"
"uniform vec3   u_DirectedLight;\n"
"uniform vec3   u_AmbientLight;\n"
"#endif\n"
"\n"
"#if defined(USE_PRIMARY_LIGHT) || defined(USE_SHADOWMAP)\n"
"uniform vec4  u_PrimaryLightOrigin;\n"
"uniform float u_PrimaryLightRadius;\n"
"#endif\n"
"\n"
"varying vec4   var_TexCoords;\n"
"\n"
"varying vec4   var_Color;\n"
"#if defined(USE_LIGHT_VECTOR) && !defined(USE_FAST_LIGHT)\n"
"varying vec4   var_ColorAmbient;\n"
"#endif\n"
"\n"
"#if defined(USE_LIGHT) && !defined(USE_FAST_LIGHT)\n"
"varying vec4   var_Normal;\n"
"varying vec4   var_Tangent;\n"
"varying vec4   var_Bitangent;\n"
"#endif\n"
"\n"
"#if defined(USE_LIGHT) && !defined(USE_FAST_LIGHT)\n"
"varying vec4   var_LightDir;\n"
"#endif\n"
"\n"
"#if defined(USE_PRIMARY_LIGHT) || defined(USE_SHADOWMAP)\n"
"varying vec4   var_PrimaryLightDir;\n"
"#endif\n"
"\n"
"#if defined(USE_TCGEN)\n"
"vec2 GenTexCoords(int TCGen, vec3 position, vec3 normal, vec3 TCGenVector0, vec3 TCGenVector1)\n"
"{\n"
"	vec2 tex = attr_TexCoord0.st;\n"
"\n"
"	if (TCGen == TCGEN_LIGHTMAP)\n"
"	{\n"
"		tex = attr_TexCoord1.st;\n"
"	}\n"
"	else if (TCGen == TCGEN_ENVIRONMENT_MAPPED)\n"
"	{\n"
"		vec3 viewer = normalize(u_LocalViewOrigin - position);\n"
"		vec2 ref = reflect(viewer, normal).yz;\n"
"		tex.s = ref.x * -0.5 + 0.5;\n"
"		tex.t = ref.y *  0.5 + 0.5;\n"
"	}\n"
"	else if (TCGen == TCGEN_VECTOR)\n"
"	{\n"
"		tex = vec2(dot(position, TCGenVector0), dot(position, TCGenVector1));\n"
"	}\n"
"\n"
"	return tex;\n"
"}\n"
"#endif\n"
"\n"
"#if defined(USE_TCMOD)\n"
"vec2 ModTexCoords(vec2 st, vec3 position, vec4 texMatrix, vec4 offTurb)\n"
"{\n"
"	float amplitude = offTurb.z;\n"
"	float phase = offTurb.w * 2.0 * M_PI;\n"
"	vec2 st2;\n"
"	st2.x = st.x * texMatrix.x + (st.y * texMatrix.z + offTurb.x);\n"
"	st2.y = st.x * texMatrix.y + (st.y * texMatrix.w + offTurb.y);\n"
"\n"
"	vec2 offsetPos = vec2(position.x + position.z, position.y);\n"
"\n"
"	vec2 texOffset = sin(offsetPos * (2.0 * M_PI / 1024.0) + vec2(phase));\n"
"\n"
"	return st2 + texOffset * amplitude;	\n"
"}\n"
"#endif\n"
"\n"
"\n"
"float CalcLightAttenuation(float point, float normDist)\n"
"{\n"
"	// zero light at 1.0, approximating q3 style\n"
"	// also don't attenuate directional light\n"
"	float attenuation = (0.5 * normDist - 1.5) * point + 1.0;\n"
"\n"
"	// clamp attenuation\n"
"	#if defined(NO_LIGHT_CLAMP)\n"
"	attenuation = max(attenuation, 0.0);\n"
"	#else\n"
"	attenuation = clamp(attenuation, 0.0, 1.0);\n"
"	#endif\n"
"\n"
"	return attenuation;\n"
"}\n"
"\n"
"\n"
"void main()\n"
"{\n"
"#if defined(USE_VERTEX_ANIMATION)\n"
"	vec3 position  = mix(attr_Position,    attr_Position2,    u_VertexLerp);\n"
"	vec3 normal    = mix(attr_Normal,      attr_Normal2,      u_VertexLerp);\n"
"  #if defined(USE_LIGHT) && !defined(USE_FAST_LIGHT)\n"
"	vec3 tangent   = mix(attr_Tangent.xyz, attr_Tangent2.xyz, u_VertexLerp);\n"
"  #endif\n"
"#elif defined(USE_BONE_ANIMATION)\n"
"	mat4 vtxMat  = u_BoneMatrix[int(attr_BoneIndexes.x)] * attr_BoneWeights.x;\n"
"	     vtxMat += u_BoneMatrix[int(attr_BoneIndexes.y)] * attr_BoneWeights.y;\n"
"	     vtxMat += u_BoneMatrix[int(attr_BoneIndexes.z)] * attr_BoneWeights.z;\n"
"	     vtxMat += u_BoneMatrix[int(attr_BoneIndexes.w)] * attr_BoneWeights.w;\n"
"	mat3 nrmMat = mat3(cross(vtxMat[1].xyz, vtxMat[2].xyz), cross(vtxMat[2].xyz, vtxMat[0].xyz), cross(vtxMat[0].xyz, vtxMat[1].xyz));\n"
"\n"
"	vec3 position  = vec3(vtxMat * vec4(attr_Position, 1.0));\n"
"	vec3 normal    = normalize(nrmMat * attr_Normal);\n"
"  #if defined(USE_LIGHT) && !defined(USE_FAST_LIGHT)\n"
"	vec3 tangent   = normalize(nrmMat * attr_Tangent.xyz);\n"
"  #endif\n"
"#else\n"
"	vec3 position  = attr_Position;\n"
"	vec3 normal    = attr_Normal;\n"
"  #if defined(USE_LIGHT) && !defined(USE_FAST_LIGHT)\n"
"	vec3 tangent   = attr_Tangent.xyz;\n"
"  #endif\n"
"#endif\n"
"\n"
"#if defined(USE_TCGEN)\n"
"	vec2 texCoords = GenTexCoords(u_TCGen0, position, normal, u_TCGen0Vector0, u_TCGen0Vector1);\n"
"#else\n"
"	vec2 texCoords = attr_TexCoord0.st;\n"
"#endif\n"
"\n"
"#if defined(USE_TCMOD)\n"
"	var_TexCoords.xy = ModTexCoords(texCoords, position, u_DiffuseTexMatrix, u_DiffuseTexOffTurb);\n"
"#else\n"
"	var_TexCoords.xy = texCoords;\n"
"#endif\n"
"\n"
"	gl_Position = u_ModelViewProjectionMatrix * vec4(position, 1.0);\n"
"\n"
"#if defined(USE_MODELMATRIX)\n"
"	position  = (u_ModelMatrix * vec4(position, 1.0)).xyz;\n"
"	normal    = (u_ModelMatrix * vec4(normal,   0.0)).xyz;\n"
"  #if defined(USE_LIGHT) && !defined(USE_FAST_LIGHT)\n"
"	tangent   = (u_ModelMatrix * vec4(tangent,  0.0)).xyz;\n"
"  #endif\n"
"#endif\n"
"\n"
"#if defined(USE_LIGHT) && !defined(USE_FAST_LIGHT)\n"
"	vec3 bitangent = cross(normal, tangent) * attr_Tangent.w;\n"
"#endif\n"
"\n"
"#if defined(USE_LIGHT_VECTOR)\n"
"	vec3 L = u_LightOrigin.xyz - (position * u_LightOrigin.w);\n"
"#elif defined(USE_LIGHT) && !defined(USE_FAST_LIGHT)\n"
"	vec3 L = attr_LightDirection;\n"
"  #if defined(USE_MODELMATRIX)\n"
"	L = (u_ModelMatrix * vec4(L, 0.0)).xyz;\n"
"  #endif\n"
"#endif\n"
"\n"
"#if defined(USE_LIGHTMAP)\n"
"	var_TexCoords.zw = attr_TexCoord1.st;\n"
"#endif\n"
"\n"
"	var_Color = u_VertColor * attr_Color + u_BaseColor;\n"
"\n"
"#if defined(USE_LIGHT_VECTOR)\n"
"  #if defined(USE_FAST_LIGHT)\n"
"	float sqrLightDist = dot(L, L);\n"
"	float NL = clamp(dot(normalize(normal), L) / sqrt(sqrLightDist), 0.0, 1.0);\n"
"	float attenuation = CalcLightAttenuation(u_LightOrigin.w, u_LightRadius * u_LightRadius / sqrLightDist);\n"
"\n"
"	var_Color.rgb *= u_DirectedLight * (attenuation * NL) + u_AmbientLight;\n"
"  #else\n"
"	var_ColorAmbient.rgb = u_AmbientLight * var_Color.rgb;\n"
"	var_Color.rgb *= u_DirectedLight;\n"
"    #if defined(USE_PBR)\n"
"	var_ColorAmbient.rgb *= var_ColorAmbient.rgb;\n"
"    #endif\n"
"  #endif\n"
"#endif\n"
"\n"
"#if defined(USE_LIGHT) && !defined(USE_FAST_LIGHT) && defined(USE_PBR)\n"
"	var_Color.rgb *= var_Color.rgb;\n"
"#endif\n"
"\n"
"#if defined(USE_PRIMARY_LIGHT) || defined(USE_SHADOWMAP)\n"
"	var_PrimaryLightDir.xyz = u_PrimaryLightOrigin.xyz - (position * u_PrimaryLightOrigin.w);\n"
"	var_PrimaryLightDir.w = u_PrimaryLightRadius * u_PrimaryLightRadius;\n"
"#endif\n"
"\n"
"#if defined(USE_LIGHT) && !defined(USE_FAST_LIGHT)\n"
"  #if defined(USE_LIGHT_VECTOR)\n"
"	var_LightDir = vec4(L, u_LightRadius * u_LightRadius);\n"
"  #else\n"
"	var_LightDir = vec4(L, 0.0);\n"
"  #endif\n"
"  #if defined(USE_DELUXEMAP)\n"
"	var_LightDir -= u_EnableTextures.y * var_LightDir;\n"
"  #endif\n"
"#endif\n"
"\n"
"#if defined(USE_LIGHT) && !defined(USE_FAST_LIGHT)\n"
"	vec3 viewDir = u_ViewOrigin - position;\n"
"	// store view direction in tangent space to save on varyings\n"
"	var_Normal    = vec4(normal,    viewDir.x);\n"
"	var_Tangent   = vec4(tangent,   viewDir.y);\n"
"	var_Bitangent = vec4(bitangent, viewDir.z);\n"
"#endif\n"
"}\n"
;