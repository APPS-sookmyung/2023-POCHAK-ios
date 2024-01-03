//
//  FollowDataModel.swift
//  pochak
//
//  Created by Suyeon Hwang on 1/3/24.
//

struct FollowDataResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: String
}
