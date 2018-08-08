//
//  ServerFilterViewController.swift
//  Quake3-iOS
//
//  Created by Tom Kidd on 8/5/18.
//  Copyright © 2018 Tom Kidd. All rights reserved.
//

import UIKit

class ServerFilterViewController: UIViewController {
    
    var delegate:ServerFilterProtocol?
    
    var gameTypeFilterTitle = "Any"
    var modFilterTitle = "Any"
    var sortOptionTitle = "Ping"
    var showEmpty = true
    var showFull = true
    
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var modButton: UIButton!
    @IBOutlet weak var gameTypeButton: UIButton!
#if os(iOS)
    @IBOutlet weak var showEmptySwitch: UISwitch!
    @IBOutlet weak var showFullSwitch: UISwitch!
#endif
#if os(tvOS)
    @IBOutlet weak var showEmptyButton: UIButton!
    @IBOutlet weak var showFullButton: UIButton!
#endif
    let gameTypes = ["Any": "", "Deathmatch": "ffa", "Team Deathmatch": "tdm", "Tournament": "tourney", "Capture the Flag": "ctf"]
    let modTypes = ["Any",
                    "baseq3",
                    "arena",
                    "cpma",
                    "defrag",
                    "excessiveplus",
                    "osp"]
    let sortOptions = ["Ping": "ping", "Server Name": "servername", "Game Type": "gametype"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortByButton.setTitle(sortOptionTitle, for: .normal)
        modButton.setTitle(modFilterTitle, for: .normal)
        gameTypeButton.setTitle(gameTypeFilterTitle, for: .normal)
        #if os(iOS)
        showFullSwitch.setOn(showFull, animated: false)
        showEmptySwitch.setOn(showEmpty, animated: false)
        #endif
        #if os(tvOS)
        showFullButton.setTitle(showFull ? "Yes" : "No", for: .normal)
        showEmptyButton.setTitle(showEmpty ? "Yes" : "No", for: .normal)
        #endif
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
    
    @IBAction func sortBy(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let sortOptionKeys = Array(sortOptions.keys)
        for sortOption in sortOptionKeys {
            alert.addAction(UIAlertAction(title: sortOption, style: .default, handler: { (action) in
                sender.setTitle(action.title, for: .normal)
                self.delegate?.setSortOption(sortOption: self.sortOptions[action.title!]!, sortOptionTitle: action.title!)
            }))
        }
        
        self.present(alert, animated: true, completion: nil)

    }
    
    
    @IBAction func gameType(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let gameTypeKeys = Array(gameTypes.keys)
        for gameType in gameTypeKeys {
            alert.addAction(UIAlertAction(title: gameType, style: .default, handler: { (action) in
                sender.setTitle(action.title, for: .normal)
                self.delegate?.setGameTypeFilter(gameTypeFilter: self.gameTypes[action.title!]!, gameTypeFilterTitle: action.title!)
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func modType(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        for modType in modTypes {
            alert.addAction(UIAlertAction(title: modType, style: .default, handler: { (action) in
                sender.setTitle(action.title, for: .normal)
                self.delegate?.setModFilter(modFilter: action.title! == "Any" ? "" : action.title!, modFilterTitle: action.title!)
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    #if os(iOS)
    @IBAction func showEmpty(_ sender: UISwitch) {
        delegate?.setShowEmpty(showEmpty: sender.isOn)
    }
    
    @IBAction func showFull(_ sender: UISwitch) {
        delegate?.setShowFull(showFull: sender.isOn)
    }
    #endif
    
    #if os(tvOS)
    @IBAction func showEmpty(_ sender: Any) {
        showEmpty = !showEmpty
        delegate?.setShowEmpty(showEmpty: showEmpty)
        showEmptyButton.setTitle(showEmpty ? "Yes" : "No", for: .normal)
    }
    
    @IBAction func showFull(_ sender: Any) {
        showFull = !showFull
        delegate?.setShowFull(showFull: showFull)
        showFullButton.setTitle(showFull ? "Yes" : "No", for: .normal)
    }
    #endif

}
