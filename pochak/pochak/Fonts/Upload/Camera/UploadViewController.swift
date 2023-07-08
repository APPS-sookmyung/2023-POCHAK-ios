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
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backbuttonPressed(_:)))
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
 
        self.navigationItem.backBarButtonItem = self.backButton
        
        
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
        print("good")

        let sheet = UIAlertController(title: "경고", message: "정말 휴지통으로 보내겠습니까?", preferredStyle: .alert)

        sheet.addAction(UIAlertAction(title: "Yes!", style: .destructive, handler: { _ in print("yes 클릭")}))
                
        sheet.addAction(UIAlertAction(title: "No!", style: .cancel, handler: { _ in print("yes 클릭") }))
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

