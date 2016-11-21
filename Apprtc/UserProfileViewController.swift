//
//  UserProfileViewController.swift
//  Apprtc
//
//  Created by IMF on 2016/9/28.
//  Copyright © 2016年 Dhilip. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var info = [
        ["Name","Gender","Level","Language","Education"]
    ]
    
    var profile : [String] = []
    var myTableView: UITableView!
    
    var pickerView = UIPickerView()

    let items = [1,2,3,4,5]
    
    
    //the value from LoginView
    var account:String = ""
    var userid:String = ""
    
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
        
        //log out button
        let logout_Button = UIBarButtonItem(barButtonSystemItem: .Reply,target: self,action: #selector(UserProfileViewController.logout))
        self.navigationItem.rightBarButtonItem = logout_Button
        
        let fullScreenSize = UIScreen.mainScreen().bounds.size
        self.view.backgroundColor = UIColor.blackColor()
        let myprofileimg = UIImageView(
            frame: CGRect(
                x:0, y:0, width: 200, height: 180))
        
        myprofileimg.image = UIImage(named: "icons/profile.png")
        
        myprofileimg.center = CGPoint(x: fullScreenSize.width*0.5, y: fullScreenSize.height*0.15)
        self.view.addSubview(myprofileimg)
        
        
        // get account from loginview
        if let tbc = CustomTabController.sharedInstance.myInformation
        {
            account = tbc
            print ("===========login  account=======")
            print(account)
            print ("================================")
        }
        
        
        
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
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://140.113.72.29:8100/api/account/?name=" + account + "&?format=json")!)
        request.HTTPMethod = "GET"
        request.addValue("Basic YWRtaW46aWFpbTEyMzQ=", forHTTPHeaderField: "Authorization")
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) {data, response, err in
            do{
                let json = try  NSJSONSerialization.JSONObjectWithData(data!, options: [])
                if let section = json as? NSArray{
                    if let profile_data = section[0] as? NSDictionary{
                        print(profile_data)
                        let realname = profile_data["realname"]! as! String
                        let education = profile_data["education"]! as! Int
                        let language = profile_data["language"]! as! Int
                        let gender = profile_data["gender"]! as! Int
                        let id = profile_data["id"]! as! Int
                        let level = profile_data["level"]! as! Int
                        self.profile.append("用戶名稱: \(realname)")
                        self.profile.append("用戶性別: \(self.gender_decode(gender))")
                        self.profile.append("使用語言: \(self.language_decode(language))")
                        self.profile.append("教育程度: \(self.education_decode(education))")
                        self.profile.append("視障等級: \(self.level_decode(level))")
                        self.myTableView.reloadData()
                        print(id)
                        self.userid = String(id)
                        CustomTabController.sharedInstance.myID = String(id)
                        print("this is my STR \(self.profile)")
                        self.changeState(1, userid: String(id))
                    }
                }
            }catch{
                print("Couldn't Serialize")
            }
            }.resume()
        
        
        // 加入到畫面中
        self.view.addSubview(myTableView)
        // Do any additional setup after loading the view, typically from a nib.
     //888888888888888888888888888888888888888888888
    }
    func leaveRating(){
        let alertView = UIAlertController(title: "請給予評分", message: "這次的服務品質您給幾分?",preferredStyle: .Alert)
//        alertView.modalInPopover = true
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
 
        //set the pickers datasource and delegate
//        picker.delegate = self;
//        picker.dataSource = self;
//        //Add the picker to the alert controller
//        alertView.view.addSubview(pickerView)
        
        let star1 = UIAlertAction(title: "★",style: UIAlertActionStyle.Default, handler: {action in self.realLogout();self.sendRating(1)})
        let star2 = UIAlertAction(title: "★★",style: UIAlertActionStyle.Default, handler: {action in self.realLogout();self.sendRating(2)})
        let star3 = UIAlertAction(title: "★★★",style: UIAlertActionStyle.Default, handler: {action in self.realLogout();self.sendRating(3)})
        let star4 = UIAlertAction(title: "★★★★",style: UIAlertActionStyle.Default, handler: {action in self.realLogout();self.sendRating(4)})
        let star5 = UIAlertAction(title: "★★★★★",style: UIAlertActionStyle.Default, handler: {action in self.realLogout();self.sendRating(5)})
        alertView.addAction(star5)
        alertView.addAction(star4)
        alertView.addAction(star3)
        alertView.addAction(star2)
        alertView.addAction(star1)
        presentViewController(alertView, animated: true, completion: nil)
    
    }
    
    func  sendRating(_rate: Int) {
        //現階段為返回前頁 待修改
//        let theRate = _rate;
//        //put result to photo
//        let request = NSMutableURLRequest(URL:  NSURL(string: "http://140.113.72.29:8100/api/photo/" + photoid + "/")! as NSURL)
//        request.HTTPMethod = "PUT"
//        let params = NSMutableDictionary()
//        params.setValue(comment, forKey: "comment")
//        params.setValue(3, forKey: "state")
//        params.setValue(photouser[0], forKey: "account")
//        print(" Result json content")
//        print(params)
//        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Accept", forHTTPHeaderField: "Vary")
//        //=====================
//        request.addValue("Basic YWRtaW46aWFpbTEyMzQ=", forHTTPHeaderField: "Authorization")
//        //^^^^^^^^^^^^^^^^^^^^^
//        NSURLSession.sharedSession().dataTaskWithRequest(request){data, response, err in
//            print("response:\(response)")
//            }.resume()
//        
//        
//        self.dismissViewControllerAnimated(true, completion: nil)
//        print("送出結果")
//        searchObject()
    }
    
    //change user state
    func changeState(userstate:Int ,userid: String){
        let request = NSMutableURLRequest(URL:  NSURL(string: "http://140.113.72.29:8100/api/account/" + userid + "/")! as NSURL)
        request.HTTPMethod = "PUT"
        let params = NSMutableDictionary()
        params.setValue(userstate, forKey: "state")
        print(" state json content")
        print(params)
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Accept", forHTTPHeaderField: "Vary")
        request.addValue("Basic YWRtaW46aWFpbTEyMzQ=", forHTTPHeaderField: "Authorization")
        NSURLSession.sharedSession().dataTaskWithRequest(request){data, response, err in
            print("response:\(response)")
            }.resume()
    }
    
    
    func logout(){
//        //back to LoginViewController
//        let signInView = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        changeState(0, userid: userid)
        leaveRating()
//        appDelegate.window?.rootViewController = signInView
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func realLogout(){
        //back to LoginViewController
        let signInView = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        changeState(0, userid: userid)

        appDelegate.window?.rootViewController = signInView
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // 必須實作的方法：每一組有幾個 cell
    func tableView(_tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return profile.count
    }
    //
    //
    //    // 點選 cell 後執行的動作
    //    func tableView(_tableView: UITableView,
    //                   didSelectRowAt indexPath: NSIndexPath) {
    //        // 取消 cell 的選取狀態
    //
    //        //tableView.deselectRow(at: indexPath, animated: true)
    //
    //
    //
    //        let name = info[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
    //        print("選擇的是 \(name)")
    //    }
    //
    //
    //    // 點選 Accessory 按鈕後執行的動作
    //    // 必須設置 cell 的 accessoryType
    //    // 設置為 .DisclosureIndicator (向右箭頭)之外都會觸發
    //    func tableView(_tableView: UITableView,
    //                   accessoryButtonTappedForRowWith
    //        indexPath: NSIndexPath) {
    //        let name = info[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
    //        print("按下的是 \(name) 的 detail")
    //    }
    //
    // 有幾組 section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    //
    //    // 每個 section 的標題
    //    func tableView(_tableView: UITableView,
    //                   titleForHeaderInSection section: Int) -> String? {
    //        let title = section == 0 ? "My Profile" : "wrong"
    //        return title
    //    }
    //
    func education_decode(e: Int) -> String{
        switch e {
        case 0:
            return "學前教育"
        case 1:
            return "學前教育"
        case 2:
            return "國民中學"
        case 3:
            return "高級中學"
        case 4:
            return "專科（副學士）"
        case 5:
            return "大學（學士）"
        case 6:
            return "碩士"
        case 7:
            return "博士"
        default:
            return "SOME THING WENT WRONG"
        }
    }
    
    func language_decode(l: Int) -> String{
        switch l {
        case 1:
            return "中文"
        case 2:
            return "英文"
        case 3:
            return "中文、英文"
        case 4:
            return "客家語"
        case 5:
            return "中文、客家語"
        case 6:
            return "英文、客家語"
        case 7:
            return "中文、英文、客家語"
        case 8:
            return "閩南語"
        case 9:
            return "中文、閩南語"
        case 10:
            return "英文、閩南語"
        case 11:
            return "中文、英文、閩南語"
        case 12:
            return "客家語、閩南語"
        case 13:
            return "中文、客家語、閩南語"
        case 14:
            return "英文、客家語、閩南語"
        case 15:
            return "中文、英文、客家語、閩南語"
        default:
            return "SOME THING WENT WRONG"
        }
    }
    
    func gender_decode(g: Int) -> String{
        if g==0{
            return "男"
        }
        else{
            return "女"
        }
    }
    
    func level_decode(l: Int) -> String{
        switch l {
        case 1:
            return "輕度視障"
        case 2:
            return "中度視障"
        case 3:
            return "高度視障"
        default:
            return "SOME THING WENT WRONG"
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

