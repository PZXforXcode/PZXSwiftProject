//
//  NetworkingManager.swift
//  PZXSwiftProject
//
//  Created by 彭祖鑫 on 2021/5/27.
//

import Foundation
import Alamofire

typealias NetSuccessClosure<T: Codable> = (_ baseModel: NetBaseModel<T>?) -> Void
typealias NetFailedClosure = (_ error: NetworkingError) -> Void
typealias NetRequestClosure = (_ success: Bool, _ message: String ) -> Void

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

        AF.request(apiModel.gettingFullUrl(), method: apiModel.requestConfig!.method, parameters: apiModel.paramDic, headers: header).response { (response) in

            switch response.result {
            case .success(_):
                let json = response.data ?? Data()
                let decoder = JSONDecoder()
                let jsonString = String(data: response.data ?? Data(), encoding: .utf8) ?? ""

                // 使用 try? 处理错误
                if let model = try? decoder.decode(NetBaseModel<T>.self, from: json) {
                    
                    print("model?.code = \(String(describing: model.code))")
                    print("model?.success = \(String(describing: model.success))")
                    print("model?.msg = \(String(describing: model.msg))")
                    print("model?.data = \(String(describing: model.data))")
                    
                    success(model)
                } else {
                    //解析错误
                    failure(NetworkingError.init(code: ErrorCode.Analysis.rawValue, localizedDescription: Analysis_Error))
                }
            case let .failure(error):
                if error.isResponseSerializationError {
                    let json = response.data ?? Data()
                    let decoder = JSONDecoder()

                    // 使用 try? 处理错误
                    if let model = try? decoder.decode(NetBaseModel<T>.self, from: json) {
                        if model.code == "0" {//token失效
                            NetworkingManager.TokenExpire()
                        } else {
                            //解析错误
                            failure(NetworkingError.init(code: IntSafe(model.code), localizedDescription: model.msg ?? "" ))
                        }
                    } else {
                        var desError = NetworkingError.init(code: error.responseCode ?? ErrorCode.Analysis.rawValue, localizedDescription: error.localizedDescription)
                        _ = desError.desc()
                        failure(desError)
                    }
                } else {
                    if let responseCode = error.responseCode {
                        failure(NetworkingError.init(code: responseCode, localizedDescription: NET_Connect_Error))
                    } else {
                        failure(NetworkingError.init(code: ErrorCode.Unkonwn.rawValue, localizedDescription: Unknown_Error))
                    }
                }
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
