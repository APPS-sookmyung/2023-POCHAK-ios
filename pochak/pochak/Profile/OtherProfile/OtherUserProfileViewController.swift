//
//  OtherUseProfileViewController.swift
//  pochak
//
//  Created by Seo Cindy on 1/16/24.
//

import UIKit

class OtherUserProfileViewController: UIViewController {

    @IBOutlet weak var profileBackground: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var followerList: UIStackView!
    @IBOutlet weak var followingList: UIStackView!
    @IBOutlet weak var whiteBackground: UIView!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userMessage: UILabel!
    @IBOutlet weak var postCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followToggleBtn: UIButton!
    
    let socialId = UserDefaultsManager.getData(type: String.self, forKey: .socialId) ?? "socialId not found"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 프로픨 디자인
        profileBackground.layer.cornerRadius = 50
        profileImage.layer.cornerRadius = 46
        
        // 둥근 모서리 적용
        whiteBackground.layer.cornerRadius = 8
        followToggleBtn.layer.cornerRadius = 8
    
        // 팔로워 / 팔로잉 레이블 선택
        viewFollowerList()
        viewFollowingList()
        
        // Back 버튼 커스텀
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        // settingButton
        let settingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        settingButton.setImage(UIImage(named: "settingIcon"), for: .normal)
        settingButton.addTarget(self, action: #selector(clickSettingButton), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: settingButton)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
                
        
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        // API
        loadProfileData()
    }
    
    private func loadProfileData() {
        // LoginUser 정보 가져오기
        let handle = UserDefaultsManager.getData(type: String.self, forKey: .handle) ?? "handle not found"
        let name = UserDefaultsManager.getData(type: String.self, forKey: .name) ?? "name not found"
        let message = UserDefaultsManager.getData(type: String.self, forKey: .message) ?? "message not found"
        
        self.userHandle.text = "@" + handle
        self.userName.text = name
        self.userMessage.text = message
        
        
        guard let keyChainAccessToken = (try? KeychainManager.load(account: socialId)) else {return}
        print(keyChainAccessToken)
        
        MyProfilePostDataManager.shared.myProfilePochakPostDataManager(handle,{resultData in
            print("myProfilePochakPostDataManager")
            print(resultData)
            
            // 프로필 이미지
            let imageURL = resultData.userProfileImg ?? ""
            UserDefaultsManager.setData(value: imageURL, key: .profileImgUrl)
            if let url = URL(string: imageURL) {
                self.profileImage.kf.setImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        print("Image successfully loaded: \(value.image)")
                    case .failure(let error):
                        print("Image failed to load with error: \(error.localizedDescription)")
                    }
                }
            }
            self.postCount.text = String(resultData.totalPostNum ?? 0)
            self.followerCount.text = String(resultData.followerCount ?? 0)
            self.followingCount.text = String(resultData.followingCount ?? 0)
        })
    }
    

    // MARK: - view Follower / Following List
    //  UITapGestureRecognizer 사용
    private func viewFollowerList() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewFollowerTapped))
        followerList.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func viewFollowingList() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewFollowingTapped))
        followingList.addGestureRecognizer(tapGestureRecognizer)
    }
        
    @objc private func viewFollowingTapped(){
        guard let followListVC = self.storyboard?.instantiateViewController(withIdentifier: "FollowListVC") as? FollowListViewController else {return}
        self.navigationController?.pushViewController(followListVC, animated: true)
        
        
    }
    
    @objc private func viewFollowerTapped(){
        guard let followListVC = self.storyboard?.instantiateViewController(withIdentifier: "FollowListVC") as? FollowListViewController else {return}
        self.navigationController?.pushViewController(followListVC, animated: true)
        
        
    }
    
    @objc private func clickSettingButton(_ sender: UIButton) {
        guard let updateProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileVC") as? UpdateProfileViewController else {return}
        self.navigationController?.pushViewController(updateProfileVC, animated: true)
    }
}
