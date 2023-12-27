//
//  MyProfilePostModel.swift
//  pochak
//
//  Created by Seo Cindy on 12/28/23.
//

struct MyProfilePostResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: MyProfilePostModel
}

struct MyProfilePostModel : Codable {
    var uploadPosts : [PostDataModel]
}

struct PostDataModel : Codable {
    var postPK : String?
    var postImg : String?
}
