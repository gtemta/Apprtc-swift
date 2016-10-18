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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let fullScreenSize = UIScreen.mainScreen().bounds.size
        self.view.backgroundColor = UIColor.blackColor()
        let fullScreenSize = UIScreen.mainScreen().applicationFrame.size
        //imageView.image = UIImage(named: "pikachu.png")
        
        
        // get account from loginview
        if let tbc = CustomTabController.sharedInstance.myID{
            ID =  tbc
            print ("========account ID=======")
            print(ID)
            print ("=========================")
        }
        
        
        //Refresh button
        let refresh_Button = UIBarButtonItem(barButtonSystemItem: .Refresh,target: self,action: #selector(checkstatus))
        self.navigationItem.rightBarButtonItem = refresh_Button
        
        contentTextLabel.center = CGPoint(x: fullScreenSize.width * 0.5, y:fullScreenSize.height * 0.9)
        contentTextLabel.frame = CGRect(x:0,y:0,width: 250,height: 50)
        contentTextLabel.textColor = UIColor.greenColor()
        contentTextLabel.textAlignment = .Center
        self.view.addSubview(contentTextLabel)
        
        picture.center = CGPoint(x: fullScreenSize.width * 0.5,y: fullScreenSize.height * 0.3)
        picture.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        self.view.addSubview(picture)
        
        CameraButton.center = CGPoint(x: fullScreenSize.width * 0.5,y: fullScreenSize.height * 0.8)
        CameraButton.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
        CameraButton.setTitle("Camera", forState: .Normal)
        CameraButton.setTitleColor(UIColor.blueColor(),forState: .Normal)
        CameraButton.backgroundColor = UIColor.darkGrayColor()
        CameraButton.addTarget(self,action: #selector(CameraAction),forControlEvents: .TouchUpInside)
        self.view.addSubview(CameraButton)
        
        checkstatus()
        
    }
    
    func checkstatus(){
        print("in checkstatus")
        
        let filter = NSArray()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://140.113.72.29:8100/api/photo/?account="+ID)!)
        request.HTTPMethod = "GET"
        request.addValue("Basic YWRtaW46aWFpbTEyMzQ=", forHTTPHeaderField: "Authorization")
        //jump out
        NSURLSession.sharedSession().dataTaskWithRequest(request) {data, response, err in
            do{
                //null check
                let json = try  NSJSONSerialization.JSONObjectWithData(data!, options: [])
                if let section = json as? NSArray{
                    if (section.isEqualToArray(filter as [AnyObject])){
                        dispatch_async(dispatch_get_main_queue(), {
                            self.setview(0)
                        })
                    }
                    else{
                        if let photo_data = section.lastObject as? NSDictionary{
                            print(photo_data)
                            let state = photo_data["state"]! as! Int
                            let url = photo_data["image"]! as! String
                            let comment = photo_data["comment"]! as! String
                            self.photourl = url
                            self.photocomment = comment
                            print("statecode: \(state)")
                            dispatch_async(dispatch_get_main_queue(), {
                                self.setview(state)
                            })
                        }
                    }
                }
                
            }catch{
                print("Couldn't Serialize")
            }
            }.resume()
        
        
        print("out status check")
    }
    
    func setview(situation :Int){
        
        print("in setview")
        print("sitution: \(situation)")
        if situation==0 {
            //text
            contentTextLabel.text = "請拍下欲辨識的物體"
            contentTextLabel.enabled = true
            self.view.addSubview(contentTextLabel)
            
            
            //imageview
            picture.image = UIImage(named: "pikachu.png")
            self.view.addSubview(picture)
            
            
            //Button
            CameraButton.enabled = true
            self.view.addSubview(CameraButton)
            
        }
        // wait for agent recogn the photo
        if situation==1 {
            contentTextLabel.text = "前次照片等待辨識中，請稍後再來查看"
            self.view.addSubview(contentTextLabel)
            
            //imageview
            picture = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
            load_image(photourl)
            self.view.addSubview(picture)
            CameraButton.enabled = false
        }
        //show the previous photo & the camera Button
        if situation==3 {
            contentTextLabel.text = photocomment
            self.view.addSubview(contentTextLabel)
            load_image(photourl)
            
            //Button
            CameraButton.enabled = true
            self.view.addSubview(CameraButton)
        }
        print("out setview")
    }
    
    
    //load image from url
    func load_image(urlString:String)
    {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    self.picture.image = UIImage(data: data!)
                }
        })
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
        let serialQueue = dispatch_queue_create("org.iii.iaim.uploadphoto", DISPATCH_QUEUE_SERIAL)
        
        
        dispatch_async(serialQueue) { () -> Void in
            // The info dictionary contains multiple representations of the image, and this uses the original.
            let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            dispatch_async(dispatch_get_main_queue(), {
                // Set photoImageView to display the selected image.
                self.picture.image = selectedImage
                print("set photo from camera")
            })
        }
        dispatch_async(serialQueue) { () -> Void in
            self.uploadRequest()
            dispatch_async(dispatch_get_main_queue(), {
                self.dismissViewControllerAnimated(true, completion: nil)
                            })
        }
        
        //Dismiss  the picker
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //Dismiss  the picker if the user canceled
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func uploadRequest(){
        print("upload start")
        //get image Data from ImageView
        let imageData:NSData = UIImagePNGRepresentation(picture.image!)!
        let boundary = generateBoundaryString()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://140.113.72.29:8100/api/photo/")!)
        //define multipart request type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let session = NSURLSession.sharedSession()
        let body = NSMutableData()
        let accountname = "http://140.113.72.29:8100/api/account/" + self.ID + "/"
        
        //date
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let date2 = formatter.stringFromDate(date) as String
        print(date2)
        //
        let fname = date2 + ".png"
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
        request.HTTPMethod = "POST"
        request.addValue("Basic YWRtaW46aWFpbTEyMzQ=", forHTTPHeaderField: "Authorization")
        
        
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

