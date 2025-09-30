//
//  PZXSwiftProject
//  MainTabBarControllerViewController.swift
//  Created by pzx on 2021/7/6
//
//  ***
//  *   GitHub:https://github.com/PZXforXcode
//  *   简书:https://www.jianshu.com/u/e2909d073047
//  *   qq:496912046
//  ***
        

import UIKit

class MainTabBarControllerViewController: UITabBarController,UITabBarControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
    
    //MARK: ==============UITabBarControllerDelegate==============
    /**
     * TabBar 选择控制器时的委托方法
     * 用于处理特定页面的权限验证（如需要登录的页面）
     */
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // 检查是否是需要登录的 CarViewController
        if viewController.isKind(of: CarViewController.classForCoder()) && (UserModelTool.isLogin() == false) {
            
            UtilTool.showAlertView("提示", setMsg: "当前没有登陆账号，是否去登陆", leftButtonTitle: "去登录", leftStyle:UIAlertAction.Style.default, rightButtonTitle: "不了", rightStyle: .default, vc: self) {
                
                GlobalData.loadingLoginViewController {

                }
                
            } rightbuttonBlock: {
                
            }
       
            return false
        }

        return true
    }
    
}



