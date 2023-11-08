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
    
}

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
