/*
 * Quake3 -- iOS Port
 *
 * Seth Kingsley, January 2008.
 */

#import "ios_local.h"
#import <Foundation/Foundation.h>

#if TARGET_OS_TV
#import "Quake3_tvOS-Swift.h"
#else
#import "Quake3_iOS-Swift.h"
#endif


//#import "Q3Application.h"


qboolean Sys_LowPhysicalMemory(void) {
	return qtrue;
}

void Sys_UnloadGame() {
#ifdef IOS_USE_THREADS
	[[Q3Application sharedApplication] performSelectorOnMainThread:@selector(unloadGame:)
	                                                    withObject:nil
	                                                 waitUntilDone:YES];
#else
//    [(Q3Application *)[Q3Application sharedApplication] unloadGame];
    [(AppDelegate *)UIApplication.sharedApplication.delegate unloadGame];
#endif // IOS_USE_THREADS
}

void Sys_Error(const char *error, ...) {
	extern void Sys_Exit(int ex);
    
	NSString *errorString;
	va_list ap;
    
	va_start(ap, error);
	errorString = [[NSString alloc] initWithFormat:[NSString stringWithCString:error encoding:NSUTF8StringEncoding]
	                                      arguments:ap];
	va_end(ap);
#ifdef IOS_USE_THREADS
	[[Q3Application sharedApplication] performSelectorOnMainThread:@selector(presentErrorMessage:)
	                                                    withObject:errorString
	                                                 waitUntilDone:YES];
#else
//    [(Q3Application *)[Q3Application sharedApplication] presentErrorMessage : errorString];
    [(AppDelegate *)UIApplication.sharedApplication.delegate presentErrorMessageWithErrorMessage: errorString];

#endif // IOS_USE_THREADS
    
	Sys_UnloadGame();
}

void Sys_Warn(const char *warning, ...) {
	NSString *warningString;
	va_list ap;
    
	va_start(ap, warning);
	warningString = [[NSString alloc] initWithFormat:[NSString stringWithCString:warning encoding:NSUTF8StringEncoding]
	                                        arguments:ap];
	va_end(ap);
#ifdef IOS_USE_THREADS
	[[Q3Application sharedApplication] performSelectorOnMainThread:@selector(presentWarningMessage:)
	                                                    withObject:warningString waitUntilDone:YES];
#else
//    [(Q3Application *)[Q3Application sharedApplication] presentWarningMessage : warningString];
    [(AppDelegate *)UIApplication.sharedApplication.delegate presentWarningMessageWithWarningMessage: warningString];
#endif // IOS_USE_THREADS
}

int qmain(int ac, char *av[]) {
//    NSAutoreleasePool *pool = [NSAutoreleasePool new];
	UIApplicationMain(ac, av, nil, NSStringFromClass([AppDelegate class]));
    
//    [pool release];
	return 0;
}
