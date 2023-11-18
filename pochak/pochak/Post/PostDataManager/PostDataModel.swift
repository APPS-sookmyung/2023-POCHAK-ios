//
//  PostDataResponse.swift
//  pochak
//
//  Created by Suyeon Hwang on 11/10/23.
//

struct PostDataResponseResult: Decodable {
    let taggedUserHandles: [String]?
    let postOwnerHandle: String?
    let isFollow: Bool?
    let postImageUrl: String?
    let numOfHeart: Int?
    let caption: String?
    let mainComment: String?
}

struct PostDataReponse: Decodable {
    let isSuccess: Bool?
    let code: Int?
    let message: String?
    let result: PostDataResponseResult?
}
