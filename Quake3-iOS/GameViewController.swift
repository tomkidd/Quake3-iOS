//
//  GameViewController.swift
//  Quake3-iOS
//
//  Created by Tom Kidd on 7/19/18.
//  Copyright © 2018 Tom Kidd. All rights reserved.
//

import GLKit
import GameController

#if os(iOS)
import CoreMotion
#endif

// todo: not sure if Quake 3 is gonna use these
public var gameInterrupted : Bool = false

public var startGame : Bool = false

class GameViewController: GLKViewController, GLKViewControllerDelegate {
    
    var context: EAGLContext!
    
    var joysticksInitialized = false
    
    var selectedMap = ""
    
    var selectedServer:Server?
    
    var selectedDifficulty = 0
    
    var gameInitialized = false
    
    var GUIMouseLocation = CGPoint(x: 0, y: 0)
    var GUIMouseOffset = CGSize(width: 0, height: 0)
    var mouseScale = CGPoint(x: 0, y: 0)
    let factor = UIScreen.main.scale

    #if os(iOS)
    var joystick1: JoyStickView!
    var fireButton: UIButton!
    var jumpButton: UIButton!
    @IBOutlet weak var tildeButton: UIButton!
    #endif
    
    let defaults = UserDefaults()
    
    @IBOutlet weak var nextWeaponButton: UIButton!
    @IBOutlet weak var prevWeaponButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.context = EAGLContext(api: EAGLRenderingAPI.openGLES1)!
        EAGLContext.setCurrent(self.context)
        
        if self.context == nil {
            print("Failed to create ES context")
        }
        
        let view = self.view as! GLKView
        view.context = self.context
        view.delegate = self
        self.delegate = self
        view.enableSetNeedsDisplay = true
        view.drawableDepthFormat = .format24
        view.drawableMultisample = .multisampleNone
        view.drawableColorFormat = .RGBA8888
        view.drawableStencilFormat = .format8
        view.bindDrawable()
        self.preferredFramesPerSecond = 60
        
        (UIApplication.shared.delegate as! AppDelegate).gameViewController = self
        
        
        var size = view.layer.bounds.size;
        size.width = CGFloat(roundf(Float(size.width * factor)))
        size.height = CGFloat(roundf(Float(size.height * factor)))
        if (size.width > size.height) {
            GUIMouseOffset.width = 0
            GUIMouseOffset.height = 0;
            mouseScale.x = 640 / size.width;
            mouseScale.y = 480 / size.height;
        }
        else {
            let aspect = size.height / size.width;
            
            GUIMouseOffset.width = CGFloat(-roundf(Float((480 * aspect - 640) / 2.0)));
            GUIMouseOffset.height = 0;
            mouseScale.x = (480 * aspect) / size.height;
            mouseScale.y = 480 / size.width;
        }
        
        #if os(iOS)
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        #endif
        
        #if os(tvOS)
        // note: this would prevent it from being accepted on the App Store
        
