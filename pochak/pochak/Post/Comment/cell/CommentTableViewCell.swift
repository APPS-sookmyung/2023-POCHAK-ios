//
//  CommentTableViewCell.swift
//  pochak
//
//  Created by Suyeon Hwang on 2023/07/10.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // 크기 반만큼 radius
        profileImageView.layer.cornerRadius = 17.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
