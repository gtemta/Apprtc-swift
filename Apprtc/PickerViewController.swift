//
//  PickerViewController.swift
//  Apprtc
//
//  Created by IMF on 2016/9/27.
//  Copyright © 2016年 Dhilip. All rights reserved.
//

import UIKit



class PickerViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    let response = ["辨識完成且成功","相片過於模糊，無法辨識","環境光線不足，無法辨識","照片中無明確物體可供辨識","物體資訊不足無法辨識"]
    var whatResponse = "環境光線不足，無法辨識"
    
    //UIpickerDataSource必須實作的方法
    //UIpicker各列有多少行資料
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    //UIpickerDataSource必須實作的方法
    //UIPickerView各列有多少行資料
    func pickerView(_pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //設置第一列
        //返回陣列response的成員數量
        return response.count
    }
    
    
    //每個選項選擇使用的資料
    func pickerView(_pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return response[row]
    }
    
    
    //改變後選擇執行的動作
    func pickerView(_pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        whatResponse = response[row]
        print("選擇的是 \(whatResponse) ")
    }
    
    
}
