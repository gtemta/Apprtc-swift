//
//  UserRecognViewController.swift
//  Apprtc
//
//  Created by IMF on 2016/9/28.
//  Copyright © 2016年 Dhilip. All rights reserved.
//


import UIKit

class UserRecognViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var userlogin = true
    //the value from LoginView
    var account = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullScreenSize = UIScreen.mainScreen().bounds.size
        self.view.backgroundColor = UIColor.blackColor()
        
        
        // get account from loginview
        if let tbc = CustomTabController.sharedInstance.myInformation{
            account =  tbc
            print ("===========login  account=======")
            print(account)
            print ("================================")
        }
        
        
        
        //camera按鍵
        let loginButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200 ,height: 40))
        loginButton.setTitle("camera", forState:  UIControlState())
        loginButton.setTitleColor(UIColor.greenColor(), forState:  UIControlState())
        loginButton.enabled = true
        loginButton.backgroundColor = UIColor.darkGrayColor()
        //loginButton.addTarget(self, action: #selector(UserRecognViewController.opencamera), forControlEvents: .TouchUpInside)
        loginButton.center = CGPoint( x: fullScreenSize.width * 0.5 , y: fullScreenSize.height * 0.85 )
        self.view.addSubview(loginButton)
        
        //text
        let switchTextLabel = UILabel(frame: CGRect(x:0,y:0,width: 200,height: 50))
        switchTextLabel.text = ""
        switchTextLabel.textColor = UIColor.purpleColor()
        switchTextLabel.textAlignment = .Center
        
        switchTextLabel.center = CGPoint(x: fullScreenSize.width * 0.4  , y: fullScreenSize.height *  0.7)
        self.view.addSubview(switchTextLabel)
        
        
        
    }
    
    
    
    @IBAction func openCamera(sender: UIButton) {
        print("進入相機頁面")
        if UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            presentViewController(imagePicker, animated: true, completion: nil)
        }else{
            //no camera
            noCamera()
        }
    
    }
    
    
    
    func onChange(sender: AnyObject){
        //get UISwitch Object
        let tempswitch = sender as! UISwitch
        if tempswitch.on{
            userlogin = true
            self.view.backgroundColor = UIColor.whiteColor()
        }
        else{
            userlogin = false
            self.view.backgroundColor = UIColor.blackColor()
        }
        
        
        
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK",style: .Default,handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

