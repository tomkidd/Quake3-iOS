//
//  bridging.h
//  Quake3-iOS
//
//  Created by Tom Kidd on 7/21/18.
//  Copyright © 2018 Tom Kidd. All rights reserved.
//

#ifndef bridging_h
#define bridging_h

#include "q_shared.h"
#include "keycodes.h"
#import "AppDelegate.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"
#include "SDL_uikitviewcontroller.h"
#pragma clang diagnostic pop

void Sys_Startup( int argc, char **argv );

void Com_Frame(void);

void CL_KeyEvent(int key, qboolean down, unsigned time);

void CL_AddReliableCommand(const char *cmd, qboolean isDisconnectCmd);

int Sys_Milliseconds (void);

typedef struct {
    int            down[2];        // key nums holding it down
    unsigned    downtime;        // msec timestamp
    unsigned    msec;            // msec down this frame if both a down and up happened
    qboolean    active;            // current state
    qboolean    wasPressed;        // set when down, not cleared when up
} kbutton_t;

int cl_joyscale_x[2];
int cl_joyscale_y[2];

void CL_MouseEvent( int dx, int dy, int time, qboolean absolute );

kbutton_t    in_strafe;

void Sys_SetHomeDir( const char *newHomeDir );

int Key_GetCatcher( void );

#endif /* bridging_h */
