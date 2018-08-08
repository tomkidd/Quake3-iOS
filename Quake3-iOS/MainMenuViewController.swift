//
//  MainMenuViewController.swift
//  Quake3-iOS
//
//  Created by Tom Kidd on 8/8/18.
//  Copyright © 2018 Tom Kidd. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    let defaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.string(forKey: "playerName") == nil {
            defaults.set("unnamedPlayer", forKey: "playerName")
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitToMainMenu(segue: UIStoryboardSegue) {
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
