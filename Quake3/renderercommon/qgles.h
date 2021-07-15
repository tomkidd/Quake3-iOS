/*
===========================================================================
ioquake3 png decoder
Copyright (C) 2021 Tom Kidd

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
===========================================================================
*/

#ifndef __QGLES_H__
#define __QGLES_H__

typedef unsigned int            GLenum;
#define APIENTRYP APIENTRY *
typedef float                                       GLfloat;    /* single precision float */
typedef double                                      GLdouble;    /* double precision float */
typedef double                                      GLclampd;    /* double precision float in [0,1] */
#define GL_FILL                                     0x1B02
#define GL_NUM_EXTENSIONS                           0x821D
#define GL_BACK_LEFT                                0x0402
#define GL_BACK_RIGHT                               0x0403
#define GL_DEPTH_COMPONENT                          0x1902
#define GL_TEXTURE0_ARB                             0x84C0
#define GL_TEXTURE1_ARB                             0x84C1
#define GL_LINE                                     0x1B01
#define GL_RGB8                                     0x8051
#define GL_CLAMP                                    0x2900
#define GL_STENCIL_INDEX                            0x1901
#define GL_COMPRESSED_SRGB_ALPHA_S3TC_DXT1_EXT      0x8C4D
#define GL_COMPRESSED_SRGB_ALPHA_S3TC_DXT5_EXT      0x8C4F
#define GL_COMPRESSED_LUMINANCE_ALPHA_LATC2_EXT     0x8C72
#define GL_COMPRESSED_RGBA_S3TC_DXT1_EXT            0x83F1
#define GL_COMPRESSED_RGBA_S3TC_DXT5_EXT            0x83F3
#define GL_RGB4_S3TC                                0x83A1
#define GL_RGBA4                                    0x8056
#define GL_RGBA8                                    0x8058
#define GL_LUMINANCE8                               0x8040
#define GL_RGB5                                     0x8050
#define GL_LUMINANCE8_ALPHA8                        0x8045
#define GL_SRGB_EXT                                 0x8C40
#define GL_SRGB8_EXT                                0x8C41
#define GL_SRGB_ALPHA_EXT                           0x8C42
#define GL_SRGB8_ALPHA8_EXT                         0x8C43
#define GL_SLUMINANCE_EXT                           0x8C46
#define GL_SLUMINANCE8_EXT                          0x8C47
#define GL_SLUMINANCE_ALPHA_EXT                     0x8C44
#define GL_SLUMINANCE8_ALPHA8_EXT                   0x8C45
#define GL_MAX_TEXTURE_UNITS_ARB                    0x84E2

#endif /* __QGLES_H__ */
