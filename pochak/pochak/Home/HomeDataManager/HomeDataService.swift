//
//  HomeDataService.swift
//  pochak
//
//  Created by Suyeon Hwang on 12/27/23.
//

import Alamofire

struct HomeDataService {
    static let shared = HomeDataService()
    
    func getHomeData(_ userHandle: String, completion: @escaping (NetworkResult<Any>) -> Void){
        let dataRequest = AF.request("https://uy9prt4dk9.execute-api.ap-northeast-2.amazonaws.com/default/homefunction?myname="+userHandle,
                        method: .get,
                        encoding: JSONEncoding.default)
        
        dataRequest.responseJSON { response in
            switch response.result {
            case .success(let value): // 데이터 통신이 성공한 경우
                guard let jsonArray = value as? [[String: Any]] else {
                    completion(.networkFail)
                    return
                }
                // imgUrl과 partitionKey를 사용하여 ImageAndId 모델로 변환하여 저장
                var imageAndIdArray = jsonArray.compactMap { dict -> HomeDataBody? in
                    guard let imgUrl = dict["imgUrl"] as? String,
                          let partitionKey = dict["partitionKey"] as? String else {
                        return nil
                    }
                    
                    return HomeDataBody(imgUrl: imgUrl, partitionKey: partitionKey)
                }
                completion(.success(imageAndIdArray))
            case .failure(let error): // 데이터 통신이 실패한 경우
                if let statusCode = response.response?.statusCode {
                    print("Failure Status Code: \(statusCode)")
                    completion(.networkFail)
                }
                print("Failure Error: \(error.localizedDescription)")
                
                if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                    print("Failure Data: \(errorMessage)")
                    completion(.networkFail)
                }
            }
        }
    }
    
    // 요청 후 받은 statusCode를 바탕으로 어떻게 결과값을 처리할 지 정의
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        switch statusCode {
        case 200: return isValidData(data: data)  // 성공 -> 데이터 가공해서 전달해야하므로 isValidData라는 함수로 데이터 넘겨주기
        case 400: return .pathErr  // 잘못된 요청
        case 500: return .serverErr  // 서버 에러
        default: return .networkFail  // 네트워크 에러
        }
    }
    
    // 통신 성공 시 데이터를 가공하기 위한 함수
    private func isValidData(data: Data) -> NetworkResult<Any> {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(HomeDataResponse.self, from: data)  // 디코딩
            return .success(decodedData)
        } catch {
            print("Decoding error, home data:", error)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received JSON: \(jsonString)")
            } else {
                print("Invalid JSON data received")
            }
            return .pathErr
        }
    }
}
