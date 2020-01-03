//
//  BotMatchViewController.swift
//  Quake3-iOS
//
//  Created by Tom Kidd on 12/4/19.
//  Copyright © 2019 Tom Kidd. All rights reserved.
//

import UIKit

protocol BotMatchProtocol {
    func setMap(map:String, name: String)
    func addBot(bot:String, difficulty: Float)
}

class BotMatchViewController: UIViewController {
    
    @IBOutlet weak var botList: UITableView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var mapShot: UIImageView!

    var selectedMap = "Q3DM1"

    let fileManager = FileManager()
    var currentWorkingPath = ""

    var bots = [(name: String, skill: Float)]()

    override func viewDidLoad() {
        super.viewDidLoad()

        botList.mask = nil
        botList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        currentWorkingPath = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
        var destinationURL = URL(fileURLWithPath: currentWorkingPath)
        destinationURL.appendPathComponent("graphics/\(selectedMap).jpg")
        mapShot.image = UIImage(contentsOfFile: destinationURL.path)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BotMatchSegue" {
            (segue.destination as! GameViewController).selectedMap = selectedMap
            (segue.destination as! GameViewController).botMatch = true
            
            (segue.destination as! GameViewController).bots = bots
        } else if segue.identifier == "BotMatchMapSegue" {
            (segue.destination as! BotMatchMapViewController).delegate = self
            (segue.destination as! BotMatchMapViewController).selectedMap = selectedMap
        } else if segue.identifier == "BotMatchBotSegue" {
            (segue.destination as! BotMatchBotViewController).delegate = self
        }
    }

}

extension BotMatchViewController: BotMatchProtocol {
    func setMap(map: String, name: String) {
        mapButton.setTitle(map, for: .normal)
        selectedMap = map
        var destinationURL = URL(fileURLWithPath: currentWorkingPath)
        destinationURL.appendPathComponent("graphics/\(selectedMap).jpg")
        mapShot.image = UIImage(contentsOfFile: destinationURL.path)
    }
    
    func addBot(bot: String, difficulty: Float) {
        bots.append((name: bot, skill: difficulty))
        botList.reloadData()
    }
}

extension BotMatchViewController : UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.delegate?.setMap(map: bots[indexPath.row].map, name: maps[indexPath.row].name)
//        self.dismiss(animated: true, completion: nil)
//    }
    
}

extension BotMatchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(bots[indexPath.row].name) (skill: \(bots[indexPath.row].skill))"
        return cell
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

