//
//  SearchResultTableViewCell.swift
//  pochak
//
//  Created by 장나리 on 2023/09/03.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    static let identifier = "SearchResultTableViewCell"
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAttribute()
        // Initialization code
    }

    private func setupAttribute(){
        profileImg.layer.cornerRadius = 50/2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
