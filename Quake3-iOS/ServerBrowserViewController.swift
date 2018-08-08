//
//  ServerBrowserViewController.swift
//  Quake3-iOS
//
//  Created by Tom Kidd on 8/4/18.
//  Copyright © 2018 Tom Kidd. All rights reserved.
//

import UIKit

protocol ServerFilterProtocol {
    func setGameTypeFilter(gameTypeFilter:String, gameTypeFilterTitle: String)
    func setModFilter(modFilter:String, modFilterTitle: String)
    func setSortOption(sortOption: String, sortOptionTitle: String)
    func setShowFull(showFull: Bool)
    func setShowEmpty(showEmpty: Bool)
}

class ServerBrowserViewController: UIViewController {
    
    private var currentGame: Game?
    private var coordinator: Coordinator?
    private var servers = [Server]()
    private var filteredServers = [Server]()
    private var selectedServer: Server?
    var gameTypeFilter = ""
    var gameTypeFilterTitle = "Any"
    var modFilter = ""
    var modFilterTitle = "Any"
    var sortOption = "ping"
    var sortOptionTitle = "Ping"
    var showEmpty = true
    var showFull = true
    var busy = false

    @IBOutlet weak var serversList: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityInfo: UILabel!
    @IBOutlet weak var fightButton: UIButton!
    @IBOutlet weak var serverInfoButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let game = Game(type: .quake3, launchArguments: "+connect")
        currentGame = game
        coordinator = game.type.coordinator
        coordinator?.delegate = self
        let masterServer = SupportedGames.quake3.masterServersList.first
        let masterServerComponents = masterServer!.components(separatedBy: ":")
        let host = masterServerComponents.first!
        let port = masterServerComponents.last!
        
        serversList.register(UINib(nibName: "ServerListViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        serversList.mask = nil

        activityIndicator.startAnimating()
        coordinator?.getServersList(host: host, port: port)

        #if os(iOS)
        filterButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 18, style: .solid)
        #endif
        #if os(tvOS)
        filterButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 36, style: .solid)
        #endif
        filterButton.setTitle(String.fontAwesomeIcon(name: .filter), for: .normal)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartMultiplayerGameSegue" {
            (segue.destination as! GameViewController).selectedServer = selectedServer
        } else if segue.identifier == "ServerInfoSegue" {
            (segue.destination as! ServerInfoViewController).server = selectedServer
        } else if segue.identifier == "ServerFilterSegue" {
            (segue.destination as! ServerFilterViewController).delegate = self
            (segue.destination as! ServerFilterViewController).sortOptionTitle = self.sortOptionTitle
            (segue.destination as! ServerFilterViewController).modFilterTitle = self.modFilterTitle
            (segue.destination as! ServerFilterViewController).gameTypeFilterTitle = self.gameTypeFilterTitle
            (segue.destination as! ServerFilterViewController).showEmpty = self.showEmpty
            (segue.destination as! ServerFilterViewController).showFull = self.showFull
        }
    }
    
    @IBAction func exitToServerBrowser(segue: UIStoryboardSegue) {
    }
    
    @IBAction func getServerInfo(_ sender: UIButton) {
        coordinator?.status(forServer: selectedServer!)
    }
    

}

extension ServerBrowserViewController: CoordinatorDelegate {
    func didStartFetchingServersList(for coordinator: Coordinator) {
        print("didStartFetchingServersList")
        DispatchQueue.main.async {
            self.busy = true
        }
    }
    
    func didFinishFetchingServersList(for coordinator: Coordinator) {
        print("didFinishFetchingServersList")        
        coordinator.fetchServersInfo()
    }
    
    func didFinishFetchingServersInfo(for coordinator: Coordinator) {
        print("didFinishFetchingServersInfo")
        DispatchQueue.main.async {
            self.busy = false
            self.activityIndicator.stopAnimating()
            var filterString = ""
            if self.servers.count != self.filteredServers.count {
                filterString = " (\(self.filteredServers.count) shown)"
            }
            self.activityInfo.text = "\(self.servers.count) servers found\(filterString)"
        }
    }
    
