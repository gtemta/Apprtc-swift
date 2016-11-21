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
    
    
    var targetroom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

