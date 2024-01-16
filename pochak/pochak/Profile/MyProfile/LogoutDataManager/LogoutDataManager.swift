//
//  LogoutDataManager.swift
//  pochak
//
//  Created by Seo Cindy on 1/14/24.
//
import Alamofire

class LogoutDataManager{
    
    static let shared = LogoutDataManager()
    
    func logoutDataManager(_ accessToken : String, _ completion: @escaping (LogoutDataModel) -> Void) {
        
        let url = APIConstants.baseURL + "/api/v1/user/logout"
        
        let header : HTTPHeaders = ["Authorization": "Bearer " + accessToken, "Content-type": "application/json"]
        print(header[0])
        
//        let header : HTTPHeaders = ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkeHh5bm5pIiwicm9sZSI6IlJPTEVfVVNFUiIsImlhdCI6MTcwMzY5MDExNywiZXhwIjoxNzgxNDUwMTE3fQ.2kaatfaOOZeor-RrK09ZCBaxizKI8KGs14Pt-j_uuoU", "Content-type": "application/json"]
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header)
        .validate()
        .responseDecodable(of: LogoutDataResponse.self) { response in
            switch response.result {
            case .success(let result):
                let resultData = result.result
                completion(resultData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
