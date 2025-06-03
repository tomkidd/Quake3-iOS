//
//  BotMatchBotViewController.swift
//  Quake3-iOS
//
//  Created by Tom Kidd on 12/4/19.
//  Copyright © 2019 Tom Kidd. All rights reserved.
//

import UIKit

class BotMatchBotViewController: UIViewController {

    @IBOutlet weak var botGrid: UICollectionView!
    @IBOutlet weak var okButton: UIButton!
        
    @IBOutlet weak var skill1Button: UIButton!
    @IBOutlet weak var skill2Button: UIButton!
    @IBOutlet weak var skill3Button: UIButton!
    @IBOutlet weak var skill4Button: UIButton!
    @IBOutlet weak var skill5Button: UIButton!
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var subtractButton: UIButton!

    var delegate:BotMatchProtocol?
    
    var difficulty:Float = 3.0
    var selectedBot = ""
    var selectedIcon = ""
    var botQuantity = 1
    
    let bots:[(name: String, icon: String)] = [(name: "Anarki", icon:"graphics/anarki/icon_default.tga"),
                                            (name: "Angel", icon:"graphics/lucy/icon_angel.tga"),
                                            (name: "Biker", icon:"graphics/biker/icon_default.tga"),
                                            (name: "Bitterman", icon:"graphics/bitterman/icon_default.tga"),
                                            (name: "Bones", icon:"graphics/bones/icon_default.tga"),
                                            (name: "Cadavre", icon:"graphics/biker/icon_cadavre.tga"),
                                            (name: "Crash", icon:"graphics/crash/icon_default.tga"),
                                            (name: "Daemia", icon:"graphics/major/icon_daemia.tga"),
                                            (name: "Doom", icon:"graphics/doom/icon_default.tga"),
                                            (name: "Gorre", icon:"graphics/visor/icon_gorre.tga"),
                                            (name: "Grunt", icon:"graphics/grunt/icon_default.tga"),
                                            (name: "Hossman", icon:"graphics/biker/icon_hossman.tga"),
                                            (name: "Hunter", icon:"graphics/hunter/icon_default.tga"),
                                            (name: "Keel", icon:"graphics/keel/icon_default.tga"),
                                            (name: "Klesk", icon:"graphics/klesk/icon_default.tga"),
                                            (name: "Lucy", icon:"graphics/lucy/icon_default.tga"),
                                            (name: "Major", icon:"graphics/major/icon_default.tga"),
                                            (name: "Mynx", icon:"graphics/mynx/icon_default.tga"),
                                            (name: "Orbb", icon:"graphics/orbb/icon_default.tga"),
                                            (name: "Patriot", icon:"graphics/razor/icon_patriot.tga"),
                                            (name: "Phobos", icon:"graphics/doom/icon_phobos.tga"),
                                            (name: "Ranger", icon:"graphics/ranger/icon_default.tga"),
                                            (name: "Razor", icon:"graphics/razor/icon_default.tga"),
                                            (name: "Sarge", icon:"graphics/sarge/icon_default.tga"),
                                            (name: "Slash", icon:"graphics/slash/icon_default.tga"),
                                            (name: "Sorlag", icon:"graphics/sorlag/icon_default.tga"),
                                            (name: "Stripe", icon:"graphics/grunt/icon_stripe.tga"),
                                            (name: "TankJr", icon:"graphics/tankjr/icon_default.tga"),
                                            (name: "Uriel", icon:"graphics/uriel/icon_default.tga"),
                                            (name: "Visor", icon:"graphics/visor/icon_default.tga"),
                                            (name: "Wrack", icon:"graphics/ranger/icon_wrack.tga"),
                                            (name: "Xaero", icon:"graphics/xaero/icon_default.tga")]
    
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
        
        #if os(tvOS)
        let documentsDir = try! FileManager().url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
        #else
        let documentsDir = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
        #endif

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
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ok(_ sender: UIButton) {
        
        for _ in 0..<botQuantity {
            self.delegate?.addBot(bot: selectedBot, difficulty: difficulty, icon: selectedIcon)
        }
        
        self.dismiss(animated: true, completion: nil)
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
        self.difficulty = 1
        clearSkills(sender)
    }
    
    @IBAction func skill2(_ sender: UIButton) {
        self.difficulty = 2
        clearSkills(sender)
    }
    
    @IBAction func skill3(_ sender: UIButton) {
        self.difficulty = 3
        clearSkills(sender)
    }
    
    @IBAction func skill4(_ sender: UIButton) {
        self.difficulty = 4
        clearSkills(sender)
    }
    
    @IBAction func skill5(_ sender: UIButton) {
        self.difficulty = 5
        clearSkills(sender)
    }
    
    @IBAction func incrementBotQuantity(_ sender: UIButton) {
        botQuantity += 1
        quantityLabel.text = String(botQuantity)
    }
    
    @IBAction func decrementBotQuantity(_ sender: UIButton) {
        if botQuantity > 1 {
            botQuantity -= 1
            quantityLabel.text = String(botQuantity)
        }
    }
    

    
}

extension BotMatchBotViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bots.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BotCollectionViewCell

        #if os(tvOS)
        let documentsDir = try! FileManager().url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
        #else
        let documentsDir = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
        #endif

        var destinationURL = URL(fileURLWithPath: documentsDir)
        destinationURL.appendPathComponent(bots[indexPath.row].icon)
        
        let fileManager = FileManager()
        if fileManager.fileExists(atPath: destinationURL.path) {
            let img: UIImage = UIImage.image(fromTGAFile: destinationURL.path) as! UIImage
            cell.botAvatar.contentMode = .scaleAspectFit
            cell.botAvatar.image = img
        } else {
            // Create a fallback image with bot name initials
            let botName = bots[indexPath.row].name
            let initials = String(botName.prefix(2)).uppercased()
            let fallbackImage = createFallbackImage(with: initials)
            cell.botAvatar.contentMode = .scaleAspectFit
            cell.botAvatar.image = fallbackImage
        }
        
        cell.botName.text = bots[indexPath.row].name

        if bots[indexPath.row].name == selectedBot {
            cell.botAvatar.layer.borderColor = UIColor.red.cgColor
            cell.botAvatar.layer.borderWidth = 1
        } else {
            cell.botAvatar.layer.borderColor = UIColor.black.cgColor
            cell.botAvatar.layer.borderWidth = 0
        }

        return cell
    }
    
    private func createFallbackImage(with text: String) -> UIImage {
        let size = CGSize(width: 64, height: 64)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        // Draw background
        UIColor.darkGray.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        // Draw text
        let font = UIFont.boldSystemFont(ofSize: 20)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.orange
        ]
        
        let textSize = text.size(withAttributes: attributes)
        let textRect = CGRect(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        
        text.draw(in: textRect, withAttributes: attributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BotCollectionViewCell
        self.selectedBot = bots[indexPath.row].name
        self.selectedIcon = bots[indexPath.row].icon
        okButton.isEnabled = true
        cell.botAvatar.layer.borderColor = UIColor.red.cgColor
        cell.botAvatar.layer.borderWidth = 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            (cell as! BotCollectionViewCell).botAvatar.layer.borderColor = UIColor.black.cgColor
            (cell as! BotCollectionViewCell).botAvatar.layer.borderWidth = 0
        }
    }
}

extension BotMatchBotViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 64, height: 100)
    }
}

extension BotMatchBotViewController : UICollectionViewDataSource {
}
