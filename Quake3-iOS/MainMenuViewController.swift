//
//  MainMenuViewController.swift
//  Quake3-iOS
//
//  Created by Tom Kidd on 8/8/18.
//  Copyright © 2018 Tom Kidd. All rights reserved.
//

import UIKit
import ZIPFoundation

class MainMenuViewController: UIViewController {

    let defaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.string(forKey: "playerName") == nil {
            defaults.set("unnamedPlayer", forKey: "playerName")
        }
        
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3CTF1.jpg", destination: "graphics/Q3CTF1.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3CTF2.jpg", destination: "graphics/Q3CTF2.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3CTF3.jpg", destination: "graphics/Q3CTF3.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3CTF4.jpg", destination: "graphics/Q3CTF4.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM0.jpg", destination: "graphics/Q3DM0.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM1.jpg", destination: "graphics/Q3DM1.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM10.jpg", destination: "graphics/Q3DM10.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM11.jpg", destination: "graphics/Q3DM11.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM12.jpg", destination: "graphics/Q3DM12.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM13.jpg", destination: "graphics/Q3DM13.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM14.jpg", destination: "graphics/Q3DM14.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM15.jpg", destination: "graphics/Q3DM15.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM16.jpg", destination: "graphics/Q3DM16.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM17.jpg", destination: "graphics/Q3DM17.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM18.jpg", destination: "graphics/Q3DM18.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM19.jpg", destination: "graphics/Q3DM19.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM2.jpg", destination: "graphics/Q3DM2.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM3.jpg", destination: "graphics/Q3DM3.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM4.jpg", destination: "graphics/Q3DM4.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM5.jpg", destination: "graphics/Q3DM5.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM6.jpg", destination: "graphics/Q3DM6.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM7.jpg", destination: "graphics/Q3DM7.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM8.jpg", destination: "graphics/Q3DM8.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3DM9.jpg", destination: "graphics/Q3DM9.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3TOURNEY1.jpg", destination: "graphics/Q3TOURNEY1.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3TOURNEY2.jpg", destination: "graphics/Q3TOURNEY2.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3TOURNEY3.jpg", destination: "graphics/Q3TOURNEY3.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3TOURNEY4.jpg", destination: "graphics/Q3TOURNEY4.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3TOURNEY5.jpg", destination: "graphics/Q3TOURNEY5.jpg")
        extractFile(pk3: "baseq3/pak0.pk3", source: "levelshots/Q3TOURNEY6.jpg", destination: "graphics/Q3TOURNEY6.jpg")
        
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/anarki/icon_blue.tga", destination: "graphics/anarki/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/anarki/icon_default.tga", destination: "graphics/anarki/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/anarki/icon_red.tga", destination: "graphics/anarki/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/biker/icon_blue.tga", destination: "graphics/biker/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/biker/icon_cadavre.tga", destination: "graphics/biker/icon_cadavre.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/biker/icon_default.tga", destination: "graphics/biker/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/biker/icon_hossman.tga", destination: "graphics/biker/icon_hossman.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/biker/icon_red.tga", destination: "graphics/biker/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/biker/icon_slammer.tga", destination: "graphics/biker/icon_slammer.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/biker/icon_stroggo.tga", destination: "graphics/biker/icon_stroggo.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/bitterman/icon_blue.tga", destination: "graphics/bitterman/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/bitterman/icon_default.tga", destination: "graphics/bitterman/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/bitterman/icon_red.tga", destination: "graphics/bitterman/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/bones/icon_blue.tga", destination: "graphics/bones/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/bones/icon_bones.tga", destination: "graphics/bones/icon_bones.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/bones/icon_default.tga", destination: "graphics/bones/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/bones/icon_red.tga", destination: "graphics/bones/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/crash/icon_blue.tga", destination: "graphics/crash/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/crash/icon_default.tga", destination: "graphics/crash/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/crash/icon_red.tga", destination: "graphics/crash/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/doom/icon_blue.tga", destination: "graphics/doom/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/doom/icon_default.tga", destination: "graphics/doom/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/doom/icon_phobos.tga", destination: "graphics/doom/icon_phobos.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/doom/icon_red.tga", destination: "graphics/doom/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/grunt/icon_blue.tga", destination: "graphics/grunt/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/grunt/icon_default.tga", destination: "graphics/grunt/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/grunt/icon_red.tga", destination: "graphics/grunt/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/grunt/icon_stripe.tga", destination: "graphics/grunt/icon_stripe.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/hunter/icon_blue.tga", destination: "graphics/hunter/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/hunter/icon_default.tga", destination: "graphics/hunter/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/hunter/icon_harpy.tga", destination: "graphics/hunter/icon_harpy.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/hunter/icon_red.tga", destination: "graphics/hunter/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/keel/icon_blue.tga", destination: "graphics/keel/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/keel/icon_default.tga", destination: "graphics/keel/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/keel/icon_red.tga", destination: "graphics/keel/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/klesk/icon_blue.tga", destination: "graphics/klesk/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/klesk/icon_default.tga", destination: "graphics/klesk/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/klesk/icon_flisk.tga", destination: "graphics/klesk/icon_flisk.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/klesk/icon_red.tga", destination: "graphics/klesk/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/lucy/icon_angel.tga", destination: "graphics/lucy/icon_angel.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/lucy/icon_blue.tga", destination: "graphics/lucy/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/lucy/icon_default.tga", destination: "graphics/lucy/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/lucy/icon_red.tga", destination: "graphics/lucy/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/major/icon_blue.tga", destination: "graphics/major/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/major/icon_daemia.tga", destination: "graphics/major/icon_daemia.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/major/icon_default.tga", destination: "graphics/major/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/major/icon_red.tga", destination: "graphics/major/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/mynx/icon_blue.tga", destination: "graphics/mynx/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/mynx/icon_default.tga", destination: "graphics/mynx/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/mynx/icon_red.tga", destination: "graphics/mynx/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/orbb/icon_blue.tga", destination: "graphics/orbb/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/orbb/icon_default.tga", destination: "graphics/orbb/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/orbb/icon_red.tga", destination: "graphics/orbb/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/ranger/icon_blue.tga", destination: "graphics/ranger/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/ranger/icon_default.tga", destination: "graphics/ranger/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/ranger/icon_red.tga", destination: "graphics/ranger/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/ranger/icon_wrack.tga", destination: "graphics/ranger/icon_wrack.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/razor/icon_blue.tga", destination: "graphics/razor/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/razor/icon_default.tga", destination: "graphics/razor/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/razor/icon_id.tga", destination: "graphics/razor/icon_id.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/razor/icon_patriot.tga", destination: "graphics/razor/icon_patriot.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/razor/icon_red.tga", destination: "graphics/razor/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/sarge/icon_blue.tga", destination: "graphics/sarge/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/sarge/icon_default.tga", destination: "graphics/sarge/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/sarge/icon_krusade.tga", destination: "graphics/sarge/icon_krusade.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/sarge/icon_red.tga", destination: "graphics/sarge/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/sarge/icon_roderic.tga", destination: "graphics/sarge/icon_roderic.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/slash/icon_blue.tga", destination: "graphics/slash/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/slash/icon_default.tga", destination: "graphics/slash/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/slash/icon_grrl.tga", destination: "graphics/slash/icon_grrl.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/slash/icon_red.tga", destination: "graphics/slash/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/slash/icon_yuriko.tga", destination: "graphics/slash/icon_yuriko.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/sorlag/icon_blue.tga", destination: "graphics/sorlag/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/sorlag/icon_default.tga", destination: "graphics/sorlag/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/sorlag/icon_red.tga", destination: "graphics/sorlag/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/tankjr/icon_blue.tga", destination: "graphics/tankjr/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/tankjr/icon_default.tga", destination: "graphics/tankjr/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/tankjr/icon_red.tga", destination: "graphics/tankjr/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/uriel/icon_blue.tga", destination: "graphics/uriel/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/uriel/icon_default.tga", destination: "graphics/uriel/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/uriel/icon_red.tga", destination: "graphics/uriel/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/uriel/icon_zael.tga", destination: "graphics/uriel/icon_zael.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/visor/icon_blue.tga", destination: "graphics/visor/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/visor/icon_default.tga", destination: "graphics/visor/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/visor/icon_gorre.tga", destination: "graphics/visor/icon_gorre.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/visor/icon_red.tga", destination: "graphics/visor/icon_red.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/xaero/icon_blue.tga", destination: "graphics/xaero/icon_blue.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/xaero/icon_default.tga", destination: "graphics/xaero/icon_default.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "models/players/xaero/icon_red.tga", destination: "graphics/xaero/icon_red.tga")
        extractFile(pk3: "baseq3/pak2.pk3", source: "models/players/brandon/icon_default.tga", destination: "graphics/brandon/icon_default.tga")
        extractFile(pk3: "baseq3/pak2.pk3", source: "models/players/carmack/icon_default.tga", destination: "graphics/carmack/icon_default.tga")
        extractFile(pk3: "baseq3/pak2.pk3", source: "models/players/cash/icon_default.tga", destination: "graphics/cash/icon_default.tga")
        extractFile(pk3: "baseq3/pak2.pk3", source: "models/players/paulj/icon_default.tga", destination: "graphics/paulj/icon_default.tga")
        extractFile(pk3: "baseq3/pak2.pk3", source: "models/players/tim/icon_default.tga", destination: "graphics/tim/icon_default.tga")
        extractFile(pk3: "baseq3/pak2.pk3", source: "models/players/xian/icon_default.tga", destination: "graphics/xian/icon_default.tga")
        
        extractFile(pk3: "baseq3/pak0.pk3", source: "menu/art/skill1.tga", destination: "graphics/menu/art/skill1.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "menu/art/skill2.tga", destination: "graphics/menu/art/skill2.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "menu/art/skill3.tga", destination: "graphics/menu/art/skill3.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "menu/art/skill4.tga", destination: "graphics/menu/art/skill4.tga")
        extractFile(pk3: "baseq3/pak0.pk3", source: "menu/art/skill5.tga", destination: "graphics/menu/art/skill5.tga")

        
        //performSegue(withIdentifier: "MozartsGhostSegue", sender: nil)

        // Do any additional setup after loading the view.
    }
    
    func extractFile(pk3: String, source: String, destination: String) {
        let fileManager = FileManager()
        #if os(tvOS)
        let documentsDir = try! FileManager().url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
        #else
        let documentsDir = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
        #endif

        var destinationURL = URL(fileURLWithPath: documentsDir)
        destinationURL.appendPathComponent(destination)
        
        if fileManager.fileExists(atPath: destinationURL.path) {
            print("File already exists at \(destinationURL.path)")
            return
        }
        
        // Look for PK3 files in Documents/baseq3 directory
        var archiveURL = URL(fileURLWithPath: documentsDir)
        archiveURL.appendPathComponent(pk3)
        
        // If PK3 doesn't exist in Documents, try app bundle as fallback
        if !fileManager.fileExists(atPath: archiveURL.path) {
            print("PK3 not found at \(archiveURL.path), trying app bundle...")
            if let bundlePath = Bundle.main.resourcePath {
                archiveURL = URL(fileURLWithPath: bundlePath)
                archiveURL.appendPathComponent(pk3)
            }
        }
        
        print("Attempting to open archive at: \(archiveURL.path)")
        guard let archive = Archive(url: archiveURL, accessMode: .read) else  {
            print("Could not open archive at path: \(archiveURL.path)")
            return
        }
        guard let entry = archive[source] else {
            print("Could not find entry '\(source)' in archive \(archiveURL.path)")
            return
        }
        
        // Create directory structure if needed
        let destinationDir = destinationURL.deletingLastPathComponent()
        do {
            try fileManager.createDirectory(at: destinationDir, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Failed to create directory \(destinationDir.path): \(error)")
        }
        
        do {
            let _ = try archive.extract(entry, to: destinationURL)
            print("Successfully extracted \(source) to \(destinationURL.path)")
        } catch {
            print("Extracting entry from archive failed with error:\(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitToMainMenu(segue: UIStoryboardSegue) {
    }

}
