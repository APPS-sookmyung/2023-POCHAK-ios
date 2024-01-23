//
//  SearchResultTableViewCell.swift
//  pochak
//
//  Created by 장나리 on 2023/09/03.
//

import UIKit
import Kingfisher

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var deleteBtn: UIImageView!
    static let identifier = "SearchResultTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAttribute()
        // Initialization code
//         imageViewClickGesture()

    }

    private func setupAttribute(){
        profileImg.layer.cornerRadius = 50/2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // 이미지 설정 함수
    func configure(with imageUrl: String) {
        if let url = URL(string: imageUrl) {
            profileImg.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    print("Image successfully loaded: \(value.image)")
                    self.profileImg.contentMode = .scaleAspectFill
                case .failure(let error):
                    print("Image failed to load with error: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
