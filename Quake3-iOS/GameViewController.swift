//
//  GameViewController.swift
//  Quake3-iOS
//
//  Created by Tom Kidd on 7/19/18.
//  Copyright © 2018 Tom Kidd. All rights reserved.
//

//import GameController

#if os(iOS)
import CoreMotion
#endif

class GameViewController: UIViewController {
    
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

        (UIApplication.shared.delegate as! AppDelegate).gameViewControllerView = self.view

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
        
        let documentsDir = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
        
        Sys_SetHomeDir(documentsDir)
        
        // Come back to this later -tkidd
//        in_strafe.active = qtrue
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

        var argv: [String?] = [ Bundle.main.resourcePath! + "/quake3", "+set", "com_basegame", "baseq3", "+name", self.defaults.string(forKey: "playerName")]

            if !self.selectedMap.isEmpty {
                argv.append("+spmap")
                argv.append(self.selectedMap)
                argv.append("+g_spSkill")
                argv.append(String(self.selectedDifficulty))
            }
                
            if self.selectedServer != nil {
                argv.append("+connect")
                argv.append("\(self.selectedServer!.ip):\(self.selectedServer!.port)")
            }
            
            // not sure if needed
            argv.append("+set")
            argv.append("r_useOpenGLES")
            argv.append("1")
            
            let screenBounds = UIScreen.main.bounds
            let screenScale:CGFloat = UIScreen.main.scale
            let screenSize = CGSize(width: screenBounds.size.width * screenScale, height: screenBounds.size.height * screenScale)

            argv.append("+set")
            argv.append("r_mode")
            argv.append("-1")

            argv.append("+set")
            argv.append("r_customwidth")
            argv.append("\(screenSize.width)")

            argv.append("+set")
            argv.append("r_customheight")
            argv.append("\(screenSize.height)")

            argv.append("+set")
            argv.append("s_sdlSpeed")
            argv.append("44100")
            
            argv.append("+set")
            argv.append("r_useHiDPI")
            argv.append("1")
            
            argv.append("+set")
            argv.append("in_joystick")
            argv.append("1")
            
            argv.append("+set")
            argv.append("in_joystickUseAnalog")
            argv.append("1")
            
            argv.append("+bind")
            argv.append("PAD0_RIGHTTRIGGER")
            argv.append("\"+attack\"")
            
            argv.append("+bind")
            argv.append("PAD0_LEFTSTICK_UP")
            argv.append("\"+forward\"")
            
            argv.append("+bind")
            argv.append("PAD0_LEFTSTICK_DOWN")
            argv.append("\"+back\"")
            
            argv.append("+bind")
            argv.append("PAD0_LEFTSTICK_LEFT")
            argv.append("\"+moveleft\"")
            
            argv.append("+bind")
            argv.append("PAD0_LEFTSTICK_RIGHT")
            argv.append("\"+moveright\"")
            
            argv.append("+bind")
            argv.append("PAD0_RIGHTSTICK_UP")
            argv.append("\"+lookup\"")
            
            argv.append("+bind")
            argv.append("PAD0_RIGHTSTICK_DOWN")
            argv.append("\"+lookdown\"")
            
            argv.append("+bind")
            argv.append("PAD0_RIGHTSTICK_LEFT")
            argv.append("\"+left\"")
            
            argv.append("+bind")
            argv.append("PAD0_RIGHTSTICK_RIGHT")
            argv.append("\"+right\"")
            
            argv.append("+bind")
            argv.append("PAD0_A")
            argv.append("\"+moveup\"")
            
            argv.append("+bind")
            argv.append("PAD0_LEFTSHOULDER")
            argv.append("\"weapnext\"")
            
            argv.append("+bind")
            argv.append("PAD0_RIGHTSHOULDER")
            argv.append("\"weapprev\"")
            
            #if DEBUG
            argv.append("+set")
            argv.append("developer")
            argv.append("1")
            #endif
            
            argv.append(nil)
            
            let argc:Int32 = Int32(argv.count - 1)
            var cargs = argv.map { $0.flatMap { UnsafeMutablePointer<Int8>(strdup($0)) } }
            
            Sys_Startup(argc, &cargs)
            
            for ptr in cargs { free(UnsafeMutablePointer(mutating: ptr)) }
                
           self.gameInitialized = true
        }
    }
    
    @objc func menuButtonAction() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
}
