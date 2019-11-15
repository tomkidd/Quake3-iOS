//
//  sys_ios.m
//  Quake3-iOS
//
//  Created by Tom Kidd on 11/11/19.
//  Copyright © 2019 Tom Kidd. All rights reserved.
//  Some portions originally Seth Kingsley, January 2008.

#import <Foundation/Foundation.h>
#include "sys_local.h"
#include "qcommon.h"

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

void GLimp_SetGamma( unsigned char red[256], unsigned char green[256], unsigned char blue[256] )
{
    // unused in iOS
}

/*
 =================
 Sys_StripAppBundle
 
 Discovers if passed dir is suffixed with the directory structure of an iOS
 .app bundle. If it is, the .app directory structure is stripped off the end and
 the result is returned. If not, dir is returned untouched.
 =================
 */
char *Sys_StripAppBundle( char *dir )
{
    static char cwd[MAX_OSPATH];
    
    Q_strncpyz(cwd, dir, sizeof(cwd));
    if(!strstr(Sys_Basename(cwd), ".app"))
        return dir;
    Q_strncpyz(cwd, Sys_Dirname(cwd), sizeof(cwd));
    return cwd;
}

/*
 ==============
 Sys_Dialog
 ==============
 */
dialogResult_t Sys_Dialog( dialogType_t type, const char *message, const char *title ) { return NULL; }
