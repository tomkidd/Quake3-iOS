//
//  AppDelegate.m
//  Quake2-iOS
//
//  Created by Tom Kidd on 1/26/19.
//

#import "AppDelegate.h"
#import <GameController/GameController.h>
#if TARGET_OS_TV
#import "Quake3_tvOS-Swift.h"
#else
#import "Quake3_iOS-Swift.h"
#endif

@implementation SDLUIKitDelegate (customDelegate)

// hijack the the SDL_UIKitAppDelegate to use the UIApplicationDelegate we implement here
+ (NSString *)getAppDelegateClassName {
    return @"AppDelegate";
}

@end

@implementation AppDelegate
@synthesize rootNavigationController, uiwindow, gameViewControllerView;

#pragma mark -
#pragma mark AppDelegate methods
- (id)init {
    if ((self = [super init])) {
        rootNavigationController = nil;
        uiwindow = nil;
    }
    return self;
}


// override the direct execution of SDL_main to allow us to implement our own frontend
- (void)postFinishLaunch
{
    [self performSelector:@selector(hideLaunchScreen) withObject:nil afterDelay:0.0];

#if !TARGET_OS_TV
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
#endif
    
    self.uiwindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.uiwindow.backgroundColor = [UIColor blackColor];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];

    rootNavigationController = (UINavigationController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"RootNC"];

    self.uiwindow.rootViewController = self.rootNavigationController;
    
    NSLog(@"postFinishLaunch\n");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controllerDidConnect:) name:@"GCControllerDidConnectNotification" object:nil];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controllerDidDisconnect:) name:@"GCControllerDidDisconnectNotification" object:nil];
    
    [self.uiwindow makeKeyAndVisible];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [super applicationDidReceiveMemoryWarning:application];
}

// true multitasking with SDL works only on 4.2 and above; we close the game to avoid a black screen at return
- (void)applicationWillResignActive:(UIApplication *)application {
    [super applicationWillResignActive:application];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [super applicationDidFinishLaunching:application];
}

- (void) controllerDidConnect:(NSNotification *) notification
{
    [MFiGameController connect:(GCController *)notification.object];
}

- (void) controllerDidDisconnect:(NSNotification *) notification
{
    [MFiGameController disconnect:(GCController *)notification.object];
}

// dummy function to prevent linkage fail
int SDL_main(int argc, char **argv) {
    return 0;
}

@end
