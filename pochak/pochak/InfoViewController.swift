//
//  InfoViewController.swift
//  pochak
//
//  Created by Suyeon Hwang on 2023/07/05.
//

import UIKit

class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바 타이틀에 로고 이미지
        let logoImage = UIImage(named: "logo_full.png")
        let logoImageView = UIImageView(image: logoImage)
        
        logoImageView.contentMode = .scaleAspectFit

        self.navigationItem.titleView = UIImageView(image: logoImage)
        
        // 네비게이션 바 밑줄 없애기
        self.navigationController?.navigationBar.standardAppearance.shadowColor = .white
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
