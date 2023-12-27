//
//  JoinDataManager.swift
//  pochak
//
//  Created by Seo Cindy on 12/27/23.
//

import Alamofire

struct JoinDataManager {
    
    static let shared = JoinDataManager()
    
    func joinDataManager(_ accessToken : String,
                         _ name : String,
                         _ email : String,
                         _ handle : String,
                         _ message : String,
                         _ socialId : String,
                         _ socialType : String,
                         _ profileImage : UIImage?,
                         _ completion: @escaping (JoinDataModel) -> Void) {
        
        let requestBody : [String : Any] = [
            "name" : name,
            "email" : email,
            "handle" : handle,
            "message" : message,
            "socialId" : socialId
        ]
        print(requestBody)
        
        let url = APIConstants.baseURL + "/api/v1/user/signup"
        
        /*HEADER NEEDED TO BE INCLUDED BEFORE RUNNING*/
        let header : HTTPHeaders = ["Authorization": accessToken, "Content-type": "multipart/form-data"]
        AF.upload(multipartFormData: { multipartFormData in
            //body 추가
            for (key, value) in requestBody {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            //img 추가
            if let image = profileImage?.pngData() {
                multipartFormData.append(image, withName: "profileImage", fileName: "image.png", mimeType: "image/png")
            }
        }, to: url, headers: header).validate().responseDecodable(of: JoinAPIResponse.self) { response in
                print(response)
                switch response.result {
                case .success(let result):
                    let resultData = result.result
                    completion(resultData)
                case .failure(let error):
                    print("실패함")
                    print(error)
            }
        }
    }
}
