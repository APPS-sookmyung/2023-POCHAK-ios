//
//  CommentTableViewFooterView.swift
//  pochak
//
//  Created by Suyeon Hwang on 1/13/24.
//

import UIKit

class CommentTableViewFooterView: UITableViewHeaderFooterView {
    //var tableView: UITableView!
    //var data: [CommentData]!
    var commentVC: CommentViewController!
    var postId: String!
    var curCommentId: String!
    
    private var childCommentDataResponse: ChildCommentDataResponse?
    private var childCommentDataList: [ChildCommentData]?
    private var tempChildCommentList = [UICommentData]()
    
    @IBOutlet weak var seeChildCommentsBtn: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func seeChildCommentsBtnDidTap(_ sender: UIButton) {
        print("---대댓글 보기 버튼 눌림---")
        // 이 액션 함수를 호출한 버튼이 테이블 뷰의 어디에 위치했는지 알아내기
        let point = sender.convert(CGPoint.zero, to: commentVC.tableView) // sender의 좌표계 상의 점을 테이블뷰의 bounds로 변환한 것
        
        // point를 가지고 테이블뷰의 indexPath를 찾기, 찾지 못하면 바로 리턴
        guard let indexPath = commentVC.tableView.indexPathForRow(at: point) else { return } // 매개변수로 받은 point와 연관된 행 및 섹션을 나타내는 indexPath를 반환,point가 테이블뷰의 bounds의 범위에서 벗어난다면 nil
        
        // indexPath를 이용해 data[indexPath.row]를 삭제
        commentVC.commentDataList?[indexPath.section].recentComment = nil
        
        //commentVC.tableView.
        //tableView.footerView(forSection: indexPath.section) = nil
        //tableView.deleteRows(at: [indexPath], with: .automatic) //4
        
        loadChildCommentData(indexPath.section)
        
//        commentVC.tableView.reloadData()
        print("---대댓글 보기 버튼 삭제---")
    }
    
    // indexPath는 대댓글을 조회하고자 하는 댓글의 섹션 번호
    private func loadChildCommentData(_ section: Int){
        print("=== load child comment data ===")
        //var index = 0;  // 바꿔야 하

        CommentDataService.shared.getChildComments(self.postId, curCommentId.replacingOccurrences(of: "#", with: "%23")){ response in
            switch(response) {
            case .success(let childCommentDataResponse):
                self.childCommentDataResponse = childCommentDataResponse as? ChildCommentDataResponse
                self.childCommentDataList = self.childCommentDataResponse?.result
                //print("자식 댓글: ")
                //print(self.childCommentDataList)

                self.tempChildCommentList.removeAll()
    
                for data in self.childCommentDataList!{
                    //print("child comment data:")
                    //print(data)
                    self.tempChildCommentList.append(UICommentData(userProfileImg: data.userProfileImg!, userHandle: data.userHandle!, commentId: data.commentId!, uploadedTime: data.uploadedTime!, content: data.content!, isParent: false, hasChild: false, childCommentCnt: 0))
                }
                self.commentVC.childCommentCntList[section] = self.tempChildCommentList.count
                // 제대로 된 자리에 대댓글 리스트를 삽입하기 위해서 지금까지 있는 대댓글 개수 세야 함
                var childCommentsSoFar = 0
                if(section != 0){
                    for index in 0...section - 1 {
                        childCommentsSoFar += self.commentVC.childCommentCntList[index]
                    }
                }
                //self.commentVC.uiCommentList[section].childCommentCnt = self.tempChildCommentList.count
                self.commentVC.uiCommentList.insert(contentsOf: self.tempChildCommentList, at: section + childCommentsSoFar + 1)
                self.commentVC.tableView.reloadData()
                print("==uicommentlist==")
                print(self.commentVC.uiCommentList)
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
    
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//        //configureContents()
//    }
//        
//    required init?(coder: NSCoder) {
//        //fatalError("init(coder:) has not been implemented")
//        super.init(coder: coder)
//    }
}
