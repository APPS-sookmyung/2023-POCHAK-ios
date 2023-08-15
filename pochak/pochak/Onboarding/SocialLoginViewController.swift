//
//  SocialLoginViewController.swift
//  pochak
//
//  Created by Seo Cindy on 2023/08/15.
//

import UIKit

class SocialLoginViewController: UIViewController {
    
    
    @IBOutlet weak var googleLoginBtn: UIButton!
    @IBOutlet weak var appleLoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLayout()

        // Do any additional setup after loading the view.
    }
    
   // MARK: - Button Design
    private func btnLayout(){
        // 소셜 로그인 버튼 디자인
        googleLoginBtn.layer.cornerRadius = 30
        ///테두리 두께 설정해야 함!
        googleLoginBtn.layer.borderWidth = 1
        googleLoginBtn.layer.borderColor = UIColor(named: "gray02")?.cgColor
        appleLoginBtn.layer.cornerRadius = 30
            

    }
    

}
