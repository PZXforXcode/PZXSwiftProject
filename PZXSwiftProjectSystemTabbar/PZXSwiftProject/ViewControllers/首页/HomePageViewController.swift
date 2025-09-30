//
//  PZXSwiftProject
//  HomePageViewController.swift
//  Created by pzx on 2021/7/6
//  
//  ***
//  *   GitHub:https://github.com/PZXforXcode
//  *   简书:https://www.jianshu.com/u/e2909d073047
//  *   qq:496912046
//  ***
        

import UIKit

class HomePageViewController: RootViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RandomColor();
        // Do any additional setup after loading the view.
        UtilTool.showAlertView("提示", setMsg: "进入app了")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("昵称：\(UserModelTool.CurrentUser()?.nickName ?? "暂无"),token：\(UserModelTool.CurrentUser()?.Token ?? "暂无"),头像：\(UserModelTool.CurrentUser()?.avatarUrl ?? "暂无")")
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let vc = MineViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
