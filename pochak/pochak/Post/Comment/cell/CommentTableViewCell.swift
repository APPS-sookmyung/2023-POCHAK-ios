//
//  CommentTableViewCell.swift
//  pochak
//
//  Created by Suyeon Hwang on 2023/07/10.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var commentTextView: MentionTextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var commentUserHandleLabel: UILabel!
    @IBOutlet weak var timePassedLabel: UILabel!
    @IBOutlet weak var childCommentBtn: UIButton!
    
    var taggedId: String = ""
    var loggedinUserHandle: String?
    var deleteButton = UIButton()
    var commentVC: CommentViewController!
    var commentId: Int!
    
    // comment view controller에서 받는 댓글 입력창
    var editingCommentTextView: UITextView!
    var tableView: UITableView!
    
    let seeChildCommentBtn = UIButton()
    
    // MARK: - Action
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loggedinUserHandle = UserDefaultsManager.getData(type: String.self, forKey: .handle)
        
        /* commentTextView 초기화 */
        
        // commentTextView의 inset 제거
        commentTextView.textContainerInset = .zero
        commentTextView.textContainer.lineFragmentPadding = 0
        
        
//        commentTextView.delegate = (self.textView(commentTextView, shouldInteractWith: <#T##URL#>, in: <#T##NSRange#>, interaction: <#T##UITextItemInteraction#>) as! any UITextViewDelegate)
        
        // commentTextView에서 아이디 찾기
        commentTextView.findOutMetionedId()
        
        commentTextView.delegate = self
        
        // 크기 반만큼 radius
        profileImageView.layer.cornerRadius = 17.5
        
        // 사용자(아이디로) 멘션 기능 (댓글에서 아이디 탐지)
        //taggedId = commentLabel.findOutMentionedId()
        
        // label이 터치 인식할 수 있도록 gesture recognizer 추가
        //let recognizer = UITapGestureRecognizer(target: self, action: #selector(taggedIdTapped))
        //commentLabel.addGestureRecognizer(recognizer)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Actions
    @IBAction func postChildCmmtBtnDidTap(_ sender: UIButton) {
        // 부모 댓글을 단다는 것을 comment vc에 알려야 함
        commentVC.isPostingChildComment = true
        commentVC.parentCommentId = self.commentId
        
        let indexPath = tableView.indexPath(for: self)
        // 답글을 다려는 셀을 맨 위로 이동
        tableView.scrollToRow(at: indexPath!, at: .top, animated: true)
        
        // fade in, fade out 으로 색상 변경 
        let oldColor = self.backgroundColor
        UIView.animate(withDuration: 0.9, animations: {
            self.backgroundColor = UIColor(named: "navy03")
            }, completion: { _ in
                UIView.animate(withDuration: 0.5) {
                    self.backgroundColor = oldColor
                }
        })
        editingCommentTextView.becomeFirstResponder()
    }
    
    // MARK: - Helpers
    func setupData(_ comment: UICommentData){
        // 현재 댓글 아이디 저장
        self.commentId = comment.commentId
        
        // 프로필 이미지
        let profileImgStr = comment.profileImage
            let url = URL(string: profileImgStr)
            // main thread에서 load할 경우 URL 로딩이 길면 화면이 멈춘다.
            // 이를 방지하기 위해 다른 thread에서 처리함.
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url!) {
                    if let image = UIImage(data: data) {
                        //UI 변경 작업은 main thread에서 해야함.
                        DispatchQueue.main.async {
                            self?.profileImageView.image = image
                        }
                    }
                }
            }
        
        self.commentUserHandleLabel.text = comment.handle
        self.commentTextView.text = comment.content
        
        /* 로그인된 유저의 댓글인 경우 삭제 버튼 생성*/
        if(comment.handle == loggedinUserHandle){
            self.addSubview(deleteButton)
            
            // 오토레이아웃 설정
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            
            deleteButton.leadingAnchor.constraint(equalTo: self.childCommentBtn.trailingAnchor, constant: 5.0).isActive = true
            deleteButton.centerYAnchor.constraint(equalTo: self.childCommentBtn.centerYAnchor).isActive = true
            
            deleteButton.setTitle("삭제", for: .normal)
            deleteButton.setTitleColor(UIColor(named: "gray04"), for: .normal)
            deleteButton.backgroundColor = .clear
            deleteButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 11.0)
        }
        
        // comment.uploadedTime 값: 2023-12-27T19:03:32.701
        // 시간 계산
        let arr = comment.createdDate.split(separator: "T")  // T를 기준으로 자름, ["2023-12-27", "19:03:32.701"]
        let timeArr = arr[arr.endIndex - 1].split(separator: ".")  // ["19:03:32", "701"]
        
        let uploadedTime = arr[arr.startIndex] + " " + timeArr[timeArr.startIndex]
        
        // 현재 시간
        let currentTime = Date()
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let startTime = format.date(from: String(uploadedTime))!
        let endStr = format.string(from: currentTime)
        let endTime = format.date(from: endStr)
        
        let timePassed = Int(endTime!.timeIntervalSince(startTime))  // 초단위 리턴
        // 초
        if(timePassed >= 0 && timePassed < 60){
            self.timePassedLabel.text = String(timePassed) + "초"
        }
        // 분
        else if(timePassed >= 60 && timePassed < 3600){
            self.timePassedLabel.text = String(timePassed / 60) + "분"
        }
        // 시
        else if(timePassed >= 3600 && timePassed < 24*60*60){
            self.timePassedLabel.text = String(timePassed / 3600) + "시간"
        }
        
        // 일
        else if(timePassed >= 24*60*60 && timePassed < 7*24*60*60){
            self.timePassedLabel.text = String(timePassed/(24*60*60)) + "일"
        }
        
        // 주
        else{
            self.timePassedLabel.text = String(timePassed / (7*24*60*60)) + "주"
        }
    }

}


// MARK: - Extensions
// commentTextView를 위한 delegate
extension CommentTableViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if let mentionTextView = textView as? MentionTextView,
           let text = Int(url.debugDescription) {
            print(mentionTextView.idArray[text])
            return false
        }
        return false
    }
}
