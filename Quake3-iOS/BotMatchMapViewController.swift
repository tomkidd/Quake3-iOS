//
//  BotMatchMapViewController.swift
//  Quake3-iOS
//
//  Created by Tom Kidd on 12/4/19.
//  Copyright © 2019 Tom Kidd. All rights reserved.
//

import UIKit

class BotMatchMapViewController: UIViewController {

    @IBOutlet weak var mapList: UITableView!
    @IBOutlet weak var mapShot: UIImageView!

    let fileManager = FileManager()
    var currentWorkingPath = ""
    
    var selectedMap = "Q3DM1"

    var delegate:BotMatchProtocol?
    
    let maps:[(map: String, name: String)] =
        [(map: "Q3DM0", name: "Q3DM0: Introduction"),
         (map: "Q3DM1", name: "Q3DM1: Arena Gate"),
         (map: "Q3DM2", name: "Q3DM2: House of Pain"),
         (map: "Q3DM3", name: "Q3DM3: Arena of Death"),
         (map: "Q3DM4", name: "Q3DM4: The Place of Many Deaths"),
         (map: "Q3DM5", name: "Q3DM5: The Forgotten Place"),
         (map: "Q3DM6", name: "Q3DM6: The Camping Grounds"),
         (map: "Q3DM7", name: "Q3DM7: Temple of Retribution"),
         (map: "Q3DM8", name: "Q3DM8: Brimstone Abbey"),
         (map: "Q3DM9", name: "Q3DM9: Hero's Keep"),
         (map: "Q3DM10", name: "Q3DM10: The Nameless Place"),
         (map: "Q3DM11", name: "Q3DM11: Deva Station"),
         (map: "Q3DM12", name: "Q3DM12: The Dredwerkz"),
         (map: "Q3DM13", name: "Q3DM13: Lost World"),
         (map: "Q3DM14", name: "Q3DM14: Grim Dungeons"),
         (map: "Q3DM15", name: "Q3DM15: Demon Keep"),
         (map: "Q3DM16", name: "Q3DM16: Bouncy Map"),
         (map: "Q3DM17", name: "Q3DM17: The Longest Yard"),
         (map: "Q3DM18", name: "Q3DM18: Space Chamber"),
         (map: "Q3DM19", name: "Q3DM19: Apocalypse Void"),
         (map: "Q3TOURNEY1", name: "Q3TOURNEY1: Power Station 0218"),
         (map: "Q3TOURNEY2", name: "Q3TOURNEY2: The Proving Grounds"),
         (map: "Q3TOURNEY3", name: "Q3TOURNEY3: Hell's Gate"),
         (map: "Q3TOURNEY4", name: "Q3TOURNEY4: Vertical Vengeance"),
         (map: "Q3TOURNEY5", name: "Q3TOURNEY5: Fatal Instinct"),
         (map: "Q3TOURNEY6", name: "Q3TOURNEY6: The Very End of You")]

    override func viewDidLoad() {
        super.viewDidLoad()

        mapList.mask = nil
        mapList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        #if os(tvOS)
        currentWorkingPath = try! FileManager().url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
        #else
        currentWorkingPath = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
        #endif
    }
    
    @IBAction func ok(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

extension BotMatchMapViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.setMap(map: maps[indexPath.row].map, name: maps[indexPath.row].name)
        var destinationURL = URL(fileURLWithPath: currentWorkingPath)
        destinationURL.appendPathComponent("graphics/\(maps[indexPath.row].map).jpg")
        
        if let image = UIImage(contentsOfFile: destinationURL.path) {
            mapShot.image = image
        } else {
            // Create fallback image with map name
            let fallbackImage = createFallbackMapImage(with: maps[indexPath.row].map)
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
    
}

extension BotMatchMapViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = maps[indexPath.row].name
        
        if selectedMap == maps[indexPath.row].map {
            cell.setSelected(true, animated: false)
            var destinationURL = URL(fileURLWithPath: currentWorkingPath)
            destinationURL.appendPathComponent("graphics/\(maps[indexPath.row].map).jpg")
            
            if let image = UIImage(contentsOfFile: destinationURL.path) {
                mapShot.image = image
            } else {
                // Create fallback image with map name
                let fallbackImage = createFallbackMapImage(with: maps[indexPath.row].map)
                mapShot.image = fallbackImage
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if selectedMap == maps[indexPath.row].map {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
