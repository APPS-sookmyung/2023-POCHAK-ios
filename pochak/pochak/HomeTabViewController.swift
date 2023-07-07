//
//  HomeTabViewController.swift
//  pochak
//
//  Created by Suyeon Hwang on 2023/07/05.
//

import UIKit

class HomeTabViewController: UIViewController {
    // MARK: - Properties
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 내비게이션 바에 로고 이미지
        let logoImage = UIImage(named: "logo_full.png")
        let logoImageView = UIImageView(image: logoImage)

        logoImageView.contentMode = .scaleAspectFit

        self.navigationItem.titleView = logoImageView
        
        // 네비게이션 바 줄 없애기
        //self.navigationController?.navigationBar.shadowImage = UIImage() -> 안됨
        // self.navigationController?.navigationBar.standardAppearance.shadowImage = UIImage() -> 안됨...
        self.navigationController?.navigationBar.standardAppearance.shadowColor = .white  // 스크롤하지 않는 상태
        self.navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = .white  // 스크롤하고 있는 상태
        
        // info 버튼
        //create a new button
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.setImage(UIImage(named: "ic_info"), for: .normal)
        button.addTarget(self, action: #selector(infoBtnTapped), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        // back 버튼 커스텀
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func infoBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HomeTab", bundle: nil)
        let infoVC = storyboard.instantiateViewController(withIdentifier: "InfoVC") as! InfoViewController
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    

    // MARK: - Navigation

}
