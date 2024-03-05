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
    
    func getIdSearch(keyword:String,completion: @escaping(NetworkResult<Any>) -> Void){
        let parameters: [String: Any] = ["keyword": keyword]
        print("==getIdSearch==")
        print(parameters)
        let dataRequest = AF.request("https://w2oa1nd4wb.execute-api.ap-northeast-2.amazonaws.com/default/elasticsearch_searchengine?keyword=\(keyword)",
                                     method: .get,
                                     encoding: URLEncoding.queryString).validate()
        
        dataRequest.responseJSON { response in
            switch response.result {
            case .success(let value): // 데이터 통신이 성공한 경우
                print(value)
                guard let jsonArray = value as? [[String: Any]] else {
                    completion(.networkFail)
                    return
                }
                var searchData = [idSearchResponse]()
                                
                for dict in jsonArray {
                    if let profileUrl = dict["profileimg_url"] as? String,
                       let userHandle = dict["userHandle"] as? String,
                       let id = dict["id"] as? String {

                        let searchDataItem = idSearchResponse(profileUrl: profileUrl, id: id, userHandle: userHandle)
                        searchData.append(searchDataItem)
                    }
                }
                print(searchData)
                
                completion(.success(searchData))
                
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    print("Failure Status Code: \(statusCode)")
                }
                print("Failure Error: \(error.localizedDescription)")
                
                if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                    print("Failure Data: \(errorMessage)")
                }
                completion(.networkFail)
            }
        }
    }
}
