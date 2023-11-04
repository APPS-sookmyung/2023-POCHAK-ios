//
//  PostDataResponse.swift
//  pochak
//
//  Created by Suyeon Hwang on 9/14/23.
//

struct PostDataReponse: Decodable {
    let isSuccess: Bool?
    let code: Int?
    let message: String?
    let result: PostDataResponseResult?
}

struct PostDataResponseResult: Decodable {
    let taggedUserHandles: [String]?
    let postOwnerhandle: String?
    let isFollow: Bool?
    let postImageUrl: String?
    let numOfHeart: Int?
    let caption: String?
    let mainComment: String?
}
