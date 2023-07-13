//
//  OtherCollectionViewCell.swift
//  pochak
//
//  Created by 장나리 on 2023/07/12.
//

import UIKit

class OtherCollectionViewCell: UICollectionViewCell {
    static let identifier = "OtherCollectionViewCell"

    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupAttribute()

    }

    private func setupAttribute(){
        img.layer.cornerRadius = 50/2
    }

}
