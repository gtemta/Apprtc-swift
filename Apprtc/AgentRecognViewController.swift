//
//  AgentRecognViewController.swift
//  Apprtc
//
//  Created by IMF on 2016/9/28.
//  Copyright © 2016年 Dhilip. All rights reserved.
//

import UIKit

class AgentRecognViewController: UIViewController ,UITextFieldDelegate{
    
    
    //the value from LoginView
    var account = String()
    var comment = ""
    let titletext = UILabel()
    var photoid = ""
    var photourl = ""
    var photouser:[String] = []
    
    let fullScreenSize = UIScreen.mainScreen().bounds.size
    let colorTextField = UITextField()
    let nameTextField = UITextField()
    var targetphotoview = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // get account from loginview
        if let tbc = CustomTabController.sharedInstance.myID{
            account =  tbc
            print ("===========login  account=======")
            print(account)
            print ("================================")
        }
        searchObject()
        
   
        self.view.backgroundColor = UIColor.whiteColor()
        
        //相片說明文字
        let titletext = UILabel(frame: CGRect(x:0 , y: 0,width: 200,height: 40))
        titletext.text = " 相片中的物體為: "
        titletext.textColor = UIColor.blackColor()
        titletext.numberOfLines = 1
        titletext.center = CGPoint(x: fullScreenSize.width * 0.5 ,y : fullScreenSize.height * 0.4)
        self.view.addSubview(titletext)
        
        //填入物體顏色屬性等資料
        
        colorTextField.frame = CGRect(x:0,y:0,width: fullScreenSize.width*0.8,height: 50)
        colorTextField.placeholder = "填入物體的特性(形狀顏色等)"
        colorTextField.borderStyle = .RoundedRect
        colorTextField.clearButtonMode = .WhileEditing
        colorTextField.keyboardType = .Default
        colorTextField.textColor = UIColor.cyanColor()
        colorTextField.backgroundColor = UIColor.lightGrayColor()
        colorTextField.center = CGPoint(x: fullScreenSize.width * 0.5 ,y : fullScreenSize.height * 0.5)
        self.view.addSubview(colorTextField)
        //填入物體名稱
        nameTextField.frame = CGRect(x:0,y:0,width: fullScreenSize.width * 0.8,height: 50)
        nameTextField.placeholder = "填入物體的名稱"
        nameTextField.borderStyle = .RoundedRect
        nameTextField.clearButtonMode = .WhileEditing
        nameTextField.keyboardType = .Default
        nameTextField.textColor = UIColor.greenColor()
        nameTextField.backgroundColor = UIColor.lightGrayColor()
        nameTextField.center = CGPoint(x: fullScreenSize.width * 0.5 ,y : fullScreenSize.height * 0.6)
        self.view.addSubview(nameTextField)
        //快速回覆表
        let fastPickerView = UIPickerView(frame: CGRect(x:0 ,y:fullScreenSize.height * 0.6, width: fullScreenSize.width, height: 150))
        
        //新增viewcontroller實作委任模式的方法
        let fastPickerViewController = PickerViewController()
        
        self.addChildViewController(fastPickerViewController)
        fastPickerView.delegate = fastPickerViewController
        fastPickerView.dataSource = fastPickerViewController
        self.view.addSubview(fastPickerView)
        
