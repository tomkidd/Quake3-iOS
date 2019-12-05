//
//  BotMatchBotViewController.swift
//  Quake3-iOS
//
//  Created by Tom Kidd on 12/4/19.
//  Copyright © 2019 Tom Kidd. All rights reserved.
//

import UIKit

class BotMatchBotViewController: UIViewController {

    @IBOutlet weak var botList: UITableView!
    
    var delegate:BotMatchProtocol?
    
    var difficulty:Float = 3.0
    
    let botNames = ["Crash",
                    "Ranger",
                    "Phobos",
                    "Mynx",
                    "Orbb",
                    "Sarge",
                    "Bitterman",
                    "Grunt",
                    "Hossman",
                    "Daemia",
                    "Hunter",
                    "Gorre",
                    "Wrack",
                    "Angel",
                    "Slash",
                    "Klesk",
                    "Lucy",
                    "TankJr",
                    "Biker",
                    "Patriot",
                    "Anarki",
                    "Razor",
                    "Visor",
                    "Stripe",
                    "Keel",
                    "Uriel",
                    "Bones",
                    "Cadaver",
                    "Doom",
                    "Sorlag",
                    "Major",
                    "Xaero"]
    
    var skills:[String: Float] = ["0.0": 0.0,
                                  "0.5": 0.5,
                                  "1.0": 1.0,
                                  "1.5": 1.5,
                                  "2.0": 2.0,
                                  "2.5": 2.5,
                                  "3.0": 3.0,
                                  "3.5": 3.5,
                                  "4.0": 4.0,
                                  "4.5": 4.5,
                                  "5.0": 5.0]

    override func viewDidLoad() {
        super.viewDidLoad()

        botList.mask = nil
        botList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func skill(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let skillKeys = Array(skills.keys).sorted()
        for skill in skillKeys {
            alert.addAction(UIAlertAction(title: skill, style: .default, handler: { (action) in
                sender.setTitle(action.title, for: .normal)
                self.difficulty = self.skills[action.title!]!
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BotMatchBotViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.addBot(bot: botNames[indexPath.row], difficulty: difficulty)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension BotMatchBotViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return botNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = botNames[indexPath.row]
        return cell
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
