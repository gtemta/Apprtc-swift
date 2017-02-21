//
//  AgentRTCRoomViewController.swift
//  Apprtc
//
//  Created by IMF on 2016/9/29.
//  Copyright © 2016年 Dhilip. All rights reserved.
//


import UIKit

class AgentRTCRoomViewController: UITableViewController,AgentRTCRoomTextInputViewCellDelegate {
    
    
    //the value from LoginView
    var account = String()
    var id = ""
    var targetroom = CustomTabController.sharedInstance.targetRoom!
    let ipadress = "http://175.98.115.42/"
    // get account from loginview
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tbc = CustomTabController.sharedInstance.myID{
            id =  tbc
            print ("======agent==RTC login id =======")
            print(id)
            print ("================================")
        }
        //Refresh button
        let refresh_Button = UIBarButtonItem(title:"重新整理服務",style: .Plain ,target: self,action: #selector(refreshAlert))
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
            var cell:AgentRTCRoomTextInputViewCell
            cell=(tableView.dequeueReusableCellWithIdentifier("RoomInputCell", forIndexPath: indexPath) as! AgentRTCRoomTextInputViewCell)
            cell.delegate=self
            return cell
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("MahabaliCell")!
        }
        return cell
    }
    
    func shouldJoinRoom(room: NSString, textInputCell: AgentRTCRoomTextInputViewCell) {
        self.performSegueWithIdentifier("AgentRTCVideoChatViewController", sender: room)
    }
    //重新整理
    func refreshAlert(){
        let alertView = UIAlertController(title: "系統訊息", message: "確定真的要重新刷新專員服務？若是請按下確認",preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in })
        alertView.addAction(confirmAction)
        let cancellAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: nil)
        alertView.addAction(cancellAction)
        presentViewController(alertView, animated: true, completion: nil)
    }
    func recheck(){
        //get the fit roomname
        let request = NSMutableURLRequest(URL: NSURL(string: ipadress + "api/uca/")!)
        let params = NSMutableDictionary()
        params.setValue(self.id, forKey: "agent_id")
        print(" Result json content")
        print(params)
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic YWRtaW46aWFpbTEyMzQ=", forHTTPHeaderField: "Authorization")
        NSURLSession.sharedSession().dataTaskWithRequest(request) {data, response, err in
            do{
                let json = try  NSJSONSerialization.JSONObjectWithData(data!, options: [])
                if let section = json as? NSDictionary{
                    if (section.count==0){
                        dispatch_async(dispatch_get_main_queue(), {
                            self.alertnull()
                            self.targetroom = ""
                        })
                    }
                    else{
                        let roomname = section["msg"] as? String
                        if roomname == nil{
                            print("room is nil")
                        }
                        else{
                            self.targetroom = roomname!
                        }
                        print ("target Room : ")
                        print(self.targetroom)
                    }
                }
            }catch{
                print("Couldn't Serialize")
            }
            }.resume()
}

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(" to string \(segue.destinationViewController.dynamicType)")
        let viewController:AgentRTCVideoChatViewController=segue.destinationViewController as! AgentRTCVideoChatViewController
            //pass the roomname
        self.targetroom = CustomTabController.sharedInstance.targetRoom!
        print("THIS ROOM NAME :")
        print(targetroom)
        if targetroom == ""{alertnull()}
        else{
            print("GO ROOOOOOOOOM")
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
        let alertView = UIAlertController(title: "系統訊息", message: "目前無用戶需要服務，請稍後再試",preferredStyle: .Alert)
        let action = UIAlertAction(title: "確認",style: UIAlertActionStyle.Default, handler: nil)
        alertView.addAction(action)
        presentViewController(alertView, animated: true, completion: nil)
        
    }
}

