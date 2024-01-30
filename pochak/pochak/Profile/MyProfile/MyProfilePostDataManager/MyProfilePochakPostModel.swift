//
//  MyProfilePochakPostModel.swift
//  pochak
//
//  Created by Seo Cindy on 12/28/23.
//

struct MyProfileUserAndPochakedPostResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: MyProfileUserAndPochakedPostModel
}

struct MyProfileUserAndPochakedPostModel : Codable {
    var handle: String?
    var userProfileImg: String?
    var userName: String?
    var message: String?
    var totalPostNum: Int?
    var followerCount: Int?
    var followingCount: Int?
    var isFollow: Bool?
    var taggedPosts : [PostDataModel]
}
