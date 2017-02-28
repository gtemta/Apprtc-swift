//
//  RTCVideoChatViewController.swift
//  Apprtc
//
//  Created by Mahabali on 9/6/15.
//  Copyright (c) 2015 Mahabali. All rights reserved.
//

import UIKit
import AVFoundation
class RTCVideoChatViewController: UIViewController,RTCEAGLVideoViewDelegate,ARDAppClientDelegate {
  //Views, Labels, and Buttons
  @IBOutlet weak var remoteView:RTCEAGLVideoView?
  @IBOutlet weak var localView:RTCEAGLVideoView?
  @IBOutlet weak var footerView:UIView?
  @IBOutlet weak var urlLabel:UILabel?
  @IBOutlet weak var buttonContainerView:UIView?
  @IBOutlet weak var audioButton:UIButton?
  @IBOutlet weak var videoButton:UIButton?
  @IBOutlet weak var hangupButton:UIButton?
  //Auto Layout Constraints used for animations
  @IBOutlet weak var remoteViewTopConstraint:NSLayoutConstraint?
  @IBOutlet weak var remoteViewRightConstraint:NSLayoutConstraint?
  @IBOutlet weak var remoteViewLeftConstraint:NSLayoutConstraint?
  @IBOutlet weak var remoteViewBottomConstraint:NSLayoutConstraint?
  @IBOutlet weak var localViewWidthConstraint:NSLayoutConstraint?
  @IBOutlet weak var localViewHeightConstraint:NSLayoutConstraint?
  @IBOutlet weak var  localViewRightConstraint:NSLayoutConstraint?
  @IBOutlet weak var  localViewBottomConstraint:NSLayoutConstraint?
  @IBOutlet weak var  footerViewBottomConstraint:NSLayoutConstraint?
  @IBOutlet weak var  buttonContainerViewLeftConstraint:NSLayoutConstraint?
  var   roomUrl:NSString?;
  var   client:ARDAppClient?;
  var   _roomName:NSString=NSString(format: "")
  var   roomName:NSString?
  var   localVideoTrack:RTCVideoTrack?;
  var   remoteVideoTrack:RTCVideoTrack?;
  var   localVideoSize:CGSize?;
  var   remoteVideoSize:CGSize?;
  var   isZoom:Bool = false; //used for double tap remote view
  
    
    //=======
    var userid:String = ""
    var userAcctURL:String = ""
    var agentAcctURL:String = ""
    var serviceID:String = ""
    let ipadress = "http://175.98.115.42/"
    //====
    
    
    
  override func viewDidLoad() {
    super.viewDidLoad()
    // get ID from custom
    if let tbc = CustomTabController.sharedInstance.myID
    {
        userid = tbc
        print ("=====RTC   login  account=======")
        print(userid)
        print ("================================")
    }
    getMyService(userid)
    //====
    self.isZoom = false;
    self.audioButton?.layer.cornerRadius=20.0
    self.videoButton?.layer.cornerRadius=20.0
    self.hangupButton?.layer.cornerRadius=20.0
    let tapGestureRecognizer:UITapGestureRecognizer=UITapGestureRecognizer(target: self, action:#selector(RTCVideoChatViewController.toggleButtonContainer) )
    tapGestureRecognizer.numberOfTapsRequired=1
    self.view.addGestureRecognizer(tapGestureRecognizer)
    let zoomGestureRecognizer:UITapGestureRecognizer=UITapGestureRecognizer(target: self, action:#selector(RTCVideoChatViewController.zoomRemote) )
    zoomGestureRecognizer.numberOfTapsRequired=2
    self.view.addGestureRecognizer(zoomGestureRecognizer)
    self.remoteView?.delegate=self
    self.localView?.delegate=self
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RTCVideoChatViewController.orientationChanged(_:)), name: "UIDeviceOrientationDidChangeNotification", object: nil)
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(animated: Bool) {
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    self.localViewBottomConstraint?.constant=0.0
    self.localViewRightConstraint?.constant=0.0
    self.localViewHeightConstraint?.constant=self.view.frame.size.height
    self.localViewWidthConstraint?.constant=self.view.frame.size.width
    self.footerViewBottomConstraint?.constant=0.0
    self.disconnect()
    self.client=ARDAppClient(delegate: self)
    self.client?.serverHostUrl="https://appr.tc/"
    self.client!.connectToRoomWithId(self.roomName! as String, options: nil)
    self.urlLabel?.text = "請稍待 等候專員進入房間 專員進入後本行文字將消失"
  }
  
  override func  viewWillDisappear(animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    NSNotificationCenter.defaultCenter().removeObserver(self)
    self.disconnect()
  }
  
  override func  shouldAutorotate() -> Bool {
    return true
  }
  
  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.AllButUpsideDown
  }
  
