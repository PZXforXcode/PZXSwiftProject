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

    
  
    public class func requestFunc<T: Codable>(apiModel: inout APIModel,isCallOut:Bool = false, success: @escaping NetSuccessClosure<T>, failure: @escaping NetFailedClosure) -> Request? {
        
//        ///网络判断
//        guard NetworkingManager().checkNetworkAvailability() else {
//
//            PCToastView.shared.show(title: DEF_LOCALIZED_STRING(key: "common.network"))
//            return
//        }
        var localApiModel = apiModel  // 创建一个局部变量来存储 apiModel

        let header = NetworkingManager.settingDefaultHttpHeaders(apiModel: apiModel)
        print("apiModel.paramDic = \(apiModel.paramDic)")
        
        let request = AF.request(apiModel.gettingFullUrl(), method: apiModel.requestConfig!.method, parameters: apiModel.paramDic, headers: header,requestModifier: {$0.timeoutInterval = timeoutInterval}).response { (response) in
            
            switch response.result {
            case .success(_):
                let json = response.data ?? Data()
                let decoder = JSONDecoder()
                let jsonString = String(data: response.data ?? Data(), encoding: .utf8) ?? ""
                
                let statusCode = response.response?.statusCode ?? 0
                print("statusCode = \(statusCode)")
                // 打印请求的 URL
                if let url = response.request?.url {
                    print("PINGALAX Request URL: \(url)")
                }
                
                
                
                
                do {
                    if let data = jsonString.data(using: .utf8) {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
//                            NSLog("PINGALAX jsonObject = \(jsonObject)")
                            print("PINGALAX jsonObject = \(jsonObject)")

                        }
                    }
                } catch {
                    NSLog("PINGALAX Error converting JSON to NSDictionary: \(error)")
                }
                


                
                if (statusCode == 200 || statusCode == 400) {
                    
                    do {
                        let model = try decoder.decode(NetBaseModel<T>.self, from: json)
                        model.statusCode = statusCode
                        
            
                        
                        
                        // 解析成功，执行成功的回调
                        success(model)
                    } catch let decodingError as DecodingError {
                        // 解析错误，打印错误信息
                        print("DecodingError: \(decodingError.localizedDescription)")
                        
                        switch decodingError {
                        case .typeMismatch(let type, let context):
                            print("Type mismatch for key \(context.codingPath): expected type \(type), found \(context.debugDescription)")
                        case .valueNotFound(let type, let context):
                            print("Value not found for key \(context.codingPath): expected type \(type), \(context.debugDescription)")
                        case .keyNotFound(let key, _):
                            print("Key not found: \(key)")
                        case .dataCorrupted(let context):
                            print("Data corrupted for key \(context.codingPath): \(context.debugDescription)")
                        @unknown default:
                            print("Unknown decoding error")
                        }
                        
                        // 使用默认模型
                        let defaultModel = NetBaseModel<T>.defaultModelOnDecodingError(decodingError)
                        success(defaultModel)
                        
                    } catch let parsingError {
                        // 其他错误类型的处理
                        print("Error decoding JSON: \(parsingError.localizedDescription)")
                        // 创建自定义的错误对象并执行失败的回调
                        failure(NetworkingError(code: ErrorCode.Analysis.rawValue, localizedDescription: "error"))
                    }

                    
                } else {
                    
                    failure(NetworkingError(code: ErrorCode.Analysis.rawValue, localizedDescription: "error"))

                    
                }
                
            case let .failure(error):
                
                //网络错误
                let networkingError = NetworkingError.fromAFError(error)
                failure(networkingError)
            }
        }
        
      return request
        
    }
    
    
    
    
    
    public class func requestDicFunc(apiModel: inout APIModel,isCallOut:Bool = false, success: @escaping NetSuccessDic, failure: @escaping NetFailedClosure) {
        print("apiModel.paramDic = \(apiModel.paramDic)")

        var localApiModel = apiModel  // 创建一个局部变量来存储 apiModel

        let header = NetworkingManager.settingDefaultHttpHeaders(apiModel: apiModel)
        
        AF.request(apiModel.gettingFullUrl(), method: apiModel.requestConfig!.method, parameters: apiModel.paramDic, headers: header,requestModifier: {$0.timeoutInterval = timeoutInterval}).response { (response) in
            
            switch response.result {
            case .success(_):
                let statusCode = response.response?.statusCode ?? 0
//                print("statusCode = \(statusCode)")
                let json = response.data ?? Data()
                let jsonString = String(data: json, encoding: .utf8) ?? ""
                // 打印请求的 URL
                if let url = response.request?.url {
                    print("PINGALAX dic Request URL: \(url)")
                }
                
                if (statusCode == 200 || statusCode == 400) {
                    
                    do {
                        if let data = jsonString.data(using: .utf8) {
                            if var jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                jsonObject["statusCode"] = statusCode
                                
                                let code = StringSafe(jsonObject["code"])
                        

                                
                                
                                success(jsonObject)
                                
                            }
                            
                            //打印字典
                            if let Dic = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
    //                            NSLog("PINGALAX Dic = \(Dic)")
                                print("PINGALAX Dic = \(Dic)")

                            }

                     
                        }
                    } catch {
                        print("Error converting JSON to [String: Any]: \(error)")
                        failure(NetworkingError(code: ErrorCode.Analysis.rawValue, localizedDescription: "error"))
                    }
                    
                    
                } else {
                    
                    failure(NetworkingError(code: ErrorCode.Analysis.rawValue, localizedDescription: "error"))

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
