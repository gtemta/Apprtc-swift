//
//  ProfileViewController.swift
//  Apprtc
//
//  Created by IMF on 2016/9/27.
//  Copyright © 2016年 Dhilip. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var info = [
        ["Name","Gender","Level","Language","Education"]
    ]
    
    
    
    
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       // 取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        
        
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
        
        // 顯示的內容
        if let myLabel = cell.textLabel {
            myLabel.text =
                "\(info[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row])"
        }
        
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullScreenSize = UIScreen.mainScreen().bounds.size
        
        let myprofileimg = UIImageView(
            frame: CGRect(
                x:0, y:0, width: 200, height: 180))
        
        myprofileimg.image = UIImage(named: "icons/profile.png")
        
        myprofileimg.center = CGPoint(x: fullScreenSize.width*0.5, y: fullScreenSize.height*0.15)
        self.view.addSubview(myprofileimg)
        
        
        // 建立 UITableView 並設置原點及尺寸
        let myTableView = UITableView(frame: CGRect(
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
        
        // 加入到畫面中
        self.view.addSubview(myTableView)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    // 必須實作的方法：每一組有幾個 cell
    func tableView(_tableView: UITableView,
                     numberOfRowsInSection section: Int) -> Int {
        return info[section].count
    }
    
    
    
    // 點選 cell 後執行的動作
    func tableView(_tableView: UITableView,
                     didSelectRowAt indexPath: NSIndexPath) {
        // 取消 cell 的選取狀態

        //tableView.deselectRow(at: indexPath, animated: true)
        

        
        let name = info[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        print("選擇的是 \(name)")
    }
    
    
    // 點選 Accessory 按鈕後執行的動作
    // 必須設置 cell 的 accessoryType
    // 設置為 .DisclosureIndicator (向右箭頭)之外都會觸發
    func tableView(_tableView: UITableView,
                     accessoryButtonTappedForRowWith
        indexPath: NSIndexPath) {
        let name = info[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        print("按下的是 \(name) 的 detail")
    }
    
    // 有幾組 section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return info.count

    }
   
    // 每個 section 的標題
    func tableView(_tableView: UITableView,
                     titleForHeaderInSection section: Int) -> String? {
        let title = section == 0 ? "My Profile" : "wrong"
        return title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logout(_sender: AnyObject) {
        //LoginViewController
        //let signInView = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.window?.rootViewController = signInView
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

