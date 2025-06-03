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
    func addBot(bot:String, difficulty: Float, icon: String)
}

class BotMatchViewController: UIViewController {
    
    @IBOutlet weak var botList: UITableView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var mapShot: UIImageView!
    
    @IBOutlet weak var skill1Button: UIButton!
    @IBOutlet weak var skill2Button: UIButton!
    @IBOutlet weak var skill3Button: UIButton!
    @IBOutlet weak var skill4Button: UIButton!
    @IBOutlet weak var skill5Button: UIButton!
    
    var fragLimit = 20
    
    @IBOutlet weak var fragLimitLabel: UILabel!
    @IBOutlet weak var incrementFragLimitButton: UIButton!
    @IBOutlet weak var decrementFragLimitButton: UIButton!
    
    var timeLimit = 0

    @IBOutlet weak var timeLimitLabel: UILabel!
    @IBOutlet weak var incrementTimeLimitButton: UIButton!
    @IBOutlet weak var decrementTimeLimitButton: UIButton!

    var botSkill = 3.0
    
    var selectedMap = "Q3DM1"

    let fileManager = FileManager()
    var documentsDir = ""

    var bots = [(name: String, skill: Float, icon: String)]()

    override func viewDidLoad() {
        super.viewDidLoad()

        botList.mask = nil
        botList.backgroundColor = UIColor.black
        botList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        #if os(tvOS)
        documentsDir = try! FileManager().url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
        #else
        documentsDir = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
        #endif
        
        updateMapPreview()
        
        var skill1URL = URL(fileURLWithPath: documentsDir)
        skill1URL.appendPathComponent("graphics/menu/art/skill1.tga")
        skill1Button.setImage(UIImage.image(fromTGAFile: skill1URL.path) as? UIImage, for: .normal)
        skill1Button.layer.borderColor = UIColor.red.cgColor

        var skill2URL = URL(fileURLWithPath: documentsDir)
        skill2URL.appendPathComponent("graphics/menu/art/skill2.tga")
        skill2Button.setImage(UIImage.image(fromTGAFile: skill2URL.path) as? UIImage, for: .normal)
        skill2Button.layer.borderColor = UIColor.red.cgColor

        var skill3URL = URL(fileURLWithPath: documentsDir)
        skill3URL.appendPathComponent("graphics/menu/art/skill3.tga")
        skill3Button.setImage(UIImage.image(fromTGAFile: skill3URL.path) as? UIImage, for: .normal)
        skill3Button.layer.borderColor = UIColor.red.cgColor
        skill3Button.layer.borderWidth = 2

        var skill4URL = URL(fileURLWithPath: documentsDir)
        skill4URL.appendPathComponent("graphics/menu/art/skill4.tga")
        skill4Button.setImage(UIImage.image(fromTGAFile: skill4URL.path) as? UIImage, for: .normal)
        skill4Button.layer.borderColor = UIColor.red.cgColor

        var skill5URL = URL(fileURLWithPath: documentsDir)
        skill5URL.appendPathComponent("graphics/menu/art/skill5.tga")
        skill5Button.setImage(UIImage.image(fromTGAFile: skill5URL.path) as? UIImage, for: .normal)
        skill5Button.layer.borderColor = UIColor.red.cgColor
    }
    
    private func updateMapPreview() {
        var destinationURL = URL(fileURLWithPath: documentsDir)
        destinationURL.appendPathComponent("graphics/\(selectedMap).jpg")
        
        if let image = UIImage(contentsOfFile: destinationURL.path) {
            mapShot.image = image
        } else {
            // Create fallback image with map name
            let fallbackImage = createFallbackMapImage(with: selectedMap)
            mapShot.image = fallbackImage
        }
    }
    
