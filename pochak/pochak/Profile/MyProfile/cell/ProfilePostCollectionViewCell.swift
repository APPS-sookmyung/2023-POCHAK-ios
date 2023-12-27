//
//  PostCollectionViewCell.swift
//  pochak
//
//  Created by Seo Cindy on 12/27/23.
//

import UIKit

class ProfilePostCollectionViewCell: UICollectionViewCell {
    
    // Collection View가 생성할 cell임을 명시
    static let identifier = "ProfilePostCollectionViewCell"
    
    
    @IBOutlet weak var profilePostImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
