//
//  ServerInfoViewController.swift
//  Quake3-iOS
//
//  Created by Tom Kidd on 8/4/18.
//  Copyright © 2018 Tom Kidd. All rights reserved.
//

import UIKit
import FontAwesome

class ServerInfoViewController: UIViewController {

    var server: Server!
    
    @IBOutlet weak var playersTable: UITableView!
    @IBOutlet weak var rulesTable: UITableView!
    @IBOutlet weak var serverName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        serverName.text = server.name
        
        playersTable.register(UITableViewCell.self, forCellReuseIdentifier: "playersCell")
        playersTable.mask = nil
        rulesTable.register(UITableViewCell.self, forCellReuseIdentifier: "rulesCell")
        rulesTable.mask = nil

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartMultiplayerGameSegue" {
            (segue.destination as! GameViewController).selectedServer = server
        }
    }

}

extension ServerInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return (server.players?.count)!
        } else {
            return server.rules.keys.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = playersTable.dequeueReusableCell(withIdentifier: "playersCell")
            let player = server.players![indexPath.row]
            cell?.textLabel?.text = "\(player.name) ping: \(player.ping) score: \(player.score)"
            cell?.textLabel?.font = UIFont(name: "AvenirNextCondensed-Regular", size: 20)
            return cell!
        } else {
            let cell = rulesTable.dequeueReusableCell(withIdentifier: "rulesCell")
            let ruleKey = Array(server.rules.keys)[indexPath.row]
            let rule = server.rules[ruleKey]!
            cell?.textLabel?.text = "\(ruleKey): \(rule)"
            cell?.textLabel?.font = UIFont(name: "AvenirNextCondensed-Regular", size: 20)
            return cell!
        }
    }
    
    
}

extension ServerInfoViewController: UITableViewDelegate {
    
}
