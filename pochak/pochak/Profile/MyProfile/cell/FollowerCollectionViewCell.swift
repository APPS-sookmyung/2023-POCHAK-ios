//
//  TabbarHeadingCollectionViewCell.swift
//  pochak
//
//  Created by Seo Cindy on 12/27/23.
//

import UIKit

class FollowerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    
    // Collection View가 생성할 cell임을 명시
    static let identifier = "FollowerCollectionViewCell"
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
