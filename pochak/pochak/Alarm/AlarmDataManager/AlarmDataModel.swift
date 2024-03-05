struct AlarmResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: AlarmResult
}

struct AlarmResult: Codable {
    let pageInfo: PageInfo
    let alarmElementList: [TagApprovalElement]
}

struct PageInfo: Codable {
    let lastPage: Bool
    let totalPages: Int
    let totalElements: Int
    let size: Int
}

enum AlarmType: String, Codable {
    case tagApproval = "TAG_APPROVAL"
    case ownerComment = "OWNER_COMMENT"
    case taggedComment = "TAGGED_COMMENT"
    case commentReply = "COMMENT_REPLY"
    case follow = "FOLLOW"
    case like = "LIKE"
}

struct TagApprovalElement: Codable {
    let alarmId: Int
    let alarmType: AlarmType
    let isChecked: Bool
    let ownerHandle: String?
    let ownerName: String?
    let ownerProfileImage: String?
    let postId: Int?
    let postImage: String?
}
