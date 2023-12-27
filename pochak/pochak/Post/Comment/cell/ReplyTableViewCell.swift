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
    func setupData(_ commentData: ChildCommentData){
        // 프로필 이미지
        if let profileImgStr = commentData.userProfileImg {
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
        }
        
        // 유저 핸들
        userHandleLabel.text = commentData.userHandle
        
        replyCommentTextView.text = commentData.content
        
        timePassedLabel.text = commentData.uploadedTime
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
