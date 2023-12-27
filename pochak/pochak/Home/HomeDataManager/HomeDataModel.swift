//
//  HomeDataModel.swift
//  pochak
//
//  Created by Suyeon Hwang on 12/27/23.
//

struct HomeDataResponse: Codable {
    let statusCode: Int?
    let body: [HomeDataBody]?
}

struct HomeDataBody: Codable {
    let imgUrl: String?  // 이미지 s3 url
    let partitionKey: String?  // 포스트 아이디
}
