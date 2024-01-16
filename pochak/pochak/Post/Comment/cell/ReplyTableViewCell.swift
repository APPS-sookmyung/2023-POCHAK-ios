//
//  ReplyTableViewCell.swift
//  pochak
//
//  Created by Suyeon Hwang on 2023/07/16.
//

import UIKit

class ReplyTableViewCell: UITableViewCell {

    @IBOutlet weak var replyCommentTextView: MentionTextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var timePassedLabel: UILabel!
    @IBOutlet weak var contentLabel: MentionTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // replyCommentTextView의 inset 제거
        replyCommentTextView.textContainerInset = .zero
        replyCommentTextView.textContainer.lineFragmentPadding = 0
        
        // replyCommentTextView에서 아이디 찾기
        replyCommentTextView.findOutMetionedId()
        
        replyCommentTextView.delegate = self
        // 이미지뷰 반만큼 radius 적용 -> 동그랗게
        profileImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Helpers
    func setupData(_ commentData: UICommentData){
        // 프로필 이미지
        let profileImgStr = commentData.userProfileImg
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
        
        
        // 유저 핸들
        userHandleLabel.text = commentData.userHandle
        
        replyCommentTextView.text = commentData.content
        
        // comment.uploadedTime 값: 2023-12-27T19:03:32.701
        // 시간 계산
        let arr = commentData.uploadedTime.split(separator: "T")  // T를 기준으로 자름, ["2023-12-27", "19:03:32.701"]
        let timeArr = arr[arr.endIndex - 1].split(separator: ".")  // ["19:03:32", "701"]
        
        let uploadedTime = arr[arr.startIndex] + " " + timeArr[timeArr.startIndex]
        
        // 현재 시간
        let currentTime = Date()
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let startTime = format.date(from: String(uploadedTime))!
        //let startStr = format.string(from: startTime!)
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
extension ReplyTableViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if let mentionTextView = textView as? MentionTextView,
           let text = Int(url.debugDescription) {
            print(mentionTextView.idArray[text])
            return false
        }
        return false
    }
}
