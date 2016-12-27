//
//  ViewController.swift
//  Apprtc
//
//  Created by Mahabali on 9/5/15.
//  Copyright (c) 2015 Mahabali. All rights reserved.
//

import UIKit

class RTCRoomViewController: UITableViewController,RTCRoomTextInputViewCellDelegate {
    
    
    //the value from LoginView
    var id = String()
    let ipadress = "http://140.113.72.29:8100/"
    
    
    var targetroom = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // get account from loginview
        if let tbc = CustomTabController.sharedInstance.myID{
            id =  tbc
            print ("========RTC login id =======")
            print (id)
            print ("============================")
        }
        //Refresh button
        let refresh_Button = UIBarButtonItem(title:"重新要求服務",style: .Plain ,target: self,action: #selector(refreshAlert))
        self.navigationItem.rightBarButtonItem = refresh_Button

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell
        if (indexPath.row == 0){
            var cell:RTCRoomTextInputViewCell
            cell=tableView.dequeueReusableCellWithIdentifier("RoomInputCell", forIndexPath: indexPath) as! RTCRoomTextInputViewCell
            cell.delegate=self
            return cell
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("MahabaliCell")!
        }
        return cell
    }
    
    //
    func refreshAlert(){
        let alertView = UIAlertController(title: "系統訊息", message: "確定真的要重新要求分配專員服務？若是請按下確認",preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in self.regetroommname()})
        alertView.addAction(confirmAction)
        let cancellAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: nil)
        alertView.addAction(cancellAction)
        presentViewController(alertView, animated: true, completion: nil)
    }
    // refresh the roomname
    func regetroommname(){
        //get the fit roomname
        let request = NSMutableURLRequest(URL: NSURL(string: ipadress + "api/uca/?account_id=" + self.id + "&format=json")!)
        request.HTTPMethod = "GET"
        request.addValue("Basic YWRtaW46aWFpbTEyMzQ=", forHTTPHeaderField: "Authorization")
        NSURLSession.sharedSession().dataTaskWithRequest(request) {data, response, err in
            do{
                let json = try  NSJSONSerialization.JSONObjectWithData(data!, options: [])
                if let section = json as? NSDictionary{
                    if (section.count==0){
                        dispatch_async(dispatch_get_main_queue(), {
                        })
                    }
                    else{
                        
                        let roomname = section["msg"] as? String
                        if roomname == nil {
                            print("room is nil")
                            CustomTabController.sharedInstance.targetRoom = ""
                        }
                        else {
                            self.targetroom = roomname!
                            CustomTabController.sharedInstance.targetRoom = self.targetroom
                        }
                        print ("::RE::target Room : ")
                        print(self.targetroom)
                    }
                }
            }catch{
                print("Couldn't Serialize")
            }
            }.resume()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    
    func shouldJoinRoom(room: NSString, textInputCell: RTCRoomTextInputViewCell) {
        self.performSegueWithIdentifier("RTCVideoChatViewController", sender: room)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(" to string \(segue.destinationViewController.dynamicType)")
        let viewController:RTCVideoChatViewController=segue.destinationViewController as! RTCVideoChatViewController
            //pass the roomname
        targetroom = CustomTabController.sharedInstance.targetRoom!
        if targetroom == ""{alertnull()}else{
            viewController.roomName = targetroom
            print("Segue use roomname")
            print(viewController.roomName)
            viewController.roomName!=sender as! String
        }
    }
    
    override func  shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    func alertnull(){
        let alertView = UIAlertController(title: "系統訊息", message: "系統中無專員可提供服務，請稍後再試",preferredStyle: .Alert)
        let action = UIAlertAction(title: "確認",style: UIAlertActionStyle.Default, handler: nil)
        alertView.addAction(action)
        presentViewController(alertView, animated: true, completion: nil)

    }

}

