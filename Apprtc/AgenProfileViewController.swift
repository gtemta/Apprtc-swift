//
//  AgenProfileViewController.swift
//  Apprtc
//
//  Created by IMF on 2016/9/28.
//  Copyright © 2016年 Dhilip. All rights reserved.
//


import UIKit

class AgentProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var info = [
        ["Name","Gender","Level","Language","Education"]
    ]
    var profile : [String] = []
    var myTableView: UITableView!
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        cell.textLabel?.text = profile[indexPath.row]
        
        
        
        // 設置 Accessory 按鈕樣式
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
                cell.accessoryType = .DisclosureIndicator
            } else if (indexPath as NSIndexPath).row == 1 {
                cell.accessoryType = .DisclosureIndicator
            } else if (indexPath as NSIndexPath).row == 2 {
                cell.accessoryType = .DisclosureIndicator
            } else if (indexPath as NSIndexPath).row == 3 {
                cell.accessoryType = .DisclosureIndicator
            } else if (indexPath as NSIndexPath).row == 4 {
                cell.accessoryType = .DisclosureIndicator
            }
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logout_Button = UIBarButtonItem(barButtonSystemItem: .Reply,target: self,action: #selector(UserProfileViewController.logout))
        self.navigationItem.rightBarButtonItem = logout_Button
        
        
        let fullScreenSize = UIScreen.mainScreen().bounds.size
        self.view.backgroundColor = UIColor.whiteColor()
        let myprofileimg = UIImageView(
            frame: CGRect(
                x:0, y:0, width: 200, height: 180))
        
        myprofileimg.image = UIImage(named: "icons/profile.png")
        
        myprofileimg.center = CGPoint(x: fullScreenSize.width*0.5, y: fullScreenSize.height*0.15)
        self.view.addSubview(myprofileimg)
        
        // 建立 UITableView 並設置原點及尺寸
        myTableView = UITableView(frame: CGRect(
            x: 0, y: 200,
            width: fullScreenSize.width,
            height: fullScreenSize.height - 20),
                                      style:.Grouped)
        
        // 註冊 cell
        
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // 設置委任對象
        myTableView.delegate=self;
        myTableView.dataSource=self;
        // 分隔線的樣式
        myTableView.separatorStyle = .SingleLine
        
        // 分隔線的間距 四個數值分別代表 上、左、下、右 的間距
        myTableView.separatorInset =
            UIEdgeInsetsMake(0, 20, 0, 20)
        
        // 是否可以點選 cell
        myTableView.allowsSelection = true
        
        // 是否可以多選 cell
        myTableView.allowsMultipleSelection = false
        
        
        self.profile.append("用戶名稱: \("Agent")")
        self.profile.append("用戶性別: \("female")")
        self.profile.append("使用語言: \("chinese English")")
        self.profile.append("教育程度: \("senior high")")
        self.myTableView.reloadData()
        
        // 加入到畫面中
        self.view.addSubview(myTableView)
        // Do any additional setup after loading the view, typically from a nib.
    }
    // 必須實作的方法：每一組有幾個 cell
    func tableView(_tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return profile.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logout(){
        //back to LoginViewController
        let signInView = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = signInView
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

