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
        
        //performSegue(withIdentifier: "MozartsGhostSegue", sender: nil)

        // Do any additional setup after loading the view.
    }
    
    func extractFile(pk3: String, source: String, destination: String) {
        let fileManager = FileManager()
        let currentWorkingPath = fileManager.currentDirectoryPath
        var destinationURL = URL(fileURLWithPath: currentWorkingPath)
        destinationURL.appendPathComponent(destination)
        
        if fileManager.fileExists(atPath: destinationURL.path) {
            return
        }
        
        var archiveURL = URL(fileURLWithPath: currentWorkingPath)
        archiveURL.appendPathComponent(pk3)
        guard let archive = Archive(url: archiveURL, accessMode: .read) else  {
            return
        }
        guard let entry = archive[source] else {
            return
        }
        do {
            let _ = try archive.extract(entry, to: destinationURL)
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
