//
//  DifficultyViewController.swift
//  Quake3-iOS
//
//  Created by Tom Kidd on 7/28/18.
//  Copyright © 2018 Tom Kidd. All rights reserved.
//

import UIKit

class DifficultyViewController: UIViewController {
    
    var selectedMap = ""
    var selectedMapName = ""
    var selectedDifficulty = 0
    
    @IBAction func difficulty1(_ sender: UIButton) {
        selectedDifficulty = 1
        performSegue(withIdentifier: "GameSegue", sender: self)
    }
    
    @IBAction func difficulty2(_ sender: UIButton) {
        selectedDifficulty = 2
        performSegue(withIdentifier: "GameSegue", sender: self)
    }

    @IBAction func difficulty3(_ sender: UIButton) {
        selectedDifficulty = 3
        performSegue(withIdentifier: "GameSegue", sender: self)
    }

    @IBAction func difficulty4(_ sender: UIButton) {
        selectedDifficulty = 4
        performSegue(withIdentifier: "GameSegue", sender: self)
    }

    @IBAction func difficulty5(_ sender: UIButton) {
        selectedDifficulty = 5
        performSegue(withIdentifier: "GameSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! GameViewController).selectedMap = selectedMap
        (segue.destination as! GameViewController).selectedDifficulty = selectedDifficulty
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