        let menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer.addTarget(self, action: #selector(GameViewController.menuButtonAction))
        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        
        self.view.addGestureRecognizer(menuPressRecognizer)
        
        #endif
        
        Sys_SetHomeDir(Bundle.main.resourcePath!)
        
        in_strafe.active = qtrue
        
        #if os(iOS)
        
        if !joysticksInitialized {
            
            let rect = view.frame
            let size = CGSize(width: 100.0, height: 100.0)
            let joystick1Frame = CGRect(origin: CGPoint(x: 50.0,
                                                        y: (rect.height - size.height - 50.0)),
                                        size: size)
            joystick1 = JoyStickView(frame: joystick1Frame)
            joystick1.delegate = self
            
            view.addSubview(joystick1)
            
            joystick1.movable = false
            joystick1.alpha = 0.5
            joystick1.baseAlpha = 0.5 // let the background bleed thru the base
            joystick1.handleTintColor = UIColor.darkGray // Colorize the handle
            
            fireButton = UIButton(frame: CGRect(x: rect.width - 155, y: rect.height - 90, width: 75, height: 75))
            fireButton.setTitle("FIRE", for: .normal)
            fireButton.setBackgroundImage(UIImage(named: "JoyStickBase")!, for: .normal)
            fireButton.addTarget(self, action: #selector(firePressed), for: .touchDown)
            fireButton.addTarget(self, action: #selector(fireReleased), for: .touchUpInside)
            fireButton.alpha = 0.5
            
            view.addSubview(fireButton)
            
            jumpButton = UIButton(frame: CGRect(x: rect.width - 90, y: rect.height - 135, width: 75, height: 75))
            jumpButton.setTitle("JUMP", for: .normal)
            jumpButton.setBackgroundImage(UIImage(named: "JoyStickBase")!, for: .normal)
            jumpButton.addTarget(self, action: #selector(jumpPressed), for: .touchDown)
            jumpButton.addTarget(self, action: #selector(jumpReleased), for: .touchUpInside)
            jumpButton.alpha = 0.5
            
            view.addSubview(jumpButton)
            
            joysticksInitialized = true
        }
        
        #endif

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // from Beben 3 init code
        
        var argv: [String?] = ["b3", "+set", "com_basegame", "baseq3", "+name", defaults.string(forKey: "playerName")]

        if !selectedMap.isEmpty {
            argv.append("+spmap")
            argv.append(selectedMap)
            argv.append("+g_spSkill")
            argv.append(String(selectedDifficulty))
        }
        
        if selectedServer != nil {
            argv.append("+connect")
            argv.append("\(selectedServer!.ip):\(selectedServer!.port)")
        }

        argv.append(nil)
        
        let argc:Int32 = Int32(argv.count - 1)
        var cargs = argv.map { $0.flatMap { UnsafeMutablePointer<Int8>(strdup($0)) } }
        
        Sys_Startup(argc, &cargs)
        
        for ptr in cargs { free(UnsafeMutablePointer(mutating: ptr)) }
        
        gameInitialized = true
    }
    
    @objc func menuButtonAction() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        if EAGLContext.current() == self.context {
            EAGLContext.setCurrent(nil)
        }

    }
    
    @objc func firePressed(sender: UIButton!) {
        MFiGameController.KeyEvent(key: K_MOUSE1, down: true)
    }
    
    @objc func fireReleased(sender: UIButton!) {
        MFiGameController.KeyEvent(key: K_MOUSE1, down: false)
    }
    
    @objc func jumpPressed(sender: UIButton!) {
        MFiGameController.KeyEvent(key: K_SPACE, down: true)
    }
    
    @objc func jumpReleased(sender: UIButton!) {
        MFiGameController.KeyEvent(key: K_SPACE, down: false)
    }

    @IBAction func snd_restart(_ sender: UIButton) {
        CL_AddReliableCommand("snd_restart", qfalse)
    }
    
    @IBAction func tilde(_ sender: UIButton) {
        CL_KeyEvent(Int32(K_CONSOLE.rawValue), qtrue, UInt32(Sys_Milliseconds()))
        CL_KeyEvent(Int32(K_CONSOLE.rawValue), qfalse, UInt32(Sys_Milliseconds()))
    }
    
    @IBAction func nextWeapon(sender: UIButton) {
        CL_KeyEvent(Int32(K_MWHEELUP.rawValue), qtrue, UInt32(Sys_Milliseconds()))
        CL_KeyEvent(Int32(K_MWHEELUP.rawValue), qfalse, UInt32(Sys_Milliseconds()))
    }
    
    @IBAction func prevWeapon(sender: UIButton) {
        CL_KeyEvent(Int32(K_MWHEELDOWN.rawValue), qtrue, UInt32(Sys_Milliseconds()))
        CL_KeyEvent(Int32(K_MWHEELDOWN.rawValue), qfalse, UInt32(Sys_Milliseconds()))
    }
    
    //MARK: GLKViewDelegate
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        
    }
    
    func handleTouches(_ touches: Set<UITouch>) {
        for touch in touches {
            var mouseLocation = CGPoint(x: 0, y: 0)
            var point = touch.location(in: view)
            
            var deltaX = 0
            var deltaY = 0
            
            if view.bounds.size.height * 480 > view.bounds.size.width * 640 {
                if point.x > view.bounds.size.width / 2 {
                    let coof = (point.x - view.bounds.size.width / 2) * 1.3
                    point.x = (view.bounds.size.width / 2 + coof)
                }
                else {
                    let coof = (view.bounds.size.width / 2 - point.x) * 1.3;
                    point.x = (view.bounds.size.width / 2 - coof);
                }
            }
            
            mouseLocation.x = point.x * factor;
            mouseLocation.y = point.y * factor;
            
            // Not quite right on iPhone X but works for now -tkidd
            deltaX = Int(roundf(Float((mouseLocation.x - GUIMouseLocation.x) * mouseScale.x)));
            deltaY = Int(roundf(Float((mouseLocation.y - GUIMouseLocation.y) * mouseScale.y)));
            
            print("ml.x: \(mouseLocation.x) gl.x: \(GUIMouseLocation.x) ms.x: \(mouseScale.x) ms.y: \(mouseScale.y)")
            
            GUIMouseLocation = mouseLocation;
            
            //                ri.Printf(PRINT_DEVELOPER, "%s: deltaX = %d, deltaY = %d\n", __PRETTY_FUNCTION__, deltaX, deltaY);
            
            CL_MouseEvent(Int32(deltaX), Int32(deltaY), Sys_Milliseconds());
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if Key_GetCatcher() & KEYCATCH_UI != 0 {
            handleTouches(touches)
        } else {
            super.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if Key_GetCatcher() & KEYCATCH_UI != 0 {
            handleTouches(touches)
        } else {
            super.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if Key_GetCatcher() & KEYCATCH_UI != 0 {
            MFiGameController.KeyEvent(key: K_MOUSE1, down: true)
            MFiGameController.KeyEvent(key: K_MOUSE1, down: false)
        } else {
            super.touchesBegan(touches, with: event)
        }
    }

    // MARK: GLKViewControllerDelegate
    
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        cl.viewangles.1 -= MFiGameController.yawValue
        cl.viewangles.0 -= MFiGameController.pitchValue
        
        if gameInitialized {
            Com_Frame();
            
            #if os(iOS)
            if Key_GetCatcher() & KEYCATCH_UI != 0 {
                joystick1.isHidden = true
                fireButton.isHidden = true
                jumpButton.isHidden = true
                prevWeaponButton.isHidden = true
                nextWeaponButton.isHidden = true
                tildeButton.isHidden = true
            } else {
                joystick1.isHidden = false
                fireButton.isHidden = false
                jumpButton.isHidden = false
                prevWeaponButton.isHidden = false
                nextWeaponButton.isHidden = false
                tildeButton.isHidden = false
            }
            #endif
            
        
        }

    }


}

#if os(iOS)
extension GameViewController: JoystickDelegate {
    
    func handleJoyStickPosition(x: CGFloat, y: CGFloat) {
        
        if y > 0 {
            cl_joyscale_y.0 = Int32(abs(y) * 60)
            MFiGameController.KeyEvent(key: K_UPARROW, down: true)
            MFiGameController.KeyEvent(key: K_DOWNARROW, down: false)
        } else if y < 0 {
            cl_joyscale_y.1 = Int32(abs(y) * 60)
            MFiGameController.KeyEvent(key: K_UPARROW, down: false)
            MFiGameController.KeyEvent(key: K_DOWNARROW, down: true)
        } else {
            cl_joyscale_y.0 = 0
            cl_joyscale_y.1 = 0
            MFiGameController.KeyEvent(key: K_UPARROW, down: false)
            MFiGameController.KeyEvent(key: K_DOWNARROW, down: false)
        }

        MFiGameController.yawValue = Float((x * 8))
    }
    
    func handleJoyStick(angle: CGFloat, displacement: CGFloat) {
        //        print("angle: \(angle) displacement: \(displacement)")
    }
    
}
#endif

