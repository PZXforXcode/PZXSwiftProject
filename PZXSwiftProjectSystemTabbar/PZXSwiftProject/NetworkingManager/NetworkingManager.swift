//
//  NetworkingManager.swift
//  PZXSwiftProject
//
//  Created by 彭祖鑫 on 2021/5/27.
//

import Foundation
import Alamofire

typealias NetSuccessClosure<T: Codable> = (_ baseModel: NetBaseModel<T>?) -> Void
typealias NetSuccessDic = (_ dic: [String: Any]?) -> Void
typealias NetFailedClosure = (_ error: NetworkingError) -> Void
typealias NetRequestClosure = (_ success: Bool, _ message: String ) -> Void

let timeoutInterval: TimeInterval = 10 // 设置超时时间为10秒


public func convertJSONToModel<T: Codable>(jsonObject: AnyObject, modelType: T.Type) -> T? {
     do {
         let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
         let decodedModel = try JSONDecoder().decode(modelType, from: jsonData)
         return decodedModel
     } catch {
         print("Error converting to JSON: \(error)")
         return nil
     }
 }

class NetworkingManager {

    public class func requestFunc<T: Codable>(apiModel: inout APIModel, success: @escaping NetSuccessClosure<T>, failure: @escaping NetFailedClosure) {

        let header = NetworkingManager.settingDefaultHttpHeaders(apiModel: apiModel)

        AF.request(apiModel.gettingFullUrl(), method: apiModel.requestConfig!.method, parameters: apiModel.paramDic, headers: header,requestModifier: {$0.timeoutInterval = timeoutInterval}).response { (response) in

            switch response.result {
            case .success(_):
                let json = response.data ?? Data()
                let decoder = JSONDecoder()
                let jsonString = String(data: response.data ?? Data(), encoding: .utf8) ?? ""

                // 使用 try? 处理错误
                do {
                    let model = try decoder.decode(NetBaseModel<T>.self, from: json)
                    
                    print("model?.code = \(String(describing: model.code))")
                    print("model?.success = \(String(describing: model.success))")
                    print("model?.msg = \(String(describing: model.msg))")
                    print("model?.data = \(String(describing: model.data))")
                    
                    success(model)
                } catch let parsingError {
                    // 解析错误，打印错误信息
                    print("解析错误日志: \(parsingError)")
                    failure(NetworkingError(code: ErrorCode.Analysis.rawValue, localizedDescription: Analysis_Error))
                }
            case let .failure(error):
                //网络错误
                let networkingError = NetworkingError.fromAFError(error)
                failure(networkingError)
            }
        }
    }
    
    public class func requestDicFunc(apiModel: inout APIModel, success: @escaping NetSuccessDic, failure: @escaping NetFailedClosure) {
        
        let header = NetworkingManager.settingDefaultHttpHeaders(apiModel: apiModel)
        
        AF.request(apiModel.gettingFullUrl(), method: apiModel.requestConfig!.method, parameters: apiModel.paramDic, headers: header,requestModifier: {$0.timeoutInterval = timeoutInterval}).response { (response) in
            
            switch response.result {
            case .success(_):
                let json = response.data ?? Data()
                let jsonString = String(data: response.data ?? Data(), encoding: .utf8) ?? ""
                // 打印请求的 URL
                if let url = response.request?.url {
                    print("Request URL: \(url)")
                }
                do {
                    if let data = jsonString.data(using: .utf8) {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("jsonObject = \(jsonObject)")
                            success(jsonObject)
                        }
                    }
                } catch {
                    print("Error converting JSON to [String: Any]: \(error)")
                    failure(NetworkingError(code: ErrorCode.Analysis.rawValue, localizedDescription:"网络错误"))
                }
            case let .failure(error):
                //网络错误
                let networkingError = NetworkingError.fromAFError(error)
                failure(networkingError)
            }
        }
    }

    
    
    
    ///配置header
    private class func settingDefaultHttpHeaders(apiModel: APIModel) -> HTTPHeaders {
        var headers = HTTPHeaders.default
        
        
        let Language = "zh"
        headers.update(name: "timezone", value: "Asia/Shangha")
        headers.update(name: "Accept-Language", value: Language)
        headers.update(name: "App-Version", value: PZXAppInfo.appVersionRemoveSuffix)
        headers.update(name: "os", value: "iOS")
        headers.update(name: "OS-Version", value: PZXAppInfo.iOSVersion)//第一个版本默认1.0.0
        headers.update(name: "token", value: UserModelTool.CurrentUser()?.accessToken ?? "")
        //        headers.update(name: "token", value:  "1231322133")
        
        return headers
    }
    
    ///token失效需要重新登录
    public class func TokenExpire() {
    
    }
    
    
}


extension NetworkingError {
    static func fromAFError(_ error: AFError) -> NetworkingError {
        
        if case let .sessionTaskFailed(sessionError) = error,
           let urlError = sessionError as? URLError {
            let errorCode = urlError.code.rawValue
            if errorCode == -1001 {
                return NetworkingError(code: error.responseCode ?? 0, localizedDescription: "请求超时")
            } else {
                return NetworkingError(code: error.responseCode ?? 0, localizedDescription: "网路错误")
            }
        }
        return NetworkingError(code: error.responseCode ?? 0, localizedDescription: "网路错误")
    }
}
