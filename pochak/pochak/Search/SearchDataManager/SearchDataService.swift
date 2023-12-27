//
//  TagDataService.swift
//  pochak
//
//  Created by 장나리 on 12/27/23.
//

import Foundation
import Alamofire

class SearchDataService{
    
    static let shared = SearchDataService()
    
    func idSearchGet(keyword:String,completion: @escaping(NetworkResult<Any>) -> Void){
        let parameters: [String: Any] = ["keyword": keyword]

        let dataRequest = AF.request("https://w2oa1nd4wb.execute-api.ap-northeast-2.amazonaws.com/default/elasticsearch_searchengine",
                                     method: .get,
                                     parameters: parameters,
                                     encoding: JSONEncoding.default).validate()
        
        
        dataRequest.responseJSON { response in
            switch response.result {
            case .success(let value): // 데이터 통신이 성공한 경우
                print(response.result)
                print(response.data)
                print(response.error)
                print(value)
                guard let jsonArray = value as? [[String: Any]] else {
                    completion(.networkFail)
                    return
                }
                do {
                    let userInfo = try jsonArray.map { try JSONDecoder().decode(IdSearchResponse.self, from: JSONSerialization.data(withJSONObject: $0)) }
                    
                    if userInfo.isEmpty {
                        completion(.networkFail)
                    } else {
                        // userInfo 배열에 저장된 데이터에 접근하여 사용할 수 있습니다.
                        for info in userInfo {
                            print("User Handle: \(info.userHandle)")
                            print("Name: \(info.name)")
                            print("Profile Image URL: \(info.profileimgURL)")
                        }
                        completion(.success(userInfo))
                    }
                } catch {
                    print("Parsing Error: \(error.localizedDescription)")
                    completion(.networkFail)
                }
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
}
