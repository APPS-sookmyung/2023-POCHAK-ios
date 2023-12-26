//
//  PostCollectionViewCell.swift
//  pochak
//
//  Created by 장나리 on 2023/07/12.
//

import UIKit
import Kingfisher

class PostCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier = "PostCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    // 이미지 설정 함수
    func configure(with imageUrl: PostTabDataModel) {
        if let url = URL(string: imageUrl.imgUrl) {
            imageView.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    print("Image successfully loaded: \(value.image)")
                case .failure(let error):
                    print("Image failed to load with error: \(error.localizedDescription)")
                }
            }
        }
    }
}
