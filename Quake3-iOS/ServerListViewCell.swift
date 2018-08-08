//
//  ServerListViewCell.swift
//  Quake3-iOS
//
//  Created by Tom Kidd on 8/4/18.
//  Copyright © 2018 Tom Kidd. All rights reserved.
//

import UIKit

class ServerListViewCell: UITableViewCell {
    
    @IBOutlet weak var serverName: UILabel!
    @IBOutlet weak var playerCount: UILabel!
    @IBOutlet weak var mapName: UILabel!
    @IBOutlet weak var modName: UILabel!
    @IBOutlet weak var gameType: UILabel!
    @IBOutlet weak var ping: UILabel!
    @IBOutlet weak var ipAddress: UILabel!    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
