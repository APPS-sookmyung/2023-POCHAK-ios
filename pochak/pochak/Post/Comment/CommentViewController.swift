//
//  CommentViewController.swift
//  pochak
//
//  Created by Suyeon Hwang on 2023/07/08.
//

import UIKit
import Kingfisher

class CommentViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var CommentInputViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    let textViewPlaceHolder = "이 게시물에 댓글을 달아보세요"
    var loggedinUserHandle: String!  // 현재 로그인된 유저의 아이디
    
    // postVC에서 넘겨주는 값
    var postId: Int?
    var postUserHandle: String?
    
    public var childCommentCntList = [Int]()  // 섹션 당 셀 개수 따로 저장해둘 리스트 필요함 (부모 댓글의 자식 댓글 개수 저장)
    
    private var commentDataResponse: CommentDataResponse?
    private var commentDataResult: CommentDataResult?
    private var parentCommentList: [ParentCommentData]?  // 부모댓글 + 자식댓글 있는 list
    private var childCommentDataResponse: ChildCommentDataResponse?
    private var childCommentDataList: [ChildCommentData]?
    
    var uiCommentList = [UICommentData]()  // 셀에 뿌릴 때 사용할 실제 데이터들
    private var tempChildCommentList = [UICommentData]()
    
    private var postCommentResponse: PostCommentResponse?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UserDefaults에서 현재 로그인된 유저 핸들 가져오기
        loggedinUserHandle = UserDefaultsManager.getData(type: String.self, forKey: .handle)
        print("current logged in user handle is : \(loggedinUserHandle)")
        
        // 테이블 뷰 세팅
        setUpTableView()
        
        /* 1번만 실행돼도 되는 초기화 과정 */
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
        
        // 사용자 프로필 사진 크기 반만큼 radius
        userProfileImageView.layer.cornerRadius = 17.5
        
        // 댓글 데이터 조회
        loadCommentData()
    }
    
    // MARK: - Helpers
    private func loadCommentData(){
        print("postid: \(postId)")
        CommentDataService.shared.getComments(postId!) { (response) in
            // NetworkResult형 enum으로 분기 처리
            switch(response){
            case .success(let commentDataResponse):
                self.commentDataResponse = commentDataResponse as? CommentDataResponse
                self.commentDataResult = (self.commentDataResponse?.result)!
                self.parentCommentList = self.commentDataResult?.parentCommentList  // 데이터로 넘어온 부모 댓글(+자식댓글)리스트

                self.uiCommentList.removeAll()
                //self.childCommentCntList.removeAll()
                
                // 댓글 존재할 때만
                if(self.parentCommentList != nil){
                    // 부모 댓글 자체를 부모 댓글인지의 여부가 있는 UICommentData형으로 만들어서 추가
                    for parentData in self.parentCommentList ?? [] {
                        self.uiCommentList.append(UICommentData(commentId: parentData.commentId, profileImage: parentData.profileImage, handle: parentData.handle, createdDate: parentData.createdDate, content: parentData.content, isParent: true))
                        
                        // 부모 댓글의 자식 댓글을 리스트에 추가
                        for childData in parentData.childCommentList {
                            self.uiCommentList.append(UICommentData(commentId: childData.commentId, profileImage: childData.profileImage, handle: childData.handle, createdDate: childData.createdDate, content: childData.content, isParent: false))
                        }
                    }
                }
                print("=== loading comment data ===")
                print(self.uiCommentList)
                
                print("=== init ui ===")
                self.initUI()
                
                // title 내용 설정
                self.titleLabel.text = self.postUserHandle!+" 님의 게시물 댓글"
                // 대댓글있는지 다 확인?
//                if(self.commentDataList != nil){
//                    //self.loadChildCommentData()
//                    self.initUI()
//                }
                
                //self.tableView.reloadData()
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
        if let url = URL(string: (commentDataResult?.loginMemberProfileImage)!) {
            self.userProfileImageView.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    print("Image successfully loaded: \(value.image)")
                case .failure(let error):
                    print("Image failed to load with error: \(error.localizedDescription)")
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    private func setUpTableView(){
        print("=== setting up table view ===")
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
        
        // 테이블뷰에 footer view nib 등록
        tableView.register(UINib(nibName: "CommentTableViewFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CommentTableViewFooterView")
        
        print("=== tableview setup done ===")
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
            CommentDataService.shared.postComment(postId!, commentTextView.text, nil) { (response) in
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
                    print("=== 새 댓글 등록, 데이터 업데이트 ===")
                    self.loadCommentData()
                case .requestErr(let message):
                    print("requestErr", message)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
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
    
    // 추후 섹션 2개로 생성하도록 수정 -> 0번째는 댓글, 1번째는 로딩 인디케이터로
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 한 섹션에 몇 개의 셀을 넣을지 -> 1(부모댓글 자신) + 자식댓글 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uiCommentList.count
    }
    
    // 어떤 셀을 보여줄지
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let cellData = self.uiCommentList
        
        // 셀을 그리기 위해 인덱스를 계산 해야 함
//        var childCommentsSoFar = 0
//        if(section != 0){
//            for index in 0...section - 1 {
//                childCommentsSoFar += self.childCommentCntList[index]
//            }
//        }
//        
//        var finalIndex = section + indexPath.row + childCommentsSoFar
//        print("=== finalIndex: \(finalIndex)")
//        
//        print("=== 현재 셀에 그리는 데이터 ===")
//        print(cellData[finalIndex])
        
        // 부모 댓글인 경우
        if cellData[indexPath.row].isParent {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else{
                return UITableViewCell()
            }
            cell.setupData(cellData[indexPath.row])
            return cell
            
        }
        // 자식 댓글인 경우
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyTableViewCell", for: indexPath)
                    as? ReplyTableViewCell else{
                return UITableViewCell()
            }
            cell.setupData(cellData[indexPath.row])
            return cell
        }
    }
    
    // 나중에 대댓글 더 조회해야 될 때 변경..
    
//    // footer cell 등록, 보여주기
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier:
//                      "CommentTableViewFooterView") as! CommentTableViewFooterView
//        // footer에게 CommentViewController 전달
//        //footerView.tableView = self.tableView
//        footerView.commentVC = self
//        footerView.postId = self.postId
//
//
//        if let cellData = self.commentDataList {
//            if cellData[section].recentComment != nil {
//                //footerView.backgroundColor = .blue
//                footerView.curCommentId = cellData[section].commentSK
//                return footerView
//            }
//            else {
//                return nil
//            }
//        }
//        else{
//            return nil
//        }
//    }
    
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
    
    // 이상한 여백 제거?
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if let cellData = self.commentDataList {
//            if cellData[section].recentComment == nil {
//                return .leastNonzeroMagnitude
//            }
//        }
//        return UITableView.automaticDimension
//    }
    
    // grouped 스타일 테이블뷰이기 때문에 자동 생성되는 헤더 높이를 0으로
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
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


