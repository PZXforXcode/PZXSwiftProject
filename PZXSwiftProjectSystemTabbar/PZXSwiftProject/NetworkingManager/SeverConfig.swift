//
//  SeverConfig.swift
//  PZXSwiftProject
//
//  Created by 彭祖鑫 on 2021/5/27.
//

import Foundation

let TEST = 0 //1为测试服 0为正式服
//MARK:================域名================
var baseSeverUrlString: String {
    
//    - 1.0.0_Dev : 开发在进行开发期间所使用的后缀，包括冒烟。
//    - 1.0.0_Test ：提测后打的包名、用于测试环境的包。
//    - 1.0.0_Pre ：用于测试完成后产品UI验收时使用的包后缀。
//    - 1.0.0：用于正式环境的包。
    get {
        
        if (PZXAppInfo.appVersion.contains("_Test")) {//测试环境
            return "http://api-test.pingalax.com/core"
        } else if (PZXAppInfo.appVersion.contains("_Dev")) { //开发环境
            return "http://api-dev.pingalax.com/core"
        } else if (PZXAppInfo.appVersion.contains("_Pre")) { //预发布环境
            return "http://api-pre.pingalax.com/core"
        } else { //默认正式环境
            return "https://api.pingalax.com/core"
        }
    }
}

//MARK:================接口地址================
let HelloAPI        = NetConfig(name: "hello接口",
                                          path: "/v1/api/hello",
                                          method: .get)
///获取产品列表
let getProductListAPI       = NetConfig(name: "获取产品列表",
                                          path: "/app/open/common/getProductList",
                                          method: .post)

