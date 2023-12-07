//
//  PZXSwiftProject
//  ServerViewController.swift
//  Created by pzx on 2021/7/6
//  
//  ***
//  *   GitHub:https://github.com/PZXforXcode
//  *   简书:https://www.jianshu.com/u/e2909d073047
//  *   qq:496912046
//  ***
        

import UIKit
import SwiftyJSON
import Kingfisher

// 假设你有一个数据模型叫做 YourDataModel


class ServerViewController: RootViewController {

    @IBOutlet weak var testTableView: UITableView!
    @IBOutlet weak var topEdge: NSLayoutConstraint!
//    var pCNBAMatch : PCNBAMatch?

    var dataSource:JSON = []
    
    var listModel : PCListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RandomColor();

        self.topEdge.constant = NAVIGATION_HEIGHT
        // Do any additional setup after loading the view.


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()

    }
    func getData() {
        
        let chargeCode = "11"//充电桩code
        let outdoorPowerCode = "21"//户外电源code
        //app支持的协议Code
        let protocolCodeArray = [
            chargeCode,//充电桩
            outdoorPowerCode//户外电源
        ]
        
        var apiModel = APIModel(requestConfig: getProductListAPI,paramDic: [
            "protocolCode":protocolCodeArray
        ])
        NetworkingManager.requestFunc(apiModel: &apiModel) { [self] (model: NetBaseModel<PCListModel>?) in
            
            listModel = model?.data
            testTableView.reloadData()
            
        } failure: { error in
            
        }

        
    }
    

}

extension ServerViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        return self.dataSource["matchs"].array?.count ?? 0
        return  IntSafe(listModel?.list?.count)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServerTableViewCell") as! ServerTableViewCell
//        cell.rightLabel.text = StringSafe(dataSource["matchs"][indexPath.row]["date"].string)
        cell.rightLabel.text = StringSafe(listModel?.list?[indexPath.row].names?.zh)
        let url = URL.init(string:"https://img1.baidu.com/it/u=1852955231,3943566939&fm=26&fmt=auto&gp=0.jpg")
        cell.leftImageView.kf.setImage(with: url,placeholder: nil)
        cell.leftImageView.contentMode = .scaleAspectFit
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
}
