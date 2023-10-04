//
//  NetworkResult.swift
//  pochak
//
//  Created by 장나리 on 2023/09/03.
//
enum NetworkResult<T>{
    case success(T) // 서버 통신 성공
    case requestErr(T) // 요청 에러 발생
    case pathErr // 경로 에러
    case serverErr // 서버의 내부 에러
    case networkFail // 네트워크 연결실패
}
