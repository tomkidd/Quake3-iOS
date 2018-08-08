//
//  MFiGameController.swift
//  Quake3-iOS
//
//  Created by Tom Kidd on 7/25/18.
//  Copyright © 2018 Tom Kidd. All rights reserved.
//

import Foundation
import GameController

public var remote: GCController? = nil

class MFiGameController: NSObject
{
    static var pitchValue:Float = 0.0
    static var yawValue:Float = 0.0

    static func connect(_ controller: GCController?)
    {
        for controller in GCController.controllers()
        {
            if controller.extendedGamepad != nil && remote == nil
            {
                remote = controller
                
                remote!.playerIndex = .index1
                
                remote!.controllerPausedHandler = { (controller: GCController) -> () in
                    KeyEvent(key: K_ESCAPE, down: true)
                    KeyEvent(key: K_ESCAPE, down: false)
                }
                
//                remote!.extendedGamepad!.dpad.up.pressedChangedHandler = { (button: GCControllerButtonInput, value: Float, pressed: Bool) -> () in
//
//                    Sys_Key_Event(128, qboolean(pressed ? 1 : 0)) // K_UPARROW, true / false
//                }
//
//
//                remote!.extendedGamepad!.dpad.left.pressedChangedHandler = { (button: GCControllerButtonInput, value: Float, pressed: Bool) -> () in
//
//                    Sys_Key_Event(130, qboolean(pressed ? 1 : 0)) // K_LEFTARROW, true / false
//
//                }
//
//                remote!.extendedGamepad!.dpad.right.pressedChangedHandler = { (button: GCControllerButtonInput, value: Float, pressed: Bool) -> () in
//
//                    Sys_Key_Event(131, qboolean(pressed ? 1 : 0)) // K_RIGHTARROW, true / false
//
//                }
//
//                remote!.extendedGamepad!.dpad.down.pressedChangedHandler = { (button: GCControllerButtonInput, value: Float, pressed: Bool) -> () in
//
//                    Sys_Key_Event(129, qboolean(pressed ? 1 : 0)) // K_DOWNARROW, true / false
//
//                }
                
                remote!.extendedGamepad!.buttonA.pressedChangedHandler = { (button: GCControllerButtonInput, value: Float, pressed: Bool) -> () in
                    KeyEvent(key: K_SPACE, down: pressed)
                }
                
                remote!.extendedGamepad!.buttonB.pressedChangedHandler = { (button: GCControllerButtonInput, value: Float, pressed: Bool) -> () in
                    
                    //                    Sys_Key_Event(27, qboolean(pressed ? 1 : 0)) // K_ESCAPE, true / false
                    
                }
                
                remote!.extendedGamepad!.buttonY.pressedChangedHandler = { (button: GCControllerButtonInput, value: Float, pressed: Bool) -> () in
                    
                }
                
                remote!.extendedGamepad!.leftThumbstick.xAxis.valueChangedHandler = { (button: GCControllerAxisInput, value: Float) -> () in
                    
                    if (value > 0) {
                        cl_joyscale_x.0 = Int32(fabsf(value) * 60)
                        KeyEvent(key: K_LEFTARROW, down: false)
                        KeyEvent(key: K_RIGHTARROW, down: true)
                    }
                    else if (value < 0) {
                        cl_joyscale_x.1 = Int32(fabsf(value) * 60)
                        KeyEvent(key: K_LEFTARROW, down: true)
                        KeyEvent(key: K_RIGHTARROW, down: false)
                    }
                    else {
                        cl_joyscale_x.0 = 0
                        cl_joyscale_x.1 = 0
                        KeyEvent(key: K_LEFTARROW, down: false)
                        KeyEvent(key: K_RIGHTARROW, down: false)
                    }
                    
                }
                
                remote!.extendedGamepad!.leftThumbstick.yAxis.valueChangedHandler = { (button: GCControllerAxisInput, value: Float) -> () in
                    
                    if (value > 0) {
                        cl_joyscale_y.0 = Int32(fabsf(value) * 60)
                        KeyEvent(key: K_UPARROW, down: true)
                        KeyEvent(key: K_DOWNARROW, down: false)
                    }
                    else if (value < 0) {
                        cl_joyscale_y.1 = Int32(fabsf(value) * 60)
                        KeyEvent(key: K_UPARROW, down: false)
                        KeyEvent(key: K_DOWNARROW, down: true)
                    }
                    else {
                        cl_joyscale_y.0 = 0
                        cl_joyscale_y.1 = 0
                        KeyEvent(key: K_UPARROW, down: false)
                        KeyEvent(key: K_DOWNARROW, down: false)
                    }
                    
                }
                
                remote!.extendedGamepad!.rightThumbstick.xAxis.valueChangedHandler = { (button: GCControllerAxisInput, value: Float) -> () in
                    yawValue = (value * 8)
                }
                
                remote!.extendedGamepad!.rightThumbstick.yAxis.valueChangedHandler = { (button: GCControllerAxisInput, value: Float) -> () in
                    pitchValue = (value * 8)
                }
                
                remote!.extendedGamepad!.rightTrigger.pressedChangedHandler = { (button: GCControllerButtonInput, value: Float, pressed: Bool) -> () in
                    
                    KeyEvent(key: K_MOUSE1, down: pressed)
                    
                }
                
                remote!.extendedGamepad!.rightShoulder.pressedChangedHandler = { (button: GCControllerButtonInput, value: Float, pressed: Bool) -> () in
                    KeyEvent(key: K_MWHEELUP, down: pressed)
                }
                
                remote!.extendedGamepad!.leftShoulder.pressedChangedHandler = { (button: GCControllerButtonInput, value: Float, pressed: Bool) -> () in
                    KeyEvent(key: K_MWHEELDOWN, down: pressed)
                }

                break
            }
        }
    }
    
    static func disconnect(_ controller: GCController?)
    {
        if remote == controller
        {
            pitchValue = 0
            yawValue = 0
            KeyEvent(key: K_UPARROW, down: false)
            KeyEvent(key: K_DOWNARROW, down: false)
            KeyEvent(key: K_LEFTARROW, down: false)
            KeyEvent(key: K_RIGHTARROW, down: false)
            KeyEvent(key: K_MOUSE1, down: false)
            KeyEvent(key: K_ESCAPE, down: false)
            
            remote = nil
        }
    }
    
    static func KeyEvent(key: keyNum_t, down: Bool) {
        CL_KeyEvent(Int32(key.rawValue), qboolean(rawValue: down ? 1 : 0), UInt32(Sys_Milliseconds()))
    }
    
}