  func applicationWillResignActive(application:UIApplication){
    self.disconnect()
  }
  
  func orientationChanged(notification:NSNotification){
    if let _ = self.localVideoSize {
      self.videoView(self.localView!, didChangeVideoSize: self.localVideoSize!)
    }
    if let _ = self.remoteVideoSize {
      self.videoView(self.remoteView!, didChangeVideoSize: self.remoteVideoSize!)
    }
  }
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func audioButtonPressed (sender:UIButton){
    sender.selected = !sender.selected
    self.client?.toggleAudioMute()
  }
  @IBAction func videoButtonPressed(sender:UIButton){
    sender.selected = !sender.selected
    //self.client?.toggleVideoMute()
  }
  //=============
  @IBAction func hangupButtonPressed(sender:UIButton){
    leaveRating()
  }
    //=============
    func leaveRoom(){
        self.disconnect()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
  func disconnect(){
    if let _ = self.client{
      self.localVideoTrack?.removeRenderer(self.localView)
      self.remoteVideoTrack?.removeRenderer(self.remoteView)
      self.localView?.renderFrame(nil)
      self.remoteView?.renderFrame(nil)
      self.localVideoTrack=nil
      self.remoteVideoTrack=nil
      self.client?.disconnect()
    }
  }
    //==================================================
    func leaveRating(){
        let alertView = UIAlertController(title: "請給予評分", message: "這次的服務品質您給幾分?",preferredStyle: .Alert)
        let star1 = UIAlertAction(title: "一顆星",style: UIAlertActionStyle.Default, handler: {action in self.sendRating(1);self.leaveRoom()})
        let star2 = UIAlertAction(title: "兩顆星",style: UIAlertActionStyle.Default, handler: {action in self.sendRating(2);self.leaveRoom()})
        let star3 = UIAlertAction(title: "三顆星",style: UIAlertActionStyle.Default, handler: {action in self.sendRating(3);self.leaveRoom()})
        let star4 = UIAlertAction(title: "四顆星",style: UIAlertActionStyle.Default, handler: {action in self.sendRating(4);self.leaveRoom()})
        let star5 = UIAlertAction(title: "五顆星",style: UIAlertActionStyle.Default, handler: {action in self.sendRating(5);self.leaveRoom()})
        alertView.addAction(star5)
        alertView.addAction(star4)
        alertView.addAction(star3)
        alertView.addAction(star2)
        alertView.addAction(star1)
        presentViewController(alertView, animated: true, completion: nil)
        
    }
    
    func  sendRating(_rate:Int) {
        //將rating值傳回資料庫
        let theRate = _rate
        let acctURL = userAcctURL
        let agentURL = agentAcctURL
        
        let request = NSMutableURLRequest(URL:  NSURL(string: ipadress + "api/service/" + serviceID + "/")! as NSURL)
        request.HTTPMethod = "PUT"
        let params = NSMutableDictionary()
        params.setValue(acctURL, forKey: "account")
        params.setValue(agentURL, forKey: "agent")
        params.setValue(theRate, forKey: "rating")
        print(" Result json content")
        print(params)
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Accept", forHTTPHeaderField: "Vary")
        request.addValue("Basic YWRtaW46aWFpbTEyMzQ=", forHTTPHeaderField: "Authorization")
        NSURLSession.sharedSession().dataTaskWithRequest(request){data, response, err in
            print("response:\(response)")
            }.resume()
        
        print("送出結果")
    }
    
    func getMyService(_theID:String){
        let request = NSMutableURLRequest(URL: NSURL(string: ipadress + "api/service/?account=" + _theID + "&format=json")!)
        request.HTTPMethod = "GET"
        request.addValue("Basic YWRtaW46aWFpbTEyMzQ=", forHTTPHeaderField: "Authorization")
        NSURLSession.sharedSession().dataTaskWithRequest(request) {data, response, err in
            print("response: \(response)")
            do{
                let json = try  NSJSONSerialization.JSONObjectWithData(data!,  options: []) as? NSArray
                if json?.count<1 {
                    print("Havn't have any service")
                }
                else{
                    let minus = "?format=json"
                    let lastService = json![(json!.count)-1] as! NSDictionary
                    let url1 = lastService["account"]!
                    let url2 = lastService["agent"]!
                    let id = lastService["id"]!
                    let surl1 = String(url1)
                    let ssurl1 = surl1.componentsSeparatedByString(minus)
                    let surl2 = String(url2)
                    let ssurl2 = surl2.componentsSeparatedByString(minus)
                    let sid = String(id)
                    self.userAcctURL = ssurl1[0]
                    self.agentAcctURL = ssurl2[0]
                    self.serviceID = sid
                }
            }catch{print(err)}
            }.resume()
        
    }
    
    
    //==================================================
  func remoteDisconnected(){
    self.remoteVideoTrack?.removeRenderer(self.remoteView)
    self.remoteView?.renderFrame(nil)
    if self.localVideoSize != nil {
      self.videoView(self.localView!, didChangeVideoSize: self.localVideoSize!)
    }
  }
  
  func toggleButtonContainer() {
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      if (self.buttonContainerViewLeftConstraint!.constant <= -40.0) {
        self.buttonContainerViewLeftConstraint!.constant=20.0
        self.buttonContainerView!.alpha=1.0;
      }
      else {
        self.buttonContainerViewLeftConstraint!.constant = -40.0;
        self.buttonContainerView!.alpha=0.0;
      }
      self.view.layoutIfNeeded();
    })
  }
  
  func zoomRemote() {
    //Toggle Aspect Fill or Fit
    self.isZoom = !self.isZoom;
    self.videoView(self.remoteView!, didChangeVideoSize: self.remoteVideoSize!)
  }
  
  
  func appClient(client: ARDAppClient!, didChangeState state: ARDAppClientState) {
    switch (state) {
    case .Connected:
      print("Client connected.");
    case .Connecting:
      print("Client connecting.");
    case .Disconnected:
      print("Client disconnected.");
      self.remoteDisconnected();
    }
  }
  
  func appClient(client: ARDAppClient!, didError error: NSError!) {
    let alert = UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "close")
    alert.show()
    self.disconnect()
  }
  
  func appClient(client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
    self.localVideoTrack?.removeRenderer(self.localView)
    self.localView?.renderFrame(nil)
    self.localVideoTrack=localVideoTrack
    self.localVideoTrack?.addRenderer(self.localView)
    
  }
  
  func appClient(client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
    // Dirty hack to route audio to speaker. Hack will be removed with library update
    dispatch_after(2, dispatch_get_main_queue()) { () -> Void in
      let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
      do{
        try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
      }
      catch{
        print("Audio Port Error");
      }
    }
    self.remoteVideoTrack=remoteVideoTrack
    self.remoteVideoTrack?.addRenderer(self.remoteView)
    UIView.animateWithDuration(0.4, animations: { () -> Void in
      self.localViewBottomConstraint?.constant=28.0
      self.localViewRightConstraint?.constant=28.0
      self.localViewHeightConstraint?.constant=self.view.frame.size.height/4
      self.localViewWidthConstraint?.constant=self.view.frame.size.width/4
      self.footerViewBottomConstraint?.constant = -80.0
    })
  }
  
  func appclient(client: ARDAppClient!, didRotateWithLocal localVideoTrack: RTCVideoTrack!, remoteVideoTrack: RTCVideoTrack!) {
    NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(RTCVideoChatViewController.updateUIForRotation), object: nil)
    // Hack for rotation to get the right video size
    self.performSelector(#selector(RTCVideoChatViewController.updateUIForRotation), withObject: nil, afterDelay: 0.2)
  }
  
  func updateUIForRotation(){
    let statusBarOrientation:UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation;
    let deviceOrientation:UIDeviceOrientation  = UIDevice.currentDevice().orientation
    if (statusBarOrientation.rawValue==deviceOrientation.rawValue){
      if let  _ = self.localVideoSize {
      self.videoView(self.localView!, didChangeVideoSize: self.localVideoSize!)
      }
      if let _ = self.remoteVideoSize {
        self.videoView(self.remoteView!, didChangeVideoSize: self.remoteVideoSize!)
      }
    }
    else{
      print("Unknown orientation Skipped rotation");
    }
  }
  
  func videoView(videoView: RTCEAGLVideoView, didChangeVideoSize size: CGSize) {
    let orientation: UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
    UIView.animateWithDuration(0.4, animations: { () -> Void in
      let containerWidth: CGFloat = self.view.frame.size.width
      let containerHeight: CGFloat = self.view.frame.size.height
      let defaultAspectRatio: CGSize = CGSizeMake(4, 3)
      if videoView == self.localView {
        self.localVideoSize = size
        let aspectRatio: CGSize = CGSizeEqualToSize(size, CGSizeZero) ? defaultAspectRatio : size
        var videoRect: CGRect = self.view.bounds
        if (self.remoteVideoTrack != nil) {
            videoRect = CGRectMake(0.0, 0.0, self.view.frame.size.width / 4.0, self.view.frame.size.height / 4.0)
          if orientation == UIInterfaceOrientation.LandscapeLeft || orientation == UIInterfaceOrientation.LandscapeRight {
            videoRect = CGRectMake(0.0, 0.0, self.view.frame.size.height / 4.0, self.view.frame.size.width / 4.0)
          }
        }
        let videoFrame: CGRect = AVMakeRectWithAspectRatioInsideRect(aspectRatio, videoRect)
        self.localViewWidthConstraint!.constant = videoFrame.size.width
        self.localViewHeightConstraint!.constant = videoFrame.size.height
        if (self.remoteVideoTrack != nil) {
          self.localViewBottomConstraint!.constant = 28.0
          self.localViewRightConstraint!.constant = 28.0
        }
        else{
          self.localViewBottomConstraint!.constant = containerHeight/2.0 - videoFrame.size.height/2.0
          self.localViewRightConstraint!.constant = containerWidth/2.0 - videoFrame.size.width/2.0
        }
      }
      else if videoView == self.remoteView {
        self.remoteVideoSize = size
        let aspectRatio: CGSize = CGSizeEqualToSize(size, CGSizeZero) ? defaultAspectRatio : size
        let videoRect: CGRect = self.view.bounds
        var videoFrame: CGRect = AVMakeRectWithAspectRatioInsideRect(aspectRatio, videoRect)
        if self.isZoom {
          let scale: CGFloat = max(containerWidth / videoFrame.size.width, containerHeight / videoFrame.size.height)
          videoFrame.size.width *= scale
          videoFrame.size.height *= scale
        }
        self.remoteViewTopConstraint!.constant = (containerHeight / 2.0 - videoFrame.size.height / 2.0)
        self.remoteViewBottomConstraint!.constant = (containerHeight / 2.0 - videoFrame.size.height / 2.0)
        self.remoteViewLeftConstraint!.constant = (containerWidth / 2.0 - videoFrame.size.width / 2.0)
        self.remoteViewRightConstraint!.constant = (containerWidth / 2.0 - videoFrame.size.width / 2.0)
      }
      self.view.layoutIfNeeded()
    })
    
  }
}