    private func createFallbackMapImage(with mapName: String) -> UIImage {
        let size = CGSize(width: 200, height: 150)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        // Draw background
        UIColor.darkGray.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        // Draw border
        UIColor.orange.setStroke()
        let borderRect = CGRect(origin: .zero, size: size).insetBy(dx: 2, dy: 2)
        let borderPath = UIBezierPath(rect: borderRect)
        borderPath.lineWidth = 2
        borderPath.stroke()
        
        // Draw text
        let font = UIFont.boldSystemFont(ofSize: 16)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.orange
        ]
        
        let textSize = mapName.size(withAttributes: attributes)
        let textRect = CGRect(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        
        mapName.draw(in: textRect, withAttributes: attributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BotMatchSegue" {
            (segue.destination as! GameViewController).selectedMap = selectedMap
            (segue.destination as! GameViewController).botMatch = true
            (segue.destination as! GameViewController).botSkill = botSkill
            (segue.destination as! GameViewController).bots = bots
            (segue.destination as! GameViewController).fragLimit = fragLimit
            (segue.destination as! GameViewController).timeLimit = timeLimit
        } else if segue.identifier == "BotMatchMapSegue" {
            (segue.destination as! BotMatchMapViewController).delegate = self
            (segue.destination as! BotMatchMapViewController).selectedMap = selectedMap
        } else if segue.identifier == "BotMatchBotSegue" {
            (segue.destination as! BotMatchBotViewController).delegate = self
        }
    }
    
    @IBAction func incrementFragLimit(_ sender: UIButton) {
        fragLimit += 1
        fragLimitLabel.text = String(fragLimit)
    }
    
    @IBAction func decrementFragLimit(_ sender: UIButton) {
        if fragLimit > 0 {
            fragLimit -= 1
            fragLimitLabel.text = String(fragLimit)
        }
    }

    @IBAction func incrementTimeLimit(_ sender: UIButton) {
        timeLimit += 1
        timeLimitLabel.text = String(timeLimit)
    }
    
    @IBAction func decrementTimeLimit(_ sender: UIButton) {
        if timeLimit > 0 {
            timeLimit -= 1
            timeLimitLabel.text = String(timeLimit)
        }
    }
    
    func clearSkills(_ sender: UIButton) {
        skill1Button.layer.borderWidth = 0
        skill2Button.layer.borderWidth = 0
        skill3Button.layer.borderWidth = 0
        skill4Button.layer.borderWidth = 0
        skill5Button.layer.borderWidth = 0
        sender.layer.borderWidth = 1
    }

    @IBAction func skill1(_ sender: UIButton) {
        self.botSkill = 1
        clearSkills(sender)
    }
    
    @IBAction func skill2(_ sender: UIButton) {
        self.botSkill = 2
        clearSkills(sender)
    }
    
    @IBAction func skill3(_ sender: UIButton) {
        self.botSkill = 3
        clearSkills(sender)
    }
    
    @IBAction func skill4(_ sender: UIButton) {
        self.botSkill = 4
        clearSkills(sender)
    }
    
    @IBAction func skill5(_ sender: UIButton) {
        self.botSkill = 5
        clearSkills(sender)
    }
}

extension BotMatchViewController: BotMatchProtocol {
    func setMap(map: String, name: String) {
        mapButton.setTitle(map, for: .normal)
        selectedMap = map
        updateMapPreview()
    }
    
    func addBot(bot: String, difficulty: Float, icon:String) {
        bots.append((name: bot, skill: difficulty, icon: icon))
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
        
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .orange
        cell.textLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 17)
        
        var destinationURL = URL(fileURLWithPath: documentsDir)
        destinationURL.appendPathComponent(bots[indexPath.row].icon)
        
        let fileManager = FileManager()
        if fileManager.fileExists(atPath: destinationURL.path) {
        
            let img: UIImage = UIImage.image(fromTGAFile: destinationURL.path) as! UIImage
            cell.imageView?.contentMode = .scaleAspectFit
            cell.imageView?.image = img
        }

        cell.textLabel?.text = bots[indexPath.row].name
        return cell
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

