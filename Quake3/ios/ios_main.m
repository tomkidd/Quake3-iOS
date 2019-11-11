/*
 * Quake3 -- iOS Port
 *
 * Seth Kingsley, January 2008.
 */

#if TARGET_OS_TV
#import "Quake3_tvOS-Swift.h"
#else
#import "Quake3_iOS-Swift.h"
#endif

qboolean Sys_LowPhysicalMemory(void) {
	return qtrue;
}

void Sys_UnloadGame() {
}

void Sys_Error(const char *error, ...) {
	extern void Sys_Exit(int ex);
    
	NSString *errorString;
	va_list ap;
    
	va_start(ap, error);
	errorString = [[NSString alloc] initWithFormat:[NSString stringWithCString:error encoding:NSUTF8StringEncoding]
	                                      arguments:ap];
	va_end(ap);

    Sys_UnloadGame();
    
    exit(1);
}

void Sys_Warn(const char *warning, ...) {
	NSString *warningString;
	va_list ap;
    
	va_start(ap, warning);
	warningString = [[NSString alloc] initWithFormat:[NSString stringWithCString:warning encoding:NSUTF8StringEncoding]
	                                        arguments:ap];
	va_end(ap);
}
