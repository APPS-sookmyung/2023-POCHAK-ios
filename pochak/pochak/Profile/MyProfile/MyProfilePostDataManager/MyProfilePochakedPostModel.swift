//
//  MyProfilePostModel.swift
//  pochak
//
//  Created by Seo Cindy on 12/28/23.
//

struct MyProfilePochakedPostResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: MyProfilePochakedPostModel
}

struct MyProfilePochakedPostModel : Codable {
    var uploadPosts : [PostDataModel]
}

struct PostDataModel : Codable {
    var postPK : String?
    var postImg : String?
}
