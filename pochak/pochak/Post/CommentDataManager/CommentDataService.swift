//
//  CommentDataService.swift
//  pochak
//
//  Created by Suyeon Hwang on 12/26/23.
//

import Alamofire

struct CommentDataService {
    static let shared = CommentDataService()
    
    // 댓글 등록 시 서버에 전달할 Body 만드는 함수
    private func makeBodyParameter(content : String, parentCommentSK : String?) -> Parameters {
        if(parentCommentSK != nil){
            return ["content": content, "parentCommentSK": parentCommentSK!]
        }
        else{
            return ["content" : content]
        }
    }
    
    func getComments(_ postId: String, completion: @escaping (NetworkResult<Any>) -> Void){
        /* 헤더 있는 자리 */
        
        
        let dataRequest = AF.request(APIConstants.baseURL+"/api/v1/post/"+postId+"/comment",
                                    method: .get,
                                    encoding: URLEncoding.default,
                                    headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result{
            case .success:
                // 성공 시 통신 자체의 상태코드와 데이터(value) 수신
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value, dataType: "CommentData")  // 통신의 결과(성공이면 데이터, 아니면 에러내용)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    // 대댓글 조회
    func getChildComments(_ postId: String, _ commentId: String, completion: @escaping (NetworkResult<Any>) -> Void){
        /* 헤더 있는 자리 */
        
        let dataRequest = AF.request(APIConstants.baseURL+"/api/v1/post/"+postId+"/"+commentId+"/comment",
                                    method: .get,
                                    encoding: URLEncoding.default,
                                    headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result{
            case .success:
                // 성공 시 통신 자체의 상태코드와 데이터(value) 수신
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value, dataType: "ChildCommentData")  // 통신의 결과(성공이면 데이터, 아니면 에러내용)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    // 댓글 등록
    func postComment(_ postId: String, _ content: String, _ parentCommentSK: String?, completion: @escaping (NetworkResult<Any>) -> Void){
        /* 헤더 있는 자리 */
        
        let dataRequest = AF.request(APIConstants.baseURL+"/api/v1/post/"+postId+"/comment",
                                    method: .post,
                                    parameters: makeBodyParameter(content: content, parentCommentSK: parentCommentSK),
                                    encoding: JSONEncoding.default,
                                    headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result{
            case .success:
                // 성공 시 통신 자체의 상태코드와 데이터(value) 수신
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value, dataType: "PostCommentResponse")  // 통신의 결과(성공이면 데이터, 아니면 에러내용)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    // 요청 후 받은 statusCode를 바탕으로 어떻게 결과값을 처리할 지 정의
    private func judgeStatus(by statusCode: Int, _ data: Data, dataType: String) -> NetworkResult<Any> {
        
        switch statusCode {
        case 200: return isValidData(data: data, dataType: dataType)  // 성공 -> 데이터 가공해서 전달해야하므로 isValidData라는 함수로 데이터 넘겨주기
        case 400: return .pathErr  // 잘못된 요청
        case 500: return .serverErr  // 서버 에러
        default: return .networkFail  // 네트워크 에러
        }
    }
    
    // 통신 성공 시 데이터를 가공하기 위한 함수
    private func isValidData(data: Data, dataType: String) -> NetworkResult<Any> {
        do {
            let decoder = JSONDecoder()
            if(dataType == "CommentData"){  // 댓글 조회
                let decodedData = try decoder.decode(CommentDataResponse.self, from: data)  // 디코딩
                return .success(decodedData)
            }
            else if(dataType == "ChildCommentData"){  // 대댓글 조회
                let decodedData = try decoder.decode(ChildCommentDataResponse.self, from: data)
                return .success(decodedData)
            }
            else{  // 댓글 혹은 대댓글 등록
                let decodedData = try decoder.decode(PostCommentResponse.self, from: data)
                return .success(decodedData)
            }
        } catch {
            print("Decoding error, comment data:", error)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received JSON: \(jsonString)")
            } else {
                print("Invalid JSON data received")
            }
            return .pathErr
        }
    }
}
