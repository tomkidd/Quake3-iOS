//
//  sys_ios.m
//  Quake3-iOS
//
//  Created by Tom Kidd on 11/11/19.
//  Copyright © 2019 Tom Kidd. All rights reserved.
//  Some portions originally Seth Kingsley, January 2008.

#import <Foundation/Foundation.h>
#include "sys_local.h"

#if TARGET_OS_TV
#import "Quake3_tvOS-Swift.h"
#else
#import "Quake3_iOS-Swift.h"
#endif

#include <SDL2/SDL_syswm.h>


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

UIViewController* GetSDLViewController(SDL_Window *sdlWindow) {
    SDL_SysWMinfo systemWindowInfo;
    SDL_VERSION(&systemWindowInfo.version);
    if ( ! SDL_GetWindowWMInfo(sdlWindow, &systemWindowInfo)) {
        // error handle?
        return nil;
    }
    UIWindow *appWindow = systemWindowInfo.info.uikit.window;
    UIViewController *rootVC = appWindow.rootViewController;
    return rootVC;
}

void Sys_AddControls(SDL_Window *sdlWindow) {
    #if !TARGET_OS_TV
        // adding on-screen controls -tkidd
        SDL_uikitviewcontroller *rootVC = (SDL_uikitviewcontroller *)GetSDLViewController(sdlWindow);
        NSLog(@"root VC = %@",rootVC);

        [rootVC.view addSubview:[rootVC fireButtonWithRect:[rootVC.view frame]]];
        [rootVC.view addSubview:[rootVC jumpButtonWithRect:[rootVC.view frame]]];
        [rootVC.view addSubview:[rootVC joyStickWithRect:[rootVC.view frame]]];
        [rootVC.view addSubview:[rootVC buttonStackWithRect:[rootVC.view frame]]];
        [rootVC.view addSubview:[rootVC f1ButtonWithRect:[rootVC.view frame]]];
        [rootVC.view addSubview:[rootVC prevWeaponButtonWithRect:[rootVC.view frame]]];
        [rootVC.view addSubview:[rootVC nextWeaponButtonWithRect:[rootVC.view frame]]];
    #endif
}
