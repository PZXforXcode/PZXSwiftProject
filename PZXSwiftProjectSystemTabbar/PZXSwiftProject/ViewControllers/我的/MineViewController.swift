//
//  PZXSwiftProject
//  MineViewController.swift
//  Created by pzx on 2021/7/6
//  
//  ***
//  *   GitHub:https://github.com/PZXforXcode
//  *   简书:https://www.jianshu.com/u/e2909d073047
//  *   qq:496912046
//  ***
        

import UIKit

class MineViewController: RootViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RandomColor();

    

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserModelTool.isLogin() {
            
            UtilTool.showAlertView("提示", setMsg: "是否退出登录", leftButtonTitle: "退出", leftStyle:UIAlertAction.Style.default, rightButtonTitle: "不了", rightStyle: .default, vc: self) {
                
                UserModelTool.ClearAllUserInfo()
                GlobalData.loadingLoginViewController {
                    
                }
                
            } rightbuttonBlock: {
                
            }
            
        }else{
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
