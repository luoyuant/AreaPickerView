//
//  ViewController.swift
//  MOFSAddressPickerView
//
//  Created by luoyuan on 16/2/28.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,MOFSAddressPickerViewDelegate {

    var lb:UILabel!;
    
    var pickerView:MOFSAddressPickerView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        pickerView = MOFSAddressPickerView();
        
        pickerView.mofsDelegate = self;
        
        lb = UILabel(frame: CGRectMake(0, 100, UISCEEN_WIDTH, 44));
        lb.text = "点击选择地址";
        lb.textAlignment = NSTextAlignment.Center;
        lb.userInteractionEnabled = true;
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "show"))
        
        self.view.addSubview(lb);
    }

    //MARK: - show
    func show() {
        pickerView.show();
    }
    
    //MARK: - MOFSAddressPickerViewDelegate
    func selectedAddress(province: String, city: String, area: String, id: String) {
        lb.text = province + city + area + id
    }
    
    func selectedAddressAtIndex(province_index: Int, city_index: Int, area_index: Int) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

