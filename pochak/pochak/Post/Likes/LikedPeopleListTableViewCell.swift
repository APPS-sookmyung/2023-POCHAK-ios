//
//  LikedPeopleListTableViewCell.swift
//  pochak
//
//  Created by Suyeon Hwang on 2023/07/21.
//

import UIKit

class LikedPeopleListTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 프로필 사진 둥글게
        profileImageView.layer.cornerRadius = 22.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