    private func filterServers() {
        
        self.filteredServers = []
        
        for server in self.servers {
            
            var gameTypeMatch = true
            var modMatch = true
            var sizeMatch = true
            
            if !self.gameTypeFilter.isEmpty {
                if server.gametype != self.gameTypeFilter {
                    gameTypeMatch = false
                }
            }
            
            if !self.modFilter.isEmpty {
                if server.mod != self.modFilter {
                    modMatch = false
                }
            }
            
            if let currentPlayers = Int(server.currentPlayers), let maxPlayers = Int(server.maxPlayers) {
                if !showFull {
                    if currentPlayers == maxPlayers {
                        sizeMatch = false
                    }
                }
                
                if !showEmpty {
                    if currentPlayers == 0 {
                        sizeMatch = false
                    }
                }
            }

            if gameTypeMatch && modMatch && sizeMatch {
                self.filteredServers.append(server)
            }
            
        }
        
        self.filteredServers = self.filteredServers.sorted(by: { (s1, s2) -> Bool in
            
            if self.sortOption == "ping" {
                
                let s1ping = Int(s1.ping)!
                let s2ping = Int(s2.ping)!
                
                return s2ping > s1ping
            } else if self.sortOption == "servername" {
                return s2.name > s1.name
            } else if self.sortOption == "gametype" {
                return s2.gametype > s1.gametype
            }
            
            return true
        })
        
        self.serversList.reloadData()
        
        if !busy {
            var filterString = ""
            if self.servers.count != self.filteredServers.count {
                filterString = " (\(self.filteredServers.count) shown)"
            }
            self.activityInfo.text = "\(self.servers.count) servers found\(filterString)"
        }        

    }
    
    func coordinator(_ coordinator: Coordinator, didFinishFetchingInfoFor server: Server) {
        DispatchQueue.main.async {
            self.servers.append(server)
            
            print("gametype: \(server.gametype) map: \(server.map) mod: \(server.mod)")
            
            self.filterServers()
        }
        print("didFinishFetchingInfoFor \(server.name)")
    }
    
    func coordinator(_ coordinator: Coordinator, didFinishFetchingStatusFor server: Server) {
        DispatchQueue.main.async {
            self.selectedServer = server
            self.performSegue(withIdentifier: "ServerInfoSegue", sender: self)
        }
        print("didFinishFetchingStatusFor")
    }
    
    func coordinator(_ coordinator: Coordinator, didFailWith error: SQLError) {
        print("didFailWith \(error.localizedDescription)")
    }
    
    
}

extension ServerBrowserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedServer = filteredServers[indexPath.row]
        fightButton.isHidden = false
        serverInfoButton.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        #if os(iOS)
        return 100
        #endif
        #if os(tvOS)
        return 200
        #endif
    }
}

extension ServerBrowserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredServers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServerListViewCell
        let server = filteredServers[indexPath.row]
        
        cell.serverName.text = server.name
        cell.ping.text = server.ping
        if let ping = Int(server.ping) {
            if ping <= 60 {
                cell.ping.textColor = UIColor.green
            } else if ping <= 100 {
                cell.ping.textColor = UIColor.orange
            } else {
                cell.ping.textColor = UIColor.red
            }
        }
        cell.gameType.text = server.gametype
        cell.ipAddress.text = "\(server.ip):\(server.port)"
        cell.mapName.text = server.map
        cell.modName.text = server.mod
        cell.playerCount.text = "(\(server.currentPlayers)/\(server.maxPlayers))"

        return cell
    }
    
    
}

extension ServerBrowserViewController: ServerFilterProtocol {
    func setShowFull(showFull: Bool) {
        self.showFull = showFull
        self.filterServers()
    }
    
    func setShowEmpty(showEmpty: Bool) {
        self.showEmpty = showEmpty
        self.filterServers()
    }
    
    func setGameTypeFilter(gameTypeFilter: String, gameTypeFilterTitle: String) {
        self.gameTypeFilter = gameTypeFilter
        self.gameTypeFilterTitle = gameTypeFilterTitle
        self.filterServers()
    }
    
    func setModFilter(modFilter: String, modFilterTitle: String) {
        self.modFilter = modFilter
        self.modFilterTitle = modFilterTitle
        self.filterServers()
    }
    
    func setSortOption(sortOption: String, sortOptionTitle: String) {
        self.sortOption = sortOption
        self.sortOptionTitle = sortOptionTitle
        self.filterServers()
    }
}
