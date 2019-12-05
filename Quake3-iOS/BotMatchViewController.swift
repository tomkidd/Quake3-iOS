//
//  BotMatchViewController.swift
//  Quake3-iOS
//
//  Created by Tom Kidd on 12/4/19.
//  Copyright © 2019 Tom Kidd. All rights reserved.
//

import UIKit

class BotMatchViewController: UIViewController {
    
    @IBOutlet weak var mapList: UITableView!
    
    var selectedMap = ""
    
    let maps:[(map: String, name: String)] =   [(map: "q3dm0", name: "Q3DM0: Introduction"),
                                                (map: "q3dm1", name: "Q3DM1: Arena Gate"),
                                                (map: "q3dm2", name: "Q3DM2: House of Pain"),
                                                (map: "q3dm3", name: "Q3DM3: Arena of Death"),
                                                (map: "q3dm4", name: "Q3DM4: The Place of Many Deaths"),
                                                (map: "q3dm5", name: "Q3DM5: The Forgotten Place"),
                                                (map: "q3dm6", name: "Q3DM6: The Camping Grounds"),
                                                (map: "q3dm7", name: "Q3DM7: Temple of Retribution"),
                                                (map: "q3dm8", name: "Q3DM8: Brimstone Abbey"),
                                                (map: "q3dm9", name: "Q3DM9: Hero's Keep"),
                                                (map: "q3dm10", name: "Q3DM10: The Nameless Place"),
                                                (map: "q3dm11", name: "Q3DM11: Deva Station"),
                                                (map: "q3dm12", name: "Q3DM12: The Dredwerkz"),
                                                (map: "q3dm13", name: "Q3DM13: Lost World"),
                                                (map: "q3dm14", name: "Q3DM14: Grim Dungeons"),
                                                (map: "q3dm15", name: "Q3DM15: Demon Keep"),
                                                (map: "q3dm16", name: "Q3DM16: Bouncy Map"),
                                                (map: "q3dm17", name: "Q3DM17: The Longest Yard"),
                                                (map: "q3dm18", name: "Q3DM18: Space Chamber"),
                                                (map: "q3dm19", name: "Q3DM19: Apocalypse Void"),
                                                (map: "q3tourney1", name: "Q3TOURNEY1: Power Station 0218"),
                                                (map: "q3tourney2", name: "Q3TOURNEY2: The Proving Grounds"),
                                                (map: "q3tourney3", name: "Q3TOURNEY3: Hell's Gate"),
                                                (map: "q3tourney4", name: "Q3TOURNEY4: Vertical Vengeance"),
                                                (map: "q3tourney5", name: "Q3TOURNEY5: Fatal Instinct"),
                                                (map: "q3tourney6", name: "Q3TOURNEY6: The Very End of You")]

    override func viewDidLoad() {
        super.viewDidLoad()

        mapList.mask = nil
        mapList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! GameViewController).selectedMap = selectedMap
        (segue.destination as! GameViewController).botMatch = true
        
        (segue.destination as! GameViewController).bots = []
        
//        (segue.destination as! GameViewController).bots.append((name: "ranger", skill: 1.0))
//        (segue.destination as! GameViewController).bots.append((name: "phobos", skill: 3.0))
        (segue.destination as! GameViewController).bots.append((name: "ranger", skill: 3.0))
        (segue.destination as! GameViewController).bots.append((name: "ranger", skill: 3.0))
        (segue.destination as! GameViewController).bots.append((name: "ranger", skill: 3.0))
        (segue.destination as! GameViewController).bots.append((name: "ranger", skill: 3.0))
        (segue.destination as! GameViewController).bots.append((name: "ranger", skill: 3.0))
        (segue.destination as! GameViewController).bots.append((name: "ranger", skill: 3.0))
        (segue.destination as! GameViewController).bots.append((name: "ranger", skill: 3.0))
        (segue.destination as! GameViewController).bots.append((name: "ranger", skill: 3.0))
        (segue.destination as! GameViewController).bots.append((name: "ranger", skill: 3.0))
        (segue.destination as! GameViewController).bots.append((name: "ranger", skill: 3.0))

    }

}

extension BotMatchViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMap = maps[indexPath.row].map
    }
    
}

extension BotMatchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = maps[indexPath.row].name
        return cell
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
