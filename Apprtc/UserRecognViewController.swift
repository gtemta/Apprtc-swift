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
    @IBOutlet var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullScreenSize = UIScreen.mainScreen().bounds.size
        self.view.backgroundColor = UIColor.blackColor()
        
        //imageView.image = UIImage(named: "pikachu.png")
        
        
        // get account from loginview
        if let tbc = CustomTabController.sharedInstance.myID{
            ID =  tbc
            print ("========account ID=======")
            print(ID)
            print ("================================")
        }
        //
        //        //text
        //        switchTextLabel = UILabel(frame: CGRect(x:0,y:0,width: 200,height: 50))
        //        switchTextLabel.text = ""
        //        switchTextLabel.textColor = UIColor.purpleColor()
        //        switchTextLabel.textAlignment = .Center
        //
        //        switchTextLabel.center = CGPoint(x: fullScreenSize.width * 0.4  , y: fullScreenSize.height *  0.7)
        //        self.view.addSubview(switchTextLabel)
        
        picture = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        picture.image = UIImage(named: "pikachu.png")
        picture.center = CGPoint(x: fullScreenSize.width * 0.5,y: fullScreenSize.height * 0.4)
        self.view.addSubview(picture)
        
        uploadRequest()
//        //送出結果按鍵
//        let sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200 ,height: 40))
//        sendButton.setTitle("送出結果", forState: UIControlState())
//        sendButton.setTitleColor(UIColor.greenColor(), forState:  UIControlState())
//        sendButton.enabled = true
//        sendButton.backgroundColor = UIColor.darkGrayColor()
//        sendButton.addTarget(self, action: #selector(uploadRequest()), forControlEvents: .TouchUpInside)
//        sendButton.center = CGPoint( x: fullScreenSize.width * 0.5 , y: fullScreenSize.height * 0.9 )
//        self.view.addSubview(sendButton)
//        
        
    }
        
    @IBAction func openCamera(sender: AnyObject) {
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
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Set photoImageView to display the selected image.
        picture.image = selectedImage
        //Dismiss  the picker
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //Dismiss  the picker if the user canceled
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func uploadRequest(){
        
        //get image Data from ImageView
        let imageData:NSData = UIImagePNGRepresentation(picture.image!)!
        let boundary = generateBoundaryString()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://140.113.72.29:8100/api/photo/")!)
        //define multipart request type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let session = NSURLSession.sharedSession()
        let body = NSMutableData()
        let accountname = "http://140.113.72.29:8100/api/account/" + self.ID + "/"
        let fname = "upload.png"
        let mimetype = "image/png"
        
        //define the data post parameter
        //multi part header
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"test\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("hi\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        //account field
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"account\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(accountname)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        //state field
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"state\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(1)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        //image field
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"image\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(imageData)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        //multi part end
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        request.HTTPBody = body
        print("body")
        print (body)
        
        request.HTTPMethod = "POST"
        
//        let params = NSMutableDictionary()
//        params.setValue(key, forKey: "account")
//        params.setValue(1, forKey: "state")
//        print("json content")
//        print(params)
//        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = session.dataTaskWithRequest(request,completionHandler: {data,response,error -> Void in
            print("Response: \(response)")})
        task.resume()
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

