/*
 * Quake3 -- iOS Port
 *
 * Seth Kingsley, January 2008.
 */

#ifndef IOS_GLIMP_H
#define IOS_GLIMP_H

#include <OpenGLES/ES1/gl.h>

extern void qglArrayElement(GLint i);
extern void qglLockArraysEXT(GLint i, GLint size);
extern void qglUnlockArraysEXT(void);

enum {
	IOS_QUADS = 0x10000,
	GL_BACK_LEFT_DONT_USE=0x0402,
	GL_BACK_RIGHT_DONT_USE=0x0403,
	IOS_POLYGON
};

#undef GL_CLAMP
#define GL_CLAMP                GL_CLAMP_TO_EDGE
#undef GL_LINE
#define GL_LINE                 GL_LINE_DONT_USE
#undef GL_FILL
#define GL_FILL                 GL_FILL_DONT_USE
#undef GL_RGB5
#define GL_RGB5                 GL_RGB5_DONT_USE
#undef GL_RGB8
#define GL_RGB8                 GL_RGB8_DONT_USE
#undef GL_RGBA4
#define GL_RGBA4                GL_RGBA4_DONT_USE
#undef GL_RGBA8
#define GL_RGBA8                GL_RGBA8_DONT_USE
#undef GL_QUADS
#define GL_QUADS                IOS_QUADS
#undef GL_STENCIL_INDEX
#define GL_STENCIL_INDEX        GL_STENCIL_INDEX_DONT_USE
#undef GL_BACK_LEFT
#define GL_BACK_LEFT            GL_BACK_LEFT_DONT_USE
#undef GL_BACK_RIGHT
#define GL_BACK_RIGHT           GL_BACK_RIGHT_DONT_USE
#undef GL_DEPTH_COMPONENT
#define GL_DEPTH_COMPONENT      0 //GL_DEPTH_COMPONENT_DONT_USE
#undef GL_TEXTURE_BORDER_COLOR
#define GL_TEXTURE_BORDER_COLOR GL_TEXTURE_BORDER_COLOR_DONT_USE
#undef GL_POLYGON
#define GL_POLYGON              IOS_POLYGON
#undef GL_UNSIGNED_INT
#define GL_UNSIGNED_INT         GL_UNSIGNED_INT_DONT_USE

void qglBegin(GLenum mode);
void qglDrawBuffer(GLenum mode);
void qglEnd(void);

#define qglOrtho qglOrthof
#define qglPolygonMode(f, m)
void qglTexCoord2f(GLfloat s, GLfloat t);

#define qglVertex2f(x, y)   qglVertex3f(x, y, 0.0)
void qglVertex3f(GLfloat x, GLfloat y, GLfloat z);
void qglVertex3fv(GLfloat *v);

#define qglClipPlane qglClipPlanef
#define qglColor3f(r, g, b) qglColor4f(r, g, b, 1.0f)
void qglColor4f(GLfloat r, GLfloat g, GLfloat b, GLfloat a);
void qglColor4fv(GLfloat *v);

#define qglDepthRange qglDepthRangef
#define qglClearDepth qglClearDepthf
#define qglColor4ubv(v)     qglColor4f(v[0] / 255.0, v[1] / 255.0, v[2] / 255.0, v[3] / 255.0)
void qglTexCoord2fv(GLfloat *v);
void qglCallList(GLuint list);

void GLimp_MakeCurrent(void);

#endif // IOS_GLIMP_H
