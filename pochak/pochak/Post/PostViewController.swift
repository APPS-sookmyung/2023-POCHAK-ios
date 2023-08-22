//
//  PostViewController.swift
//  pochak
//
//  Created by Suyeon Hwang on 2023/07/04.
//

import UIKit

class PostViewController: UIViewController, UISheetPresentationControllerDelegate {
    // MARK: - properties
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var labelHowManyLikes: UILabel!
    
    var postOwner: String = ""
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 크키에 맞게
        scrollView.updateContentSize()
        
        // 네비게이션 바 밑줄 없애기
        self.navigationController?.navigationBar.standardAppearance.shadowColor = .white  // 스크롤하지 않는 상태
        self.navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = .white  // 스크롤하고 있는 상태
        
        // 내비게이션 바 타이틀 세팅
        postOwner = "Jal"  // 임시로 Jal 로 세팅
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Pretendard-bold", size: 20)!]
        self.navigationItem.title = postOwner+" 님의 게시물"
        
        // back button 커스텀
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
        
        // 프로필 사진 동그랗게 -> 크기 반만큼 radius
        profileImageView.layer.cornerRadius = 25
        
        // 좋아요 누른 사람 수 라벨에 대한 제스쳐 등록 -> 액션 연결
        let howManyLikesLabelGesture = UITapGestureRecognizer(target: self, action: #selector(showPeopleWhoLiked))
        labelHowManyLikes.addGestureRecognizer(howManyLikesLabelGesture)
            
            
    }
    
    // MARK: - Actions
    
    @objc func showPeopleWhoLiked(sender: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "PostTab", bundle: nil)
        let postLikesVC = storyboard.instantiateViewController(withIdentifier: "PostLikesVC") as! PostLikesViewController
        
        postLikesVC.modalPresentationStyle = .pageSheet
        
        // half sheet
        if let sheet = postLikesVC.sheetPresentationController {
            //지원할 크기 지정
            sheet.detents = [.medium(), .large()]
            //크기 변하는거 감지
            sheet.delegate = self
            //시트 상단에 그래버 표시 (기본 값은 false)
            sheet.prefersGrabberVisible = true
        }
        
        present(postLikesVC, animated: true)
    }
    
    @IBAction func moreCommentsBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "PostTab", bundle: nil)
        let commentVC = storyboard.instantiateViewController(withIdentifier: "CommentVC") as! CommentViewController
        
        commentVC.modalPresentationStyle = .pageSheet
        
        // half sheet
        if let sheet = commentVC.sheetPresentationController {
            //지원할 크기 지정
            sheet.detents = [.medium(), .large()]
            //크기 변하는거 감지
            sheet.delegate = self
                   
            //시트 상단에 그래버 표시 (기본 값은 false)
            sheet.prefersGrabberVisible = true
                    
            //처음 크기 지정 (기본 값은 가장 작은 크기)
            //sheet.selectedDetentIdentifier = .large
                    
            //뒤 배경 흐리게 제거 (기본 값은 모든 크기에서 배경 흐리게 됨)
            //sheet.largestUndimmedDetentIdentifier = .medium
        }
                
        present(commentVC, animated: true)
    }

    @IBAction func likeBtnTapped(_ sender: Any) {
        // 좋아요 취소
        if btnLike.isSelected {
            btnLike.isSelected = false
        }
        // 좋아요 하기
        else{
            btnLike.isSelected = true
        }
    }
    
}


// MARK: - Extensions

extension ViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        //크기 변경 됐을 경우
        print(sheetPresentationController.selectedDetentIdentifier == .large ? "large" : "medium")
    }
}

extension UIScrollView {
    func updateContentSize() {
        let unionCalculatedTotalRect = recursiveUnionInDepthFor(view: self)
        
        // 계산된 크기로 컨텐츠 사이즈 설정
        self.contentSize = CGSize(width: self.frame.width, height: unionCalculatedTotalRect.height+50)
    }
    
    private func recursiveUnionInDepthFor(view: UIView) -> CGRect {
        var totalRect: CGRect = .zero
        
        // 모든 자식 View의 컨트롤의 크기를 재귀적으로 호출하며 최종 영역의 크기를 설정
        for subView in view.subviews {
            totalRect = totalRect.union(recursiveUnionInDepthFor(view: subView))
        }
        
        // 최종 계산 영역의 크기를 반환
        return totalRect.union(view.frame)
    }
}
