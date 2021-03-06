//
//  AgentRTCRoomTextInputViewCell.swift
//  Apprtc
//
//  Created by IMF on 2016/10/5.
//  Copyright © 2016年 Dhilip. All rights reserved.
//


import UIKit



protocol AgentRTCRoomTextInputViewCellDelegate{
    func shouldJoinRoom (room:NSString,textInputCell:AgentRTCRoomTextInputViewCell)
}


class AgentRTCRoomTextInputViewCell: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var textField:UITextField?
    @IBOutlet weak var textFieldBorderView:UIView?
    @IBOutlet weak var joinButton:UIButton?
    @IBOutlet weak var errorLabel:UILabel?
    @IBOutlet weak var errorLabelHeightConstraint:NSLayoutConstraint?
    var delegate:AgentRTCRoomTextInputViewCellDelegate?
    var id = ""
    var targetroom = ""
    
    override func awakeFromNib() {
        self.errorLabelHeightConstraint?.constant=0.0
        self.textField?.delegate=self
        self.joinButton?.backgroundColor=UIColor(white: 100/255, alpha: 1.0)
        self.joinButton?.enabled=true
        self.joinButton?.layer.cornerRadius=3.0
        
        // get account from loginview
        if let tbc = CustomTabController.sharedInstance.myID{
            id =  tbc
            print ("======agent==RTC login id =======")
            print(id)
            print ("================================")
        }
        

        //get the fit roomname
        let request = NSMutableURLRequest(URL: NSURL(string: "http://140.113.72.29:8100/api/uca/")!)
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
                        })
                    }
                    else{

                    let roomname = section["msg"] as? String
                        if roomname == nil{
                            print("room is nil")
                        }
                        else{
                            self.targetroom = roomname!
                            CustomTabController.sharedInstance.targetRoom = self.targetroom
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
    func alertnull(){
        let alertView = UIAlertController(title: "系統訊息", message: "系統中無用戶需要服務，請稍後再試",preferredStyle: .Alert)
        let action = UIAlertAction(title: "確認",style: UIAlertActionStyle.Default, handler: nil)
        alertView.addAction(action)
        alertView.actions
    }
    
    
    
    @IBAction func touchButtonPressed (sender:UIButton){
        if self.delegate?.shouldJoinRoom(targetroom, textInputCell: self) != nil{
            NSLog("Delegate was implemented");
        }
    }
    //Mark - UITextFieldDelegate Methods
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let isBackspace = string.isEmpty && range.length == 1
        var text:NSString = NSString(format: "%@%@", textField.text!,string)
        print(textField.text!)
        if (isBackspace && text.length>1){
            text=text.substringWithRange(NSMakeRange(0, text.length-2))
        }
        if (text.length>5){
            UIView.animateWithDuration(3.0, animations: { () -> Void in
                self.errorLabelHeightConstraint?.constant=0.0
                self.textFieldBorderView?.backgroundColor=UIColor(red: 66.0/2555.0, green: 133.0/255.0, blue: 244.0/255.0, alpha: 1.0)
                self.joinButton?.enabled=true
                self.layoutIfNeeded()
            })
            
        }
        else{
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.errorLabelHeightConstraint?.constant=0.0
                self.textFieldBorderView?.backgroundColor=UIColor(red: 66.0/2555.0, green: 133.0/255.0, blue: 244.0/255.0, alpha: 1.0)
                self.joinButton?.enabled=true
                self.layoutIfNeeded()
            })
        }
        
        return true
    }
    
    
}
