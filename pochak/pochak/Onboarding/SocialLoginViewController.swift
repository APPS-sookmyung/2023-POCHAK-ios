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
    @IBOutlet weak var goToJoinBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLayout()
    }
    
   // MARK: - Button Design
    private func btnLayout(){
        // 소셜 로그인 버튼 디자인
        googleLoginBtn.layer.cornerRadius = 30
        ///테두리 두께 설정해야 함!
        googleLoginBtn.layer.borderWidth = 1
        googleLoginBtn.layer.borderColor = UIColor(named: "gray02")?.cgColor
        appleLoginBtn.layer.cornerRadius = 30
        
        
        // 아직 계정이 없으신가요?
        // String Custom : 이미 계정이 있으신가요?
        if let font = UIFont(name: "Pretendard-Bold", size: 16) {
            let customAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black,
                .underlineStyle: 1
            ]
            let attributedString = NSAttributedString(string: "아직 계정이 없으신가요?", attributes: customAttributes)
            goToJoinBtn.setAttributedTitle(attributedString, for: .normal)
        } else {return}
        
        // Hide Back Button
        self.navigationItem.setHidesBackButton(true, animated: true)

    }
    
    // MARK: - Back Button Action
    // PopVC
    @IBAction func goToJoinBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    

}
