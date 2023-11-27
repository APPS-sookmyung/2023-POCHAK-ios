//
//  LikedUsersDataResponse.swift
//  pochak
//
//  Created by Suyeon Hwang on 11/10/23.
//

struct LikedUsersDataResponse {
    let isSuccess: Bool?
    let code: Int?
    let message: String?
    let result: LikedUserDataResult
}

struct LikedUserDataResult {
    let likedUsers: [LikedUsers]
}

struct LikedUsers {
    let userHandle: String?
    let profileImage: String?
    let name: String?
    let follow: Bool?    // 팔로우 여부, 자기 자신일 경우 null 값 반환
}
