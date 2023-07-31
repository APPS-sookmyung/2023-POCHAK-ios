//
//  TagCollectionViewCell.swift
//  pochak
//
//  Created by 장나리 on 2023/07/23.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagIdLabel: UILabel!
    @IBOutlet weak var labelBg: UIView!
    static let identifier = "TagCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        labelBg.layer.cornerRadius = 8
        labelBg.layer.borderWidth = 1
        labelBg.layer.borderColor = UIColor(hexCode: "79747E").cgColor
    }

}

extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
