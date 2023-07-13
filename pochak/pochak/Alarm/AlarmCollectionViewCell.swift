//
//  AlarmCollectionViewCell.swift
//  pochak
//
//  Created by 장나리 on 2023/07/08.
//

import UIKit

class AlarmCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlarmCollectionViewCell"
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var img: UIImageView!
    

    @IBAction func acceptBtn(_ sender: Any) {
    }
    @IBAction func refuseBtn(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupAttribute()

    }

    private func setupAttribute(){
        img.layer.cornerRadius = 50/2
    }
}