        //送出結果按鍵
        let sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200 ,height: 40))
        sendButton.setTitle("送出結果", forState: UIControlState())
        sendButton.setTitleColor(UIColor.greenColor(), forState:  UIControlState())
        sendButton.enabled = true
        sendButton.backgroundColor = UIColor.darkGrayColor()
        sendButton.addTarget(self, action: #selector(AgentRecognViewController.sendResult), forControlEvents: .TouchUpInside)
        sendButton.center = CGPoint( x: fullScreenSize.width * 0.5 , y: fullScreenSize.height * 0.85 )
        self.view.addSubview(sendButton)
        
        
        //辨識圖片設定
        targetphotoview = UIImageView( frame: CGRect(x: 0 , y:0 ,width: fullScreenSize.width*0.6,height: fullScreenSize.width*0.6))
        targetphotoview.image = UIImage(named: "icons/glass")
        targetphotoview.center = CGPoint(x: fullScreenSize.width*0.5, y: fullScreenSize.height*0.2)
        self.view.addSubview(targetphotoview)
        targetphotoview.reloadInputViews()
        load_image(photourl)
        print("****" + (photourl))
        
        self.colorTextField.delegate = self
        self.nameTextField.delegate = self
        //*****
        //Refresh button
        let refresh_Button = UIBarButtonItem(barButtonSystemItem: .Refresh,target: self,action: #selector(searchObject))
        self.navigationItem.rightBarButtonItem = refresh_Button
        
        // Do any additional setup after loading the view.
    }
    func searchObject(){
        let filter  = NSArray()
        //get recogn photo
        let request = NSMutableURLRequest(URL: NSURL(string: "http://140.113.72.29:8100/api/photo/?state=1&format=json")!)
        request.HTTPMethod = "GET"
        request.addValue("Basic YWRtaW46aWFpbTEyMzQ=", forHTTPHeaderField: "Authorization")
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) {data, response, err in
            do{
                let json = try  NSJSONSerialization.JSONObjectWithData(data!, options: [])
                if let section = json as? NSArray{
                    if (section.isEqualToArray(filter as [AnyObject])){
                        dispatch_async(dispatch_get_main_queue(), {
                            self.alertnull()
                        })
                    }
                    else{
                        
                    if let photo_data = section[0] as? NSDictionary{
                        print(photo_data)
                        let id = photo_data["id"]! as! Int
                        let useraccount = photo_data["account"] as! NSString
                        let url = photo_data["image"]! as! String
                        self.photoid = String(id)
                        self.photourl = url
                        self.photouser = useraccount.componentsSeparatedByString("?format=json")
                        print(self.photoid)
                        print(self.photourl)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.load_image(self.photourl)
                        })
                        
                    }
            }
                }
            }catch{
                print("Couldn't Serialize")
            }
            }.resume()
    }

    func alertnull(){
        let alertView = UIAlertController(title: "系統訊息", message: "佇列中沒有待辨識相片",preferredStyle: .Alert)
        let action = UIAlertAction(title: "確認",style: UIAlertActionStyle.Default, handler: nil)
        alertView.addAction(action)
        self.presentViewController(alertView, animated: true, completion: nil)
       }
    
    
    func load_image(urlString:String)
    {
        
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    self.targetphotoview.image = UIImage(data: data!)
                }
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        comment = String(colorTextField.text) + String(nameTextField.text)
        return false
    }
    
    
    func  sendResult() {
        //現階段為返回前頁 待修改
        comment = String(colorTextField.text!) + "  " + String(nameTextField.text!)
        
        //put result to photo
        let request = NSMutableURLRequest(URL:  NSURL(string: "http://140.113.72.29:8100/api/photo/" + photoid + "/")! as NSURL)
        request.HTTPMethod = "PUT"
        let params = NSMutableDictionary()
        params.setValue(comment, forKey: "comment")
        params.setValue(3, forKey: "state")
        params.setValue(photouser[0], forKey: "account")
        print(" Result json content")
        print(params)
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Accept", forHTTPHeaderField: "Vary")
        //=====================
        request.addValue("Basic YWRtaW46aWFpbTEyMzQ=", forHTTPHeaderField: "Authorization")
        //^^^^^^^^^^^^^^^^^^^^^
        NSURLSession.sharedSession().dataTaskWithRequest(request){data, response, err in
            print("response:\(response)")
            }.resume()
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        print("送出結果")
        searchObject()
    }
    
    @IBAction func logout(_sender: AnyObject) {
        //LoginViewController
        //let signInView = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.window?.rootViewController = signInView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
