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
    @IBOutlet weak var followingBtn: UIButton!
    @IBOutlet weak var labelHowManyLikes: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postOwnerHandle: UILabel!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var mainCommentHandle: UILabel!
    @IBOutlet weak var mainCommentContent: UILabel!
    @IBOutlet weak var taggedUsers: UILabel!
    @IBOutlet weak var pochakUser: UILabel!
    
    let tempPostId = "POST%23eb472472-97ea-40ab-97e7-c5fdf57136a0"
    
    //var postOwner: String = ""
    //private var isFollowing: Bool = false  // 임시로 초깃값은 false -> 나중에 변경
    private var isFollowingColor: UIColor = UIColor(named: "gray03") ?? UIColor(hexCode: "FFB83A")
    private var isNotFollowingColor: UIColor = UIColor(named: "yellow00") ?? UIColor(hexCode: "C6CDD2")
    
    private var postDataResponse: PostDataResponse!
    private var postDataResult: PostDataResponseResult!
    
//    private var likeUsersDataResponse: LikedUsersDataResponse!

    private var likePostResponse: LikePostDataResponse!
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPostDetailData()
        
        /* 서버 통신 */
        // PostDataService 구조체에서 shared라는 공용 인스턴스에 접근 -> 싱글턴 패턴
//        let queue = DispatchQueue.global()
//        queue.sync{
//            PostDataService.shared.getPostDetail(tempPostId) { (response) in
////                print("1 queue")
//                // NetworkResult형 enum으로 분기 처리
//                switch(response){
//                case .success(let postData):
//                    self.postDataResponse = postData as? PostDataResponse
//                    self.postDataResult = self.postDataResponse.result
////                    print(self.postDataResult)
////                    print(self.postDataResponse)
//                    self.initUI()
//                case .requestErr(let message):
//                    print("requestErr", message)
//                case .pathErr:
//                    print("pathErr")
//                case .serverErr:
//                    print("serveErr")
//                case .networkFail:
//                    print("networkFail")
//                }
//            }
//
//        LikedUsersDataService.shared.getLikedUsers(tempPostId) {(response) in
//            // NetworkResult형 enum으로 분기 처리
//            switch(response){
//            case .success(let likedUsersData):
//                self.likeUsersDataResponse = likedUsersData as? LikedUsersDataResponse
//                self.likedUsers = self.likeUsersDataResponse.result.likedUsers
//            case .requestErr(let message):
//                print("requestErr", message)
//            case .pathErr:
//                print("pathErr")
//            case .serverErr:
//                print("serveErr")
//            case .networkFail:
//                print("networkFail")
//            }
//        }
//        }
        
