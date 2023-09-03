//
//  LikedPeopleListTableViewCell.swift
//  pochak
//
//  Created by Suyeon Hwang on 2023/07/21.
//

import UIKit

class LikedPeopleListTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var followingBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    private var isFollowing: Bool = false  // 임시로 초깃값은 false -> 나중에 변경
    private var isFollowingColor: UIColor = UIColor(named: "gray03") ?? UIColor(hexCode: "FFB83A")
    private var isNotFollowingColor: UIColor = UIColor(named: "yellow00") ?? UIColor(hexCode: "C6CDD2")

    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 프로필 사진 둥글게
        profileImageView.layer.cornerRadius = 22.5
        
        // 팔로잉 상태 서버에서 확인 후 값 세팅
        followingBtn.isSelected = isFollowing  // 팔로우 안된 상태
        
        followingBtn.setTitle("팔로우", for: .normal)
        followingBtn.setTitle("팔로잉", for: .selected)
        
        followingBtn.setTitleColor(UIColor.white, for: [.normal, .selected])
        
        followingBtn.backgroundColor = isNotFollowingColor
        
        followingBtn.layer.cornerRadius = 4.97
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Actions
    @IBAction func followBtnDidTap(_ sender: Any) {
        // 언팔로우하기
        if followingBtn.isSelected {
            followingBtn.isSelected = false
            followingBtn.backgroundColor = isNotFollowingColor
        }
        // 팔로우하기
        else{
            followingBtn.isSelected = true
            followingBtn.backgroundColor = isFollowingColor
        }
    }
    
}
