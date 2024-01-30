//
//  MyProfilePochakedPostModel.swift
//  pochak
//
//  Created by Seo Cindy on 12/28/23.
//

struct MyProfilePochakPostResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: MyProfilePochakPostModel
}

struct MyProfilePochakPostModel : Codable {
    var pageInfo : PageDataModel
    var postList : [PostDataModel]
}
