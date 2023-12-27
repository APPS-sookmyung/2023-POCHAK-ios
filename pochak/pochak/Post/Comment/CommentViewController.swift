//
//  CommentViewController.swift
//  pochak
//
//  Created by Suyeon Hwang on 2023/07/08.
//

import UIKit

class CommentViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var CommentInputViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    let textViewPlaceHolder = "이 게시물에 댓글을 달아보세요"
    
    // postVC에서 넘겨주는 값
    var postId: String!
    var postUserHandle: String?
    
    private var commentDataResponse: CommentDataResponse?
    private var commentDataResult: CommentDataResult?
    private var commentList: [CommentData]?
    
    private var postCommentResponse: PostCommentResponse?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCommentData()
        
        /* commentView 초기 설정*/
//        // commentView의 댓글 입력 창(uitextview) inset 제거
//        commentTextView.textContainerInset = .zero
//        commentTextView.textContainer.lineFragmentPadding = 0
//        // delegate 설정
//        commentTextView.delegate = self
//        // 최대 줄 설정
//        //commentTextView.textContainer.maximumNumberOfLines = 5
//        // placeholder 설정
//        commentTextView.text = textViewPlaceHolder
//        commentTextView.textColor = UIColor(named: "gray03")
//
//        /* Keyboard 보여지고 숨겨질 때 발생되는 이벤트 등록 */
//        NotificationCenter.default.addObserver(  // 키보드 보여질 때
//            self,
//            selector: #selector(keyboardWillShow),
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil)
//        NotificationCenter.default.addObserver(  // 키보드 숨겨질 때
//            self,
//            selector: #selector(keyboardWillHide),
//            name: UIResponder.keyboardWillHideNotification,
//            object: nil)
//
//        // tableView의 프로토콜
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorStyle = .none  // cell 간 구분선 스타일
//
//        // tableView가 자동으로 셀 컨텐츠 내용 계산해서 높이 맞추도록
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 90
//
//        // nib은 CommentTableViewCell << 이 파일임
//        let commentNib = UINib(nibName: "CommentTableViewCell", bundle: nil)
//        tableView.register(commentNib, forCellReuseIdentifier: "CommentTableViewCell")  // tableview에 이 cell을 등록
//
//        // 테이블뷰에 ReplyTableViewCell 등록
//        let replyNib = UINib(nibName: "ReplyTableViewCell", bundle: nil)
//        tableView.register(replyNib, forCellReuseIdentifier: "ReplyTableViewCell")
//
//        // 사용자 프로필 사진 크기 반만큼 radius
//        userProfileImageView.layer.cornerRadius = 17.5

    }
    
    // MARK: - Helpers
    private func loadCommentData(){
        CommentDataService.shared.getComments(postId) {(response) in
            // NetworkResult형 enum으로 분기 처리
            switch(response){
            case .success(let commentDataResponse):
                self.commentDataResponse = commentDataResponse as? CommentDataResponse
                self.commentDataResult = self.commentDataResponse?.result
                self.commentList = self.commentDataResult?.comments
                print(self.commentList)
                
                // 대댓글있는지 다 확인?
                self.initUI()
                
                self.tableView.reloadData()
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
    
    private func initUI() {
        // 사용자 프로필 이미지
        var url = URL(string: (commentDataResult?.loginProfileImg)!)
        // main thread에서 load할 경우 URL 로딩이 길면 화면이 멈춘다.
        // 이를 방지하기 위해 다른 thread에서 처리함.
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    //UI 변경 작업은 main thread에서 해야함.
                    DispatchQueue.main.async {
                        self?.userProfileImageView.image = image
                    }
                }
            }
        }
        
        // commentView의 댓글 입력 창(uitextview) inset 제거
        commentTextView.textContainerInset = .zero
        commentTextView.textContainer.lineFragmentPadding = 0
        // delegate 설정
        commentTextView.delegate = self
        // 최대 줄 설정
        //commentTextView.textContainer.maximumNumberOfLines = 5
        // placeholder 설정
        commentTextView.text = textViewPlaceHolder
        commentTextView.textColor = UIColor(named: "gray03")
        
        /* Keyboard 보여지고 숨겨질 때 발생되는 이벤트 등록 */
        NotificationCenter.default.addObserver(  // 키보드 보여질 때
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(  // 키보드 숨겨질 때
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
        // tableView의 프로토콜
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none  // cell 간 구분선 스타일
        
        // tableView가 자동으로 셀 컨텐츠 내용 계산해서 높이 맞추도록
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        
        // nib은 CommentTableViewCell << 이 파일임
        let commentNib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.register(commentNib, forCellReuseIdentifier: "CommentTableViewCell")  // tableview에 이 cell을 등록
        
        // 테이블뷰에 ReplyTableViewCell 등록
        let replyNib = UINib(nibName: "ReplyTableViewCell", bundle: nil)
        tableView.register(replyNib, forCellReuseIdentifier: "ReplyTableViewCell")
        
        // 사용자 프로필 사진 크기 반만큼 radius
        userProfileImageView.layer.cornerRadius = 17.5
        
        // title 내용 설정
        titleLabel.text = postUserHandle!+" 님의 게시물을 좋아하는 사람"
        
        //print(self.CommentInputViewBottomConstraint.constant)
    }
    
    // 키보드 보여질 때
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
        // 키보드의 높이
        // let keyboardHeight = keyboardFrame.size.height
        // 댓글 입력 View 높이
        // let commentViewHeight = commentView.frame.height

        // 댓글입력view의 bottom constraint를 키보드 높이만큼 (홈버튼 없는 아이폰?)
        //CommentInputViewBottomConstraint.constant = keyboardHeight - self.view.safeAreaInsets.bottom
        // 스크롤뷰 오프셋을 키보드높이+댓글입력view 로 설정해서 스크롤뷰 내용이 다 보일 수 있도록
        //tableView.contentOffset.y = keyboardHeight + commentViewHeight
        
        // 홈 버튼 없는 아이폰들은 다 빼줘야함. (키보드 높이 - ....?)
        let finalHeight = keyboardFrame.size.height - self.view.safeAreaInsets.bottom
        
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
                
        // 키보드 올라오는 애니메이션이랑 동일하게 텍스트뷰 올라가게 만들기.
        UIView.animate(withDuration: animationDuration) {
                    self.CommentInputViewBottomConstraint.constant = finalHeight
                    self.view.layoutIfNeeded()
        }
        
       }

    // 키보드 숨겨질 때 -> 원래 상태로
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        let animationDuration = notification.userInfo![ UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
                
        UIView.animate(withDuration: animationDuration) {
                //self.CommentInputViewBottomConstraint.constant = CGFloat(34)
            self.CommentInputViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
//    private func updateDynamicHeight(){
//        //        let width = commentTextView.superview?.frame.width
//        //        let height = commentTextView.superview?.frame.height
//        //        commentTextView.superview?.frame = CGRect(x: <#T##Int#>, y: <#T##Int#>, width: <#T##Int#>, height: <#T##Int#>)
//        commentTextView.constraints.forEach { (constraint) in
//
//            /// 180 이하일때는 더 이상 줄어들지 않게하기
//            if estimatedSize.height <= 180 {
//
//            }
//            else {
//                if constraint.firstAttribute == .height {
//                    constraint.constant = estimatedSize.height
//                }
//            }
//        }
//    }
    
    // MARK: - Actions
    @IBAction func postNewCommentBtnTapped(_ sender: UIButton) {
        // 대댓글인지 댓글인지 확인해야 함
        print(commentTextView.text!)
        
        // api 연결, 오류 나면 알림창 띄우기
        
        // 댓글 내용이 있는 경우에만 POST 요청
        if(!commentTextView.text.isEmpty && commentTextView.text! != textViewPlaceHolder){
            print("textview is not empty")
            // 임시로 parentCommentSK는 nil로 지정
            CommentDataService.shared.postComment(postId, commentTextView.text, nil) { (response) in
                switch(response){
                case .success(let data):
                    self.postCommentResponse = (data as! PostCommentResponse)
                    // 만약 실패한 경우 실패했다고 알림창
                    if(self.postCommentResponse?.isSuccess == false){
                        let alert = UIAlertController(title: "댓글 등록에 실패하였습니다.", message: "다시 시도해주세요.", preferredStyle: UIAlertController.Style.alert)
                        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                        alert.addAction(action)
                        self.present(alert, animated: true)
                    }
                    self.loadCommentData()
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
        else{
            print("textview is empty")
        }
        
        // 댓글창 비우기
        //commentTextView.text = ""
        
        // 키보드 내리기
        commentTextView.endEditing(true)
        
        // 뷰컨트롤러 새로고침하기(데이터 다시 받아오기)
        
    }
}

// MARK: - Extensions (TableView)
extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    // UI 보기 위해 임시로 섹션 2개로 함
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // 한 섹션에 몇 개의 셀을 넣을지
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList?.count ?? 0
    }
    
    // 어떤 셀을 보여줄지
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 추후에 댓글인지 대댓글인지 분기하는 방식으로 수정할 것
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else{
//            return UITableViewCell()
//        }
//        return cell
        
        // 댓글에 대댓글이 있으면 한 번에...
        
        
        let section = indexPath.section
        
        switch section{
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else{
                return UITableViewCell()
            }
            if let cellData = self.commentList {
                cell.setupData(cellData[indexPath.row])
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyTableViewCell", for: indexPath) as? ReplyTableViewCell else{
                return UITableViewCell()
            }
            return cell
        }
    }
    
    // TableView의 rowHeight속성에 AutometicDimension을 통해 테이블의 row가 유동적이라는 것을 선언
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // 현재는 cell의 높이가 고정되어 있기 때문에 제대로 안 보임 -> height 다시 설정
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        // 스토리 테이블뷰 셀의 높이
//        if indexPath.row == 0 {
//            return 80
//        }
//        // 피드 테이블뷰 셀의 높이
//        else{
//            return 600
//        }
//    }
    
    // 이 cell이 보여질 때 어떻게 할지 -> 나중에 필요하면 작성
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard let tableViewCell = cell as? CommentTableViewCell else{
//            return
//        }
//        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
//    }
}

// MARK: - Extension (UITextView 동적 높이 조절)
extension CommentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        //let maxHeight:CGFloat = 100.0  // textView의 최대 높이
        
        //let currentLineCnt = Int(estimatedSize.height / (textView.font!.lineHeight))
        
        textView.constraints.forEach { (constraint) in
            
            // -> 뭐가 문젠지 몰라서 일단 보류
//            // 최대 높이보다 크면 더 이상 늘어나지 않게 하기
//            if estimatedSize.height >= maxHeight {
//                print("==============")
//                print("최대 높이보다 큽니다")
//                textView.isScrollEnabled = true
//                print("현재 scroll가능 여부: \(textView.isScrollEnabled)")
//                if constraint.firstAttribute == .height {
//                    constraint.constant = 100.0
//                }
//                print("height: \(textView.frame.height)")
//
//            }
//            else {  // 최대 높이보다는 작은 경우 크게
//                print("==============")
//                print("최대 높이보다 작습니다.")
//                textView.isScrollEnabled = false
//                if constraint.firstAttribute == .height {
//                    constraint.constant = estimatedSize.height
//                }
//                print("height: \(textView.frame.height)")
            
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    // 입력 시작되면
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "gray03") {
            textView.text = nil // 텍스트를 날려줌(placeholder 날리기)
            textView.textColor = UIColor.black
        }
        
    }
    // UITextView의 placeholder
    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = UIColor(named: "gray03")
//        }
    }
}
