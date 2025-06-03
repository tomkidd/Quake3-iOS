//
//  GameViewController.swift
//  Quake3-iOS
//
//  Created by Tom Kidd on 7/19/18.
//  Copyright © 2018 Tom Kidd. All rights reserved.
//

import GameController

#if os(iOS)
import CoreMotion
#endif

class GameViewController: UIViewController {
    
    var selectedMap = ""
    
    var selectedServer:Server?
    
    var selectedDifficulty = 0
    
    var botMatch = false
    var botSkill = 3.0
    
    var timeLimit = 0
    var fragLimit = 20

    var bots = [(name: String, skill: Float, icon: String)]()
    
    let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        #if os(tvOS)
        let documentsDir = try! FileManager().url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
        #else
        let documentsDir = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
        #endif
        
        // Set up baseq3 directory structure in Documents and copies pk3 files from bundle
        setupBaseq3Directory(documentsDir: documentsDir)
        
        Sys_SetHomeDir(documentsDir)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

        var argv: [String?] = [ Bundle.main.resourcePath! + "/quake3", "+set", "fs_basepath", documentsDir, "+name", self.defaults.string(forKey: "playerName")]

            if !self.selectedMap.isEmpty {
                if self.botMatch {
                    argv.append("+map")
                } else {
                    argv.append("+spmap")
                }
                argv.append(self.selectedMap)

                if !self.botMatch {
                    argv.append("+g_spSkill")
                    argv.append(String(self.selectedDifficulty))
                }
                
                // For single-player, we turn off pure servers so the absolute
                // cursor positioning can work in-game
                argv.append("+set")
                argv.append("sv_pure")
                argv.append("0")
            }
                
            if self.selectedServer != nil {
                argv.append("+connect")
                argv.append("\(self.selectedServer!.ip):\(self.selectedServer!.port)")
            }
            
            if self.botMatch {                
                for bot in self.bots {
                    argv.append("+addbot")
                    argv.append(bot.name)
                    argv.append(String(self.botSkill))
                }
                
                argv.append("+set")
                argv.append("timelimit")
                argv.append(String(self.timeLimit))
                
                argv.append("+set")
                argv.append("fraglimit")
                argv.append(String(self.fragLimit))

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
            argv.append("r_fullscreen")
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
        }
    }
    
    private func setupBaseq3Directory(documentsDir: String) {
        let fileManager = FileManager.default
        let bundlePath = Bundle.main.resourcePath!
        let documentsBaseq3Path = documentsDir + "/baseq3"
        
        do {
            // Create baseq3 directory in Documents
            try fileManager.createDirectory(atPath: documentsBaseq3Path, withIntermediateDirectories: true, attributes: nil)
            
            // Copy pk3 files from bundle to Documents/baseq3
            let bundleContents = try fileManager.contentsOfDirectory(atPath: bundlePath)
            for file in bundleContents where file.hasSuffix(".pk3") {
                let sourcePath = bundlePath + "/" + file
                let destPath = documentsBaseq3Path + "/" + file
                
                if !fileManager.fileExists(atPath: destPath) {
                    try fileManager.copyItem(atPath: sourcePath, toPath: destPath)
                    print("Copied \(file) to baseq3 directory")
                }
            }
        } catch {
            print("Error setting up baseq3 directory: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
