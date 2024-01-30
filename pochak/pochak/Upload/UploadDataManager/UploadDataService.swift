//
//  UploadDataService.swift
//  pochak
//
//  Created by 장나리 on 11/23/23.
//

import Alamofire

class UploadDataService{
    static let shared = UploadDataService()

    func upload(postImage:Data?, request : UploadDataRequest, completion: @escaping(NetworkResult<Any>) -> Void){
        print("==upload==")
        let header : HTTPHeaders = ["Authorization": GetToken().getAccessToken(), "Content-type": "multipart/form-data"]
        // Create an Alamofire upload request
        AF.upload(
            multipartFormData: { multipartFormData in
                // Append image data as multipart form data
                if let imageData = postImage {
                    multipartFormData.append(imageData, withName: "postImage", fileName: "image.jpg", mimeType: "image/jpeg")
                }

                // Convert request object to JSON data and append it as a part with name "request"
                do {
                    let requestData = try JSONEncoder().encode(request)
                    multipartFormData.append(requestData, withName: "request")
                } catch {
                    print("Error encoding UploadDataRequest: \(error)")
                    completion(.networkFail)
                }
            },
            to: APIConstants.baseURLv2 + "/api/v2/posts",
            method: .post,
            headers: header
        )
        .responseJSON { response in
            // Handle the response
            switch response.result {
            case .success(let value):
                print(value)
                if let dict = value as? [String: Any], let code = dict["code"] as? String {
                    switch code {
                    case "POST2001":
                        completion(.success(dict))
                    default:
                        print("Unknown code: \(code)")
                        completion(.networkFail)
                    }
                }
            case .failure(let error):
                print("Failure Error: \(error.localizedDescription)")
                if let statusCode = response.response?.statusCode {
                    print("Failure Status Code: \(statusCode)")
                }
                if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                    print("Failure Data: \(errorMessage)")
                }
                completion(.networkFail)
            }
        }
    }
}
