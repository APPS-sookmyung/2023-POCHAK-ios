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
    
    let textViewPlaceHolder = "한 줄 캡션 입력하기"
    
    var receivedImage : UIImage?
    
    @IBOutlet weak var captureImg: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var backButton: UIBarButtonItem = { // 업로드 버튼
        let backBarButtonItem = UIBarButtonItem(image:UIImage(named: "back_btn"), style: .plain, target: self, action: #selector(backbuttonPressed(_:)))
        

        backBarButtonItem.tintColor = UIColor.black
        return backBarButtonItem
        }()

    lazy var rightButton: UIBarButtonItem = { // 업로드 버튼
        let button = UIBarButtonItem(title: "업로드", style: .plain, target: self, action: #selector(uploadbuttonPressed(_:)))
        button.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Pretendard-bold", size: 14)!
        ], for: .normal)
        button.tintColor = UIColor(named: "yellow00")// 색 노란색으로 바꾸기
        return button
        }()
    
    
    @IBOutlet weak var captionField: UITextView!
    
    @IBOutlet weak var captionCountText: UILabel!
    
    @IBOutlet weak var tagSearch: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 이미지 설정
        if let image = receivedImage {
            captureImg.image = image
        }
        
        self.navigationItem.rightBarButtonItem = self.rightButton // 업로드 버튼
        self.navigationItem.leftBarButtonItem = self.backButton
        
        
        captionField.text = textViewPlaceHolder
        captionField.textColor = UIColor(named: "gray04")
        captionField.delegate = self
        
        captionCountText.font = UIFont(name: "Pretendard-medium", size: 12)
        tagSearch.searchBarStyle = .minimal
        
        //테그 검색 창 버튼 이미지 설정
        tagSearch.setImage(UIImage(named: "search"), for: UISearchBar.Icon.search, state: .normal)
        
        tagSearch.setImage(UIImage(named: "clear"), for: .clear, state: .normal)
        
        //태그검색 창 글씨 크기 설정
        let attributedString = NSMutableAttributedString(string: "친구를 태그해보세요!", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Pretendard-medium",size:12) as Any
           ])
        

        tagSearch.searchTextField.attributedPlaceholder = attributedString

        tagSearch.searchTextField.font = UIFont(name: "Pretendard-medium",size:12)

        //아이디 태그 collectionview
        setupCollectionView()


    }
    
    // Button event
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
    private func setupCollectionView(){
        //delegate 연결
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //cell 등록
        collectionView.register(UINib(
            nibName: "TagCollectionViewCell",
            bundle: nil),forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        
    }
}

extension UploadViewController : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {return false}
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        captionCountText.text = "\(currentText.count)/50" // 글자수 보여주는 label 변경
        
        if(currentText.count > 50){
            textView.textColor = .red

        }
        else{
            textView.textColor = .black

        }
        
        //최대 글자수(50자) 이상 입력 불가
        return changedText.count <= 50
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) { // placeholder 적용 ("한 줄 캡션 입력하기")
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
}

extension UploadViewController: UICollectionViewDelegate, UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as? TagCollectionViewCell else{
            fatalError("셀 타입 캐스팅 실패2")
        }
        //                let itemIndex = indexPath.item
        //                if let cellData = self.userPosts{
        //                    // 데이터가 있는 경우, cell 데이터를 전달
        //                    cell.setupData(cellData[itemIndex].postImgUrl)
        //                }
        // <- 데이터 전달
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("view post btn tapped")

        let sheet = UIAlertController(title:"알림",message: "태그를 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)

        sheet.addAction(UIAlertAction(title: "네", style: .destructive, handler: { _ in
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
            
        }))
                
        sheet.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: nil))
        
        
        self.present(sheet,animated: true,completion: nil)
        
        }

}

        
extension UploadViewController: UICollectionViewDelegateFlowLayout {
    
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return CGFloat(4)

    }

    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return CGFloat(12)


        }

            
    // cell 사이즈( 옆 라인을 고려하여 설정 )
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 77, height: 32)
//    }
}


