//
//  LikedUsersDataResponse.swift
//  pochak
//
//  Created by Suyeon Hwang on 11/10/23.
//

struct LikedUsersDataResponse: Codable {
    let isSuccess: Bool?
    let code: Int?
    let message: String?
    let result: LikedUserDataResult
}

struct LikedUserDataResult: Codable {
    let likedUsers: [LikedUsers]
}

struct LikedUsers: Codable {
    let userHandle: String?
    let profileImage: String?
    let name: String?
    let follow: Bool?    // 팔로우 여부, 자기 자신일 경우 null 값 반환
}

/* 좋아요 누르기 -> 서버쪽에서 오는 응답 */
struct LikePostDataResponse: Codable {
    let isSuccess: Bool?
    let code: Int?
    let message: String?
}