//        queue.sync{
//            print("2 queue")
//            // 크키에 맞게
//            scrollView.updateContentSize()
//
//            // 네비게이션 바 밑줄 없애기
//            self.navigationController?.navigationBar.standardAppearance.shadowColor = .white  // 스크롤하지 않는 상태
//            self.navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = .white  // 스크롤하고 있는 상태
//
//            // 내비게이션 바 타이틀 세팅
//            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Pretendard-bold", size: 20)!]
//            self.navigationItem.title = postDataResult.postOwnerHandle+" 님의 게시물"
//
//            // back button 커스텀
//            self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
//            self.navigationController?.navigationBar.tintColor = .black
//
//            // 태그된 사용자, 포착한 사용자
//            self.taggedUsers.text = ""
//            for handle in postDataResult.taggedUserHandles {
//                if(handle == postDataResult.taggedUserHandles.last){
//                    self.taggedUsers.text! += handle + " 님"
//                }
//                else{
//                    self.taggedUsers.text! += handle + " 님 • "
//                }
//            }
//            self.pochakUser.text = postDataResult.postOwnerHandle + " 님이 포착"
//
//            self.postOwnerHandle.text = postDataResult.postOwnerHandle
//            self.postContent.text = postDataResult.caption
//
//            // 댓글 미리보기
//            if(postDataResult.mainComment == nil){
//                self.mainCommentContent.text = postDataResponse.message
//            }
//            else{
//                self.mainCommentHandle.text = postDataResult.mainComment!.userHandle
//                self.mainCommentContent.text = postDataResult.mainComment!.content
//            }
//
//            // 프로필 사진 동그랗게 -> 크기 반만큼 radius
//            profileImageView.layer.cornerRadius = 25
//
//            // 좋아요 누른 사람 수 라벨에 대한 제스쳐 등록 -> 액션 연결
//            let howManyLikesLabelGesture = UITapGestureRecognizer(target: self, action: #selector(showPeopleWhoLiked))
//            labelHowManyLikes.addGestureRecognizer(howManyLikesLabelGesture)
//            self.labelHowManyLikes.text = "\(postDataResult.numOfHeart)명"
//
//            // 팔로잉 버튼
//            //self.isFollowing = postDataResult.isFollow
//            self.followingBtn.isSelected = postDataResult.isFollow
//            self.followingBtn.backgroundColor = postDataResult.isFollow ?
//            self.isFollowingColor : self.isNotFollowingColor
//            self.followingBtn.setTitleColor(UIColor.white, for: [.normal, .selected])
//            self.followingBtn.setTitle("팔로우", for: .normal)
//            self.followingBtn.setTitle("팔로잉", for: .selected)
//            followingBtn.layer.cornerRadius = 4.97
//        }
    }
    
    private func initUI(){
        // 크키에 맞게
        scrollView.updateContentSize()
        
        // 포스트 이미지
        var url = URL(string: postDataResult.postImageUrl)
        // main thread에서 load할 경우 URL 로딩이 길면 화면이 멈춘다.
        // 이를 방지하기 위해 다른 thread에서 처리함.
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    //UI 변경 작업은 main thread에서 해야함.
                    DispatchQueue.main.async {
                        self?.postImage.image = image
                    }
                }
            }
        }
        
        // 프로필 이미지
        url = URL(string: postDataResult.postOwnerProfileImage)
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.profileImageView.image = image
                    }
                }
            }
        }
        
        // 네비게이션 바 밑줄 없애기
        self.navigationController?.navigationBar.standardAppearance.shadowColor = .white  // 스크롤하지 않는 상태
        self.navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = .white  // 스크롤하고 있는 상태
        
        // 내비게이션 바 타이틀 세팅
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Pretendard-bold", size: 20)!]
        self.navigationItem.title = postDataResult.postOwnerHandle+" 님의 게시물"
        
        // back button 커스텀
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
        
        // 태그된 사용자, 포착한 사용자
        self.taggedUsers.text = ""
        for handle in postDataResult.taggedUserHandles {
            if(handle == postDataResult.taggedUserHandles.last){
                self.taggedUsers.text! += handle + " 님"
            }
            else{
                self.taggedUsers.text! += handle + " 님 • "
            }
        }
        self.pochakUser.text = postDataResult.postOwnerHandle + " 님이 포착"
        
        // 포스트 내용
        self.postOwnerHandle.text = postDataResult.postOwnerHandle
        self.postContent.text = postDataResult.caption
        
        
        // 댓글 미리보기
        if(postDataResult.mainComment == nil){
            self.mainCommentContent.text = postDataResponse.message
        }
        else{
            self.mainCommentHandle.text = postDataResult.mainComment!.userHandle
            self.mainCommentContent.text = postDataResult.mainComment!.content
        }
        
        // 프로필 사진 동그랗게 -> 크기 반만큼 radius
        profileImageView.layer.cornerRadius = 25
        
        // 좋아요 버튼 (내가 눌렀는지 안했는지)
        self.btnLike.isSelected = postDataResult.isLike
        print("isLike: ")
        print(postDataResult.isLike)
        print("like button status: ")
        print(self.btnLike.isSelected)
        
        // 좋아요 누른 사람 수 라벨에 대한 제스쳐 등록 -> 액션 연결
        let howManyLikesLabelGesture = UITapGestureRecognizer(target: self, action: #selector(showPeopleWhoLiked))
        labelHowManyLikes.addGestureRecognizer(howManyLikesLabelGesture)
        self.labelHowManyLikes.text = "\(postDataResult.numOfHeart)명"
        
        // 팔로잉 버튼
        //self.isFollowing = postDataResult.isFollow
        self.followingBtn.isSelected = postDataResult.isFollow
        self.followingBtn.backgroundColor = postDataResult.isFollow ? self.isFollowingColor : self.isNotFollowingColor
        self.followingBtn.setTitleColor(UIColor.white, for: [.normal, .selected])
        self.followingBtn.setTitle("팔로우", for: .normal)
        self.followingBtn.setTitle("팔로잉", for: .selected)
        followingBtn.layer.cornerRadius = 4.97
    }
    
    func loadPostDetailData(){
        PostDataService.shared.getPostDetail(tempPostId) { (response) in
//                print("1 queue")
            // NetworkResult형 enum으로 분기 처리
            switch(response){
            case .success(let postData):
                self.postDataResponse = postData as? PostDataResponse
                self.postDataResult = self.postDataResponse.result
//                    print(self.postDataResult)
//                    print(self.postDataResponse)
                self.initUI()
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serveErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func followinBtnTapped(_ sender: Any) {
        // 언팔로우하기
        if followingBtn.isSelected {
            followingBtn.isSelected = false
            followingBtn.backgroundColor = isNotFollowingColor
        }
        // 팔로우하기
        else{
            followingBtn.isSelected = true
            followingBtn.backgroundColor = isFollowingColor
        }
    }
    
    @objc func showPeopleWhoLiked(sender: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "PostTab", bundle: nil)
        let postLikesVC = storyboard.instantiateViewController(withIdentifier: "PostLikesVC") as! PostLikesViewController
        
        postLikesVC.modalPresentationStyle = .pageSheet
        // 좋아요 누른 사람 페이지에 포스트 아이디, 포스트 게시자 아이디 전달
        postLikesVC.postId = self.tempPostId
        postLikesVC.postOwnerHandle = self.postDataResult.postOwnerHandle
        
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
        // 서버 연결
        LikedUsersDataService.shared.postLikeRequest(tempPostId){(response) in
            // NetworkResult형 enum으로 분기 처리
            switch(response){
            case .success(let likePostResponse):
                self.likePostResponse = likePostResponse as? LikePostDataResponse
                if(!self.likePostResponse.isSuccess!){
                    // 인스턴스 생성
                    //let alert = UIAlertController(title: "알림", message: "좋아요가 반영되지 못했습니다.", preferredStyle: .alert)
                    print(self.likePostResponse.message)
                }
                print(self.likePostResponse.message)
                self.loadPostDetailData()
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serveErr")
            case .networkFail:
                print("networkFail")
            }
        }
//        loadPostDetailData()
        
//        // 좋아요 취소
//        if btnLike.isSelected {
//            btnLike.isSelected = false
//        }
//        // 좋아요 하기
//        else{
//            btnLike.isSelected = true
//        }
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
