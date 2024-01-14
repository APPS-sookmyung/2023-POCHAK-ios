//
//  CommentDataModel.swift
//  pochak
//
//  Created by Suyeon Hwang on 12/26/23.
//

// MARK: - 댓글 조회 Data Model
struct CommentDataResponse: Codable {
    let isSuccess: Bool?
    let code: Int?
    let message: String?
    let result: CommentDataResult?
}

struct CommentDataResult: Codable {
    let loginProfileImg: String?
    let comments: [CommentData]
}

struct CommentData: Codable {
    let userProfileImg: String?  // 댓글을 작성한 유저의 프로필 이미지
    let userHandle: String?  // 댓글을 작성한 유저의 핸들
    let commentSK: String?  // 댓글 Sort Key, 추후 댓글 업로드, 대댓글 조회 시에 사용하면 됩니닷
    let uploadedTime: String?  //LocalDateTime?  // 댓글 작성 시간
    let content: String?  // 내용
    var recentComment: RecentComment?  // 제일 최신의 대댓글 (답댓글이 없을 경우 null)
}

struct RecentComment: Codable {
    let childCommentProfileImg: String?
    let content: String?
}

// MARK: - 대댓글 조회 Data Model
struct ChildCommentDataResponse: Codable {
    let isSuccess: Bool?
    let code: Int?
    let message: String?
    let result: [ChildCommentData]?
}

struct ChildCommentData: Codable {
    let userProfileImg: String?
    let userHandle: String?
    let commentId: String?  // 댓글 ID (추후 삭제.. 등등에 쓰시면 됨다)
    let uploadedTime: String?
    let content: String?
}

// MARK: - 댓글 등록 Data Model (Response만 존재)
struct PostCommentResponse: Codable {
    let isSuccess: Bool?
    let code: Int?
    let message: String?
}

// MARK: - UI에 보여주기 위해 쓸 데이터 모델
struct UICommentData {
    let userProfileImg: String  // 댓글을 작성한 유저의 프로필 이미지
    let userHandle: String  // 댓글을 작성한 유저의 핸들
    let commentId: String  // 댓글 아이디
    let uploadedTime: String  //LocalDateTime?  // 댓글 작성 시간
    let content: String  // 내용
    let isParent: Bool
    let hasChild: Bool  // 자식 댓글이 있는지
    var childCommentCnt: Int  // 자식 댓글 개수, 부모나 자식이나 모두 디폴트 1로
}
