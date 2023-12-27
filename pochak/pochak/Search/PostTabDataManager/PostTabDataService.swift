//
//  PostTabDataManager.swift
//  pochak
//
//  Created by 장나리 on 12/24/23.
//

import Foundation
import Alamofire

class PostTabDataService{
    static let shared = PostTabDataService()

    func recommandGet(completion: @escaping(NetworkResult<Any>) -> Void){
        
        let dataRequest = AF.request("https://kl87eul1ua.execute-api.ap-northeast-2.amazonaws.com/default/post_recommend_lambda",
                                    method: .get,
                                    encoding: URLEncoding.default)
        
        
        dataRequest.responseJSON { response in
            switch response.result {
            case .success(let value): // 데이터 통신이 성공한 경우
                guard let jsonArray = value as? [[String: Any]] else {
                    completion(.networkFail)
                    return
                }
                // imgUrl과 partitionKey를 사용하여 ImageAndId 모델로 변환하여 저장
                var imageAndIdArray = jsonArray.compactMap { dict -> PostTabDataModel? in
                    guard let imgUrl = dict["imgUrl"] as? String,
                          let partitionKey = dict["partitionKey"] as? String else {
                        return nil
                    }
                    
                    return PostTabDataModel(imgUrl: imgUrl, postId: partitionKey)
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
}
