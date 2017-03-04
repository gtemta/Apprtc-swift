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
    let ipadress = "http://175.98.115.42/"
    
    var photourl = ""
    var photocomment = ""
    
    let fullScreenSize = UIScreen.mainScreen().bounds.size
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        // get account from loginview
        if let tbc = CustomTabController.sharedInstance.myID{
            ID =  tbc
            print ("========account ID=======")
            print(ID)
            print ("=========================")
        }
        
        contentTextLabel = UILabel(frame: CGRect(x:0,y:0,width: 200,height:200))
        contentTextLabel.text = "歡迎來到拍照辨識，請拍攝想要辨識的物品"
        contentTextLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        contentTextLabel.numberOfLines = 0
        contentTextLabel.font = contentTextLabel.font.fontWithSize(25)
        contentTextLabel.textColor = UIColor.blueColor()
        contentTextLabel.center = CGPoint(x: fullScreenSize.width * 0.5,y: fullScreenSize.height * 0.5)
        self.view.addSubview(contentTextLabel)
        
        //picture
        picture.frame = CGRect(x: 0, y: 0,width: 150,height: 150)
        picture.center = CGPoint(x: fullScreenSize.width * 0.5,y: fullScreenSize.height * 0.20)
        picture.image = UIImage(named: "pikachu.png")
        self.view.addSubview(picture)
        
        //button
        CameraButton.frame = CGRect(x: 0, y: 0, width: 200,height: 50)
        CameraButton.center = CGPoint(x: fullScreenSize.width * 0.5,y: fullScreenSize.height * 0.83)
        CameraButton.setTitle("拍攝照片", forState: .Normal)
        CameraButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
        CameraButton.backgroundColor = UIColor.darkGrayColor()
        CameraButton.addTarget(self, action: #selector(CameraAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(CameraButton)
        
        //Refresh button
        let refresh_Button = UIBarButtonItem(barButtonSystemItem: .Refresh,target: self,action: #selector(checkstatus))
        self.navigationItem.rightBarButtonItem = refresh_Button
        checkstatus()
    }
    
    func checkstatus(){
        print("in checkstatus")
        
        let filter = NSArray()
        let request = NSMutableURLRequest(URL: NSURL(string: ipadress + "api/photo/?account="+ID)!)
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
                            var comment = photo_data["comment"] as? String
                            self.photourl = url
                            if comment == nil{
                                comment = ""
                            }
                            self.photocomment = comment!
                            print("statecode: \(state)")
                            dispatch_async(dispatch_get_main_queue(), {
                                if section.count == 1 {self.setview(0)}
                                else{self.setview(state)}
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
           
            //imageview
            picture.image = UIImage(named: "pikachu.png")
           
            //Button
            CameraButton.enabled = true
            CameraButton.hidden = false
        }
        // wait for agent recogn the photo
        if situation==1 {
            contentTextLabel.text = "前次照片等待辨識中，請稍後再來查看"
            //imageview
            load_image(photourl)
            CameraButton.enabled = false
            CameraButton.hidden = true
        }
        //show the previous photo & the camera Button
        if situation==3 {
            contentTextLabel.text = photocomment
            load_image(photourl)
            
            //Button
            CameraButton.enabled = true
            CameraButton.hidden = false
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
            imagePicker.showsCameraControls = false
            presentViewController(imagePicker, animated: true, completion: {imagePicker.takePicture()})
        }else{
            //no camera
            noCamera()
        }
    }
    
    
    //set imageview to camera's content
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        print("now here")
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Set photoImageView to display the selected image.
        let myOrientation = selectedImage.imageOrientation
        self.picture.image = selectedImage
        print("set photo from camera")
        self.uploadRequest(selectedImage, Orientation: myOrientation)
        self.dismissViewControllerAnimated(true, completion: nil)
        //Dismiss  the picker
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //Dismiss  the picker if the user canceled
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func uploadRequest(image: UIImage, Orientation: UIImageOrientation ){
        self.setview(1)
        self.picture.image = image
        func mynewUpLoad(image: UIImage, Orientation: UIImageOrientation ){
            print("upload start")
            //get image Data from ImageView
            let imageData:NSData = UIImageJPEGRepresentation(image, 0)!
            let boundary = generateBoundaryString()
            let request = NSMutableURLRequest(URL: NSURL(string: ipadress + "api/photo/")!)
            //define multipart request type
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let session = NSURLSession.sharedSession()
            let body = NSMutableData()
            let accountname = ipadress + "api/account/" + self.ID + "/"
            
            //date
            let date = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let date2 = formatter.stringFromDate(date) as String
            print(date2)
            //
            let fname = date2 + ".jpeg"
            let mimetype = "image/jpeg"
            
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
        mynewUpLoad(image, Orientation: Orientation)
        checkstatus()
    }
    
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "沒有相機",
            message: "抱歉本裝置並沒有相機裝置",
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

