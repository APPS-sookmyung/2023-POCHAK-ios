//
//  UploadModel.swift
//  pochak
//
//  Created by 장나리 on 2023/10/04.
//

import Foundation

struct UploadResponse: Codable{
    let isSuccess : Bool
    let code : Int
    let message : String
    let result: UploadData
}
struct UploadData: Codable{
    let postPK : String
    let postImageUrl : String
}
