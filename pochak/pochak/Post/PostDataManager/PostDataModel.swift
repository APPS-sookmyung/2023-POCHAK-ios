//
//  PostDataResponse.swift
//  pochak
//
//  Created by Suyeon Hwang on 11/10/23.
//

struct PostDataResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: PostResult
}

struct PostResult: Codable {
    let taggedUserHandles: [String]
    let postOwnerHandle: String
    let isFollow: Bool
    let postImageUrl: String
    let numOfHeart: Int
    let caption: String
    let mainComment: MainComment
}

struct MainComment: Codable {
    let userHandle: String
    let content: String
}

