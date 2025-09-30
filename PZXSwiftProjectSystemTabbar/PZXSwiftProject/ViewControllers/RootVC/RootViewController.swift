//
//  RootViewController.swift
//  LXLeadNewsSwift
//
//  Created by quark on 2021/3/2.
//

import UIKit

class RootViewController: UIViewController {
    
    public var titleText: String?

    lazy var navBar: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frameWidth, height: CGFloat(TOP_HEIGHT)))
        view.backgroundColor = .white
        view.addSubview(self.titleLabel)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: STATUS_BAR_HEIGHT + 7, width: HorizontalFlexible(200), height: 30))
        label.centerX = self.view.frameWidth * 0.5
        label.textColor = GRAYCOLOR1
        label.textAlignment = .center
        label.font = PZXSystemFont(16)
        return label
    }()
    
    
    lazy var backItem: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 5, y: 0, width: 17, height: 30))
        button.centerY = self.titleLabel.centerY
        button.setImage(UIImage.init(named: "返回_黑"), for: .normal)
        button.addTarget(self, action: #selector(backItemAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var leftItem: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: self.backItem.frameMaxX + 10, y: 0, width: 80, height: 40))
        button.centerY = self.titleLabel.centerY
        button.addTarget(self, action: #selector(leftItemAction(sender:)), for: .touchUpInside)
        button.setImage(UIImage.init(named: "黑色返回"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    lazy var rightItem: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: self.view.frameWidth - 88, y: 0, width: 80, height: 40))
        button.centerY = self.titleLabel.centerY
        button.addTarget(self, action: #selector(rightItemAction(sender:)), for: .touchUpInside)
        button.imageView?.contentMode = .scaleToFill
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    lazy var navBarLineView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: CGFloat(NAVIGATION_HEIGHT) - 1, width: self.view.frameWidth, height: 1))
        view.backgroundColor = self.navBar.backgroundColor;
        return view
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        根目录手势关闭
        if let navigationController = self.navigationController, navigationController.viewControllers.first === self {
            // 是根控制器，添加边缘侧滑手势
            let edgeSwipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(disableEdgeSwipe(_:)))
            edgeSwipeGesture.edges = .left  // 设置手势的边缘为左侧
            view.addGestureRecognizer(edgeSwipeGesture)
        }
//        根目录手势关闭
//        if (self is HomePageViewController || self is ServerViewController) {
//
//            // 添加边缘侧滑手势
//            let edgeSwipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(disableEdgeSwipe(_:)))
//            edgeSwipeGesture.edges = .left  // 设置手势的边缘为左侧
//            view.addGestureRecognizer(edgeSwipeGesture)
//        }

    }
    
    @objc func disableEdgeSwipe(_ recognizer: UIScreenEdgePanGestureRecognizer) {
    }
    
    
    //MARK:================👌Initialize👌================
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        initializeNavBar()
        //开启右滑返回手势🤚
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }

    //MARK:================👌Method👌================
    private func initializeNavBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.addSubview(self.navBar)

        if (self.navigationController?.viewControllers.count ?? 0) > 1 {
            self.navBar.addSubview(self.backItem)
        }
        self.navBar.addSubview(self.leftItem)
        self.navBar.addSubview(self.rightItem)
        
        self.titleLabel.text = self.titleText
    }
    
    
    //MARK:================👌Action👌================
    @objc public func backItemAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc public func leftItemAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc public func rightItemAction(sender: UIButton) {}
}

extension RootViewController: UIGestureRecognizerDelegate {
    
}

