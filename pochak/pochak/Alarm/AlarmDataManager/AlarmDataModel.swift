//
//  AlarmDataModel.swift
//  pochak
//
//  Created by 장나리 on 12/27/23.
//

import Foundation

struct AlarmResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: AlarmResult
}

struct AlarmResult: Codable {
    let alarmList: [Alarm]
}

struct Alarm: Codable {
    let createdDate: String
    let lastModifiedDate: String
    let status: String
    let userHandle: String
    let sentDate: String
    let alarmType: String
    let userSentAlarmHandle: String
    let userSentAlarmProfileImage: String
    let validSentDate: String
}
