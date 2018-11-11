/*
 * Quake3 -- iOS Port
 *
 * Seth Kingsley, January 2008.
 */

#import "ios_glimp.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"
#include "../renderergl1/tr_local.h"
#pragma clang diagnostic pop

qboolean GLimp_SpawnRenderThread(void (*function)(void)) {
	return qfalse;
}

void *GLimp_RendererSleep(void) {
	return NULL;
}

void GLimp_FrontEndSleep(void) {
}

void GLimp_WakeRenderer(void *data) {
}
