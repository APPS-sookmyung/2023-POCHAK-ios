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
    
    var taggedId: String = ""
    
    // MARK: - Action
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
}

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
