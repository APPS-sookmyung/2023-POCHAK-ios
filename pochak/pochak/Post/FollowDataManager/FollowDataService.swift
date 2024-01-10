//
//  FollowDataService.swift
//  pochak
//
//  Created by Suyeon Hwang on 1/3/24.
//

import Alamofire

struct FollowDataService {
    static let shared = FollowDataService()
    
    // handle: 팔로우 혹은 팔로우 취소하고자 하는 유저 아이디
    func postFollow(_ handle: String, completion: @escaping (NetworkResult<Any>) -> Void){
        
        // dxxynni 토큰
        let header : HTTPHeaders = ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkeHh5bm5pIiwicm9sZSI6IlJPTEVfVVNFUiIsImlhdCI6MTcwMzY5MDExNywiZXhwIjoxNzgxNDUwMTE3fQ.2kaatfaOOZeor-RrK09ZCBaxizKI8KGs14Pt-j_uuoU",
                                            "Content-type": "application/json"
                                    ]
        
        let dataRequest = AF.request(APIConstants.baseURL+"/api/v1/user/profile/"+handle,
                                    method: .post,
                                    encoding: URLEncoding.default,
                                    headers: header)
        
        dataRequest.responseData { dataResponse in
            // dataResponse.result는 통신 성공/실패 여부
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    // 요청 후 받은 statusCode를 바탕으로 어떻게 결과값을 처리할 지 정의
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode{
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
            let decodedData = try decoder.decode(FollowDataResponse.self, from: data)
            return .success(decodedData)
        } catch {
            print("Decoding error:", error)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received JSON: \(jsonString)")
            } else {
                print("Invalid JSON data received")
            }
            return .pathErr
        }
    }
}