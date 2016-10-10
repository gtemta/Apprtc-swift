//
//  AgentRecognViewController.swift
//  Apprtc
//
//  Created by IMF on 2016/9/28.
//  Copyright © 2016年 Dhilip. All rights reserved.
//

import UIKit

class AgentRecognViewController: UIViewController {
    

    //the value from LoginView
    var account = String()
    var comment = ""
    let titletext = UILabel()
    
    let fullScreenSize = UIScreen.mainScreen().bounds.size
    let colorTextField = UITextField()
    let nameTextField = UITextField()
    
override func viewDidLoad() {
    super.viewDidLoad()
    
    
    // get account from loginview
    if let tbc = CustomTabController.sharedInstance.myInformation{
        account =  tbc
        print ("===========login  account=======")
        print(account)
        print ("================================")
    }
    
    
    self.view.backgroundColor = UIColor.whiteColor()
    
    //辨識圖片設定
    let targetphotoview = UIImageView( frame: CGRect(x: 0 , y:0 ,width: 200,height: 200))
    targetphotoview.image = UIImage(named: "icons/glass")
    
    targetphotoview.center = CGPoint(x: fullScreenSize.width*0.5, y: fullScreenSize.height*0.2)
    self.view.addSubview(targetphotoview)
    
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
    sendButton.center = CGPoint( x: fullScreenSize.width * 0.5 , y: fullScreenSize.height * 0.9 )
    self.view.addSubview(sendButton)
    
    
    
    // Do any additional setup after loading the view.
}

func  sendResult() {
    //現階段為返回前頁 待修改
    comment = String(colorTextField.text) + String(nameTextField.text)
    self.dismissViewControllerAnimated(true, completion: nil)
    print("送出結果")
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
