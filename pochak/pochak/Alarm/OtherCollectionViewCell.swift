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
    func setupData(){
        
    }
    func configure(with imageUrl: String) {
        if let url = URL(string: imageUrl) {
            img.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    print("Image successfully loaded: \(value.image)")
                    self.img.contentMode = .scaleAspectFill
                case .failure(let error):
                    print("Image failed to load with error: \(error.localizedDescription)")
                }
            }
        }
    }

}
