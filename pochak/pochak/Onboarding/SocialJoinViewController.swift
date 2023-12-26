//
//  SocialLoginViewController.swift
//  pochak
//
//  Created by Seo Cindy on 2023/08/13.
//

import UIKit
import GoogleSignIn

class SocialJoinViewController: UIViewController {
    
    var googleLoginResultArray : [GoogleLoginModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        btnLayout()
        
        // MARK: - Navigation Controller Back Button Custom
        // Title
        let attrs : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Bold", size: 20)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        
        // Back Button
        /// 주의점 : backBarButtonItem 사용 시 FirstViewController에서 지정!
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
    }
    
    
    @IBOutlet weak var googleLoginBtn: UIButton!
    @IBOutlet weak var appleLoginBtn: UIButton!
    @IBOutlet weak var goToLoginBtn: UIButton!
    
   // MARK: - Button Design
    private func btnLayout(){
        
        // 소셜 로그인 버튼 디자인
        googleLoginBtn.layer.cornerRadius = 30
        ///테두리 두께 설정해야 함!
        googleLoginBtn.layer.borderWidth = 1
        googleLoginBtn.layer.borderColor = UIColor(named: "gray02")?.cgColor
        appleLoginBtn.layer.cornerRadius = 30
        
        // String Custom : 이미 계정이 있으신가요?
        if let font = UIFont(name: "Pretendard-Bold", size: 16) {
            let customAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black,
                .underlineStyle: 1
            ]
            let attributedString = NSAttributedString(string: "이미 계정이 있으신가요?", attributes: customAttributes)
            goToLoginBtn.setAttributedTitle(attributedString, for: .normal)
        } else {return}
    }
    
    // MARK: - Button Action
    // to use Push VC has to be in navigation controller : Editor > Embed in > Navigation Controller
    @IBAction func goToLoginBtnTapped(_ sender: UIButton) {
        guard let socialLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "SocialLoginVC") as? SocialLoginViewController else {return}
        self.navigationController?.pushViewController(socialLoginVC, animated: true)
    }
    
    // MARK: - Google Login
    @IBAction func googleLoginAction(_ sender: Any) {
//        if let url = URL(string: "https://accounts.google.com/o/oauth2/v2/auth/oauthchooseaccount?client_id=472179052690-2dlbksg09ia20hb4vcpv7fej56crekqm.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Fpochak.site%2Fgoogle%2Flogin&response_type=code&scope=email%20profile&service=lso&o2v=2&theme=glif&flowName=GeneralOAuthFlow") {
//                    UIApplication.shared.open(url, options: [:])
//                }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            
            // 정보 확인
//            let user = signInResult.user
//            let emailAddress = user.profile?.email
//            let fullName = user.profile?.name
//            print(user)
//            print(emailAddress)
//            print(fullName)

            signInResult.user.refreshTokensIfNeeded { user, error in
                guard error == nil else { return }
                guard let user = user else { return }

                let idToken = user.idToken?.tokenString
                // Send ID token to backend (example below).
                self.tokenSignInExample(idToken: idToken ?? "")
            }
        }
        
//        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, _ in
//            guard let self,
//                  let signInResult = signInResult else { return }
//            let user = signInResult.user
//            let emailAddress = user.profile?.email
//            let fullName = user.profile?.name
//            let givenName = user.profile?.givenName
//            let familyName = user.profile?.familyName
//            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
//            
//            // Send ID token to backend (example below).
//            user.refreshTokensIfNeeded { user, error in
//                guard error == nil else { return }
//                guard let user = user else { return }
//                let idToken = signInResult.user.idToken?.tokenString
//                
//                // Send ID token to backend (example below).
//                tokenSignInExample(idToken: idToken!)
//                }
//            }
        
        // 가입 완료 시 프로필 설정 화면으로 전환하기
        
//        toProfileSettingsPage()
//        GoogleLoginDataManager().googleLoginDataManager(self)
        
    }
    
    func tokenSignInExample(idToken: String) {
        guard let authData = try? JSONEncoder().encode(["idToken": idToken]) else {
            return
        }
        let url = URL(string: "http://pochak.site/google/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        

        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
            print(response)
            // Handle response from your backend.
        }
        task.resume()
    }
    
    // MARK: - Apple Login
    
    
    // MARK: - profileSettingPage로 전환하기
    private func toProfileSettingsPage(){
        guard let makeProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "MakeProfileVC") as? MakeProfileViewController else {return}
        self.navigationController?.pushViewController(makeProfileVC, animated: true)
    }
    
}

extension SocialJoinViewController {
    func successAPI(_ result : [GoogleLoginModel]){
         googleLoginResultArray = result
    }
}
