//
//  UploadViewController.swift
//  pochak
//
//  Created by 장나리 on 2023/07/05.
//

import UIKit
import AVFoundation
import SwiftUI



class UploadViewController: UIViewController {
    
    
    lazy var backButton: UIBarButtonItem = { // 업로드 버튼
        let backBarButtonItem = UIBarButtonItem(image:UIImage(named: "back_btn"), style: .plain, target: self, action: #selector(backbuttonPressed(_:)))
        

        backBarButtonItem.tintColor = UIColor.black  // 색상 변경
        return backBarButtonItem
        }()

    lazy var rightButton: UIBarButtonItem = { // 업로드 버튼
        let button = UIBarButtonItem(title: "업로드", style: .plain, target: self, action: #selector(uploadbuttonPressed(_:)))
        
        button.tintColor = UIColor.red // 색 노란색으로 바꾸기
        return button
        }()
    
    
//    
    
    @IBOutlet weak var captionField: UITextView!
    
    @IBOutlet weak var captionCountText: UILabel!
    
    @IBOutlet weak var tagSearch: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = self.rightButton // 업로드 버튼
        self.navigationItem.leftBarButtonItem = self.backButton
//        // back button 커스텀
//        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
//        self.navigationController?.navigationBar.tintColor = .black
//
//        btnBack.addTarget(self, action: #selector(btnBackTapped), for: .touchUpInside)
//
//        self.navigationController?.navigationBar.topItem?.backAction = UIAction(handler: backbuttonPressed(_:))
        captionField.delegate = self
        
        tagSearch.searchBarStyle = .minimal
        
        
        //테그 검색 창 버튼 이미지 설정
        tagSearch.setImage(UIImage(named: "search"), for: UISearchBar.Icon.search, state: .normal)
        
        tagSearch.setImage(UIImage(named: "clear"), for: .clear, state: .normal)
        
        //태그검색 창 글씨 크기 설정
        let attributedString = NSMutableAttributedString(string: "친구를 태그해보세요!", attributes: [
               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12) as Any
           ])
        tagSearch.searchTextField.attributedPlaceholder = attributedString
        tagSearch.searchTextField.font = UIFont.boldSystemFont(ofSize: 12)
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
    }
    // Button event.
    @objc private func backbuttonPressed(_ sender: Any) {//업로드 버튼 클릭시 어디로 이동할지
        print("back")

        let sheet = UIAlertController(title:"입력을 취소하고 페이지를 나갈까요?",message: "페이지를 벗어나면 현재 입력된 내용은 저장되지 않으며, 모두 사라집니다.", preferredStyle: UIAlertController.Style.alert)

        sheet.addAction(UIAlertAction(title: "나가기", style: .destructive, handler: { _ in
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
            
        }))
                
        sheet.addAction(UIAlertAction(title: "계속하기!", style: .cancel, handler: nil))
        
        
        self.present(sheet,animated: true,completion: nil)
        
        }
    
    @objc private func uploadbuttonPressed(_ sender: Any) {//업로드 버튼 클릭시 어디로 이동할지
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        tabBarController?.selectedIndex = 0
        
        }
    
}

extension UploadViewController : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText = textView.text else {return false}
        guard let stringRange = Range(range, in: currentText) else {return false}
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        captionCountText.text = "\(currentText.count)/50" // 글자수 보여주는 label 변경
        
        //최대 글자수(50자) 이상 입력 불가
        return changedText.count <= 49
    }
}

