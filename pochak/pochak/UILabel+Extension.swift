//
//  UITextView+Extension.swift
//  pochak
//
//  Created by Suyeon Hwang on 2023/07/23.
//

import UIKit

// 멘션된 아이디를 clickable하게 바꿔주는 텍스트 뷰
// 한글, 영문, 숫자만 가능
extension UILabel {

    func findOutMentionedId() {
        var idArray: [String] = []
//        self.isEditable = false
//        self.isSelectable = true
//        self.isScrollEnabled = false

        // mentionTextView의 텍스트에 기본으로 적용되는 설정 값
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            //.font: UIFont.systemFont(ofSize: 12.0, weight: .regular),
            .font: UIFont(name: "Pretendard-Medium", size: 12.0) as Any
          ]
        
        if let text = self.text {
            let nsText: NSString = text as NSString
            //let nsText: NSString = self.text as! NSString
            let attrString = NSMutableAttributedString(string: nsText as String, attributes: attributes)
            let mentionDetector = try? NSRegularExpression(pattern: "@(\\w+)", options: NSRegularExpression.Options.caseInsensitive)
            let results = mentionDetector?.matches(in: text,
                                                   options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds,
                                                   range: NSMakeRange(0, text.utf16.count))
            
            guard let results = results else { return }
            idArray = results.map{ nsText.substring(with: $0.range(at: 1)) }
            
            if !idArray.isEmpty {
                var i = 0
                for var word in idArray {
                    word = "@" + word
                    if word.hasPrefix("@") {
                        let matchRange:NSRange = nsText.range(of: word as String, options: [.caseInsensitive, .backwards])
                        
                        // @로 시작하는 텍스트인 경우의 속성
                        let linkAttributes: [NSAttributedString.Key: Any] = [
                            .foregroundColor: UIColor(named: "Primary") ?? .black,
                            .font: UIFont(name: "Pretendard-Medium", size: 12.0) as Any,
                            .link: "\(i)",
                        ]
                        attrString.setAttributes(linkAttributes, range: matchRange)
                        i += 1
                    }
                }
            }
            
            self.attributedText = attrString
            print(idArray)
        }
    }
}
