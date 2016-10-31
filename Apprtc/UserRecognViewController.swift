//
//  UserRecognViewController.swift
//  Apprtc
//
//  Created by IMF on 2016/9/28.
//  Copyright © 2016年 Dhilip. All rights reserved.
//


import UIKit

class UserRecognViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //the value from LoginView
    var ID = String()
    var picture = UIImageView()
    var contentTextLabel = UILabel()
    var CameraButton = UIButton()
    
    var photourl = ""
    var photocomment = ""
    
    let fullScreenSize = UIScreen.mainScreen().bounds.size
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        
        contentTextLabel = UILabel(frame: CGRect(x:0,y:0,width: 200,height:60))
        contentTextLabel.text = " user recogn "
        contentTextLabel.font = contentTextLabel.font.fontWithSize(20)
        contentTextLabel.textColor = UIColor.blueColor()
        contentTextLabel.numberOfLines = 1
        contentTextLabel.center = CGPoint(x: fullScreenSize.width * 0.5,y: fullScreenSize.height * 0.6)
        self.view.addSubview(contentTextLabel)
        
        //picture
        picture.frame = CGRect(x: 0, y: 0,width: 250,height: 250)
        picture.center = CGPoint(x: fullScreenSize.width * 0.5,y: fullScreenSize.height * 0.3)
        picture.image = UIImage(named: ".png")
        self.view.addSubview(picture)
        //button
        CameraButton.frame = CGRect(x: 0, y: 0, width: 200,height: 50)
        CameraButton.center = CGPoint(x: fullScreenSize.width * 0.5,y: fullScreenSize.height * 0.7)
        
        CameraButton.setTitle("Camera", forState: .Normal)
        CameraButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
        CameraButton.backgroundColor = UIColor.darkGrayColor()
        CameraButton.addTarget(self, action: #selector(CameraAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(CameraButton)
        
        //Refresh button
        let refresh_Button = UIBarButtonItem(barButtonSystemItem: .Refresh,target: self,action: #selector(checkstatus))
        self.navigationItem.rightBarButtonItem = refresh_Button

        
    }
    
    func checkstatus(){
        setview()
    }
    
    func setview(){
            contentTextLabel.text = photocomment
            //Button
            CameraButton.enabled = true
            CameraButton.hidden = false
         }
    
    
    
    func CameraAction(){
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
    
    
    //set imageview to camera's content
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Set photoImageView to display the selected image.
        self.picture.image = selectedImage
        print("set photo from camera")
        self.dismissViewControllerAnimated(true, completion: nil)
        CameraButton.enabled = false
        CameraButton.hidden = true
        contentTextLabel.text = "原 子 筆"
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //Dismiss  the picker if the user canceled
        dismissViewControllerAnimated(true, completion: nil)
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
    
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

