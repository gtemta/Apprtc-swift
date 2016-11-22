//
//  LoginViewController.swift
//  Apprtc
//
//  Created by IMF on 2016/9/27.
//  Copyright © 2016年 Dhilip. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController,UITextFieldDelegate {
    
    var userlogin = true
    weak var accountTextField:UITextField!
    weak var passwordTextField:UITextField!
    var checker: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullScreenSize = UIScreen.mainScreen().bounds.size
        self.view.backgroundColor = UIColor.blackColor()
        //app-logo photo
        let targetphotoview = UIImageView( frame: CGRect(x: 0 , y:0 ,width: 200,height: 200))
        targetphotoview.image = UIImage(named:"icons/")
        
        targetphotoview.center = CGPoint(x: fullScreenSize.width*0.5, y: fullScreenSize.height*0.2)
        self.view.addSubview(targetphotoview)
        
        //填入帳號資料
        accountTextField = UITextField(frame: CGRect(x:0,y:0,width: fullScreenSize.width*0.8,height: 50))
        accountTextField.placeholder = "帳號"
        accountTextField.borderStyle = .RoundedRect
        accountTextField.clearButtonMode = .WhileEditing
        accountTextField.keyboardType = .Default
        accountTextField.autocapitalizationType = .None
        accountTextField.autocorrectionType = .No
        accountTextField.textColor = UIColor.blackColor()
        accountTextField.backgroundColor = UIColor.lightGrayColor()
        accountTextField.center = CGPoint(x: fullScreenSize.width * 0.5 ,y : fullScreenSize.height * 0.45)
        self.view.addSubview(accountTextField)
        //填入密碼
        passwordTextField = UITextField(frame: CGRect(x:0,y:0,width: fullScreenSize.width * 0.8,height: 50))
        passwordTextField.placeholder = "密碼"
        passwordTextField.borderStyle = .RoundedRect
        passwordTextField.clearButtonMode = .WhileEditing
        passwordTextField.keyboardType = .Default
        passwordTextField.textColor = UIColor.blackColor()
        passwordTextField.backgroundColor = UIColor.lightGrayColor()
        passwordTextField.secureTextEntry = true
        passwordTextField.center = CGPoint(x: fullScreenSize.width * 0.5 ,y : fullScreenSize.height * 0.55)
        self.view.addSubview(passwordTextField)
        
        //登入按鍵
        let loginButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200 ,height: 40))
        loginButton.setTitle("登入", forState:  UIControlState())
        loginButton.setTitleColor(UIColor.greenColor(), forState:  UIControlState())
        loginButton.enabled = true
        loginButton.backgroundColor = UIColor.darkGrayColor()
        loginButton.addTarget(self, action: #selector(LoginViewController.login), forControlEvents: .TouchUpInside)
        loginButton.center = CGPoint( x: fullScreenSize.width * 0.5 , y: fullScreenSize.height * 0.9 )
        self.view.addSubview(loginButton)
        
        //agent or user text
        let switchTextLabel = UILabel(frame: CGRect(x:0,y:0,width: 200,height: 50))
        switchTextLabel.text = "以用戶／專員身份登入"
        switchTextLabel.textColor = UIColor.purpleColor()
        switchTextLabel.textAlignment = .Center
        
        switchTextLabel.center = CGPoint(x: fullScreenSize.width * 0.4  , y: fullScreenSize.height *  0.7)
        self.view.addSubview(switchTextLabel)
        
        //agent or user switch
        let AUSwitch = UISwitch()
        AUSwitch.center = CGPoint(x: fullScreenSize.width * 0.8 , y: fullScreenSize.height *  0.7)
        AUSwitch.thumbTintColor = UIColor.orangeColor()
        AUSwitch.tintColor = UIColor.blueColor()
        AUSwitch.addTarget(self,action: #selector(LoginViewController.onChange),forControlEvents: .ValueChanged)
        self.view.addSubview(AUSwitch)
        
        
        self.passwordTextField?.delegate = self
        self.accountTextField?.delegate = self
        
    }
    func login(){
        //現階段為跳轉頁面 待修改
        //self.presentViewController(,animated: true, completion: nil)
        
        if userlogin{
            print("userlogin")
            print(userlogin)
            if checker
            {
                let userTabBar = self.storyboard?.instantiateViewControllerWithIdentifier("UserTabBar") as! UITabBarController
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                CustomTabController.sharedInstance.myInformation = accountTextField.text
                appDelegate.window?.rootViewController = userTabBar
                self.dismissViewControllerAnimated(true, completion: nil)
                print("登入系統")
                
            }
            else{
                Failsignin()
            }
            //jumop to agent side app
        }
            
        else {
            print("userlogin")
            print(userlogin)
            
            if checker{
                let agentTabBar = self.storyboard?.instantiateViewControllerWithIdentifier("AgentTabBar") as! UITabBarController
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                CustomTabController.sharedInstance.myInformation = accountTextField.text
                appDelegate.window?.rootViewController = agentTabBar
                self.dismissViewControllerAnimated(true, completion: nil)
                print("登入系統")
                
                // jump to user side app
            }
            else{
                Failsignin()
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func onChange(sender: AnyObject){
        //get UISwitch Object
        let tempswitch = sender as! UISwitch
        if tempswitch.on{
            userlogin = false
            self.view.backgroundColor = UIColor.whiteColor()
            print(userlogin)
        }
        else{
            userlogin = true
            self.view.backgroundColor = UIColor.blackColor()
            print(userlogin)
        }
    }
    
    func Failsignin(){
        print("login fail")
        let alertVC = UIAlertController(
            title: "Sign in Failed",
            message: "Sorry, Please Try again",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK",style: .Default,handler: nil)
        alertVC.addAction(okAction)
        self.presentViewController(alertVC, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userloginpressed(){
        let account = accountTextField.text!
        let password = passwordTextField.text!
        
        guard account != "" && password != "" else {print("Haven't Finish edit."); return}
        print("這是帳號: \(account)")
        print("And my password: \(password)")
        //開始執行web request
        //
        let request = NSMutableURLRequest(URL: NSURL(string: "http://140.113.72.29:8100/api/account/?name="+account+"&pw="+password+"&format=json")!)
        request.HTTPMethod = "GET"
        request.addValue("Basic YWRtaW46aWFpbTEyMzQ=", forHTTPHeaderField: "Authorization")
        NSURLSession.sharedSession().dataTaskWithRequest(request) {data, response, err in
            do{
                let json = try  NSJSONSerialization.JSONObjectWithData(data!, options: [])
                if let section = json as? NSArray{
                    print("section.count: \(section.count)")
                    guard section.count == 1 else{
                        self.checker = false
                        print("return value checker")
                        print(self.checker)
                        return
                    }
                    self.checker = true
                }
            }catch{print("Couldn't Serialize")}
            print("return value checker")
            print(self.checker)
        }.resume()
    }
    func agentloginpress(){
        let account = accountTextField.text!
        let password = passwordTextField.text!
        
        guard account != "" && password != "" else {print("Haven't Finish edit."); return}
        print("這是帳號: \(account)")
        print("And my password: \(password)")
        trylogin(account, password)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if userlogin{
            userloginpressed()
        }
        else{
            agentloginpress()
        }
        
        return false
    }
    
    func trylogin(agentid:String ,_ agentpw: String){
        let request = NSMutableURLRequest(URL:  NSURL(string: "http://140.113.72.29:8100/agent/login/")! as NSURL)
        request.HTTPMethod = "POST"
        let body = "username=\(agentid)&password=\(agentpw)&type=api"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("Basic YWRtaW46aWFpbTEyMzQ=", forHTTPHeaderField: "Authorization")
        NSURLSession.sharedSession().dataTaskWithRequest(request){data, response, err in
            print("response:\(response)")
            
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]
                print("my result is\(result)")
                if result!["state"] as! String == "ok"{
                    self.checker = true
                    let ID = result!["agent"] as! Int
                    let infoID = String(ID)
                    CustomTabController.sharedInstance.myID = infoID
                }
                else{
                    self.checker = false
                }
                
            } catch {print("Error -> \(error)")}
            print("return value checker")
            print(self.checker)

            }.resume()
    }

}
