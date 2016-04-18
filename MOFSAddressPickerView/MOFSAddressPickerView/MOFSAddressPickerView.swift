//
//  MOFSAddressPickerView.swift
//  MOFSAddressPickerView
//
//  Created by luoyuan on 16/2/28.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

import UIKit

let UISCEEN_WIDTH = UIScreen.mainScreen().bounds.width;
let UISCEEN_HEIGHT = UIScreen.mainScreen().bounds.height;

protocol MOFSAddressPickerViewDelegate {

    func selectedAddress(province: String, city: String, area: String, id: String);
    func selectedAddressAtIndex(province_index: Int, city_index: Int, area_index: Int);
    
}


class MOFSAddressPickerView: UIPickerView,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var mofsDelegate:MOFSAddressPickerViewDelegate!

    var toolBar = UIToolbar();
    var containerView = UIView(); //背景View
    var commitBar:UIBarButtonItem!; //确定UIBarButtonItem
    var cancelBar:UIBarButtonItem!; //取消UIBarButtonItem
    
    var provinceArr:Array<Model> = Array();
    var areaArr:Array<ProvinceModel> = Array();
    var selectedIndex_province = 0; //选中的省
    var selectedIndex_city = 0; //选中的市
    var selectedIndex_area = 0; //选中的区
    
    /*
    *pickerView高度
    *默认216；
    */
    var height:CGFloat! {
        didSet {
            self.frame = CGRectMake(0, UISCEEN_HEIGHT - height, UISCEEN_WIDTH, height);
            toolBar.frame = CGRectMake(0, UISCEEN_HEIGHT - height - 44, UISCEEN_WIDTH, 44);
            containerView.frame = CGRectMake(0, 0, UISCEEN_WIDTH, UISCEEN_HEIGHT - height - 44);
        }
    }
    
    /*
    *cancelBar的title
    *默认为“取消”
    */
    var cancelBarTitle:String! {
        didSet {
            cancelBar.title = cancelBarTitle;
        }
    }
    
    /*
    *cancelBar的文字颜色
    *默认UIColor(hexString: "0079fe")
    */
    var cancelBarColor:UIColor! {
        didSet {
            cancelBar.tintColor = cancelBarColor;
        }
    }
    
    /*
    *commitBar的title
    *默认为“确定”
    */
    var commitBarTitle:String! {
        didSet {
            commitBar.title = commitBarTitle;
        }
    }
    
    /*
    *commitBar的文字颜色
    *默认UIColor(hexString: "0079fe")
    */
    var commitBarColor:UIColor! {
        didSet {
            commitBar.tintColor = commitBarColor;
        }
    }
    
    //MARK: - self.init
    override init(frame: CGRect) {
        var initialFrame:CGRect!;
        
        if (CGRectIsEmpty(frame)) {
            initialFrame = CGRectMake(0, UISCEEN_HEIGHT - 216, UISCEEN_WIDTH, 216);
        } else {
            initialFrame = frame;
        }
        initialFrame = CGRectMake(0, UISCEEN_HEIGHT - initialFrame.height, UISCEEN_WIDTH, initialFrame.height);
        super.init(frame: initialFrame);
        self.backgroundColor = UIColor(hexString: "#F6F6F6");
        self.delegate = self;
        self.dataSource = self;
        let globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQueue) { () -> Void in
            self.getData();
        }
        self.initToolBar();
        self.initContainerView();
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - getData
    func getData() {
        let path = NSBundle.mainBundle().pathForResource("area", ofType: "xml");
        var str = "";
        do {
           
            str = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding);
            let document = try GDataXMLDocument(XMLString: str, options: 0);
            let list = try document.nodesForXPath("root/province");
            for (var i = 0; i < list.count; i++) {
                let model = ProvinceModel(XML: list[i] as! GDataXMLElement);
                areaArr.append(model)
            }
            
        } catch {
       
        }
    
    }
    
    //MARK: - show
    func show() {
        let window = UIApplication.sharedApplication().keyWindow;
        window?.addSubview(containerView);
        window?.addSubview(self);
        window?.addSubview(toolBar);
    }
    
    //MARK: - initToolBar
    func initToolBar() {
        toolBar.frame = CGRectMake(0, UISCEEN_HEIGHT - self.frame.height - 44, UISCEEN_WIDTH, 44);
        
        commitBar = UIBarButtonItem(title: "    完成    ", style: UIBarButtonItemStyle.Done, target: self, action: "commitAction");
        commitBar.tintColor = UIColor(hexString: "0079fe");
        
        cancelBar = UIBarButtonItem(title: "    取消    ", style: UIBarButtonItemStyle.Done, target: self, action: "cancelAction");
        cancelBar.tintColor = UIColor(hexString: "0079fe");
        
        let nullBar = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: "");
        
        toolBar.items = [cancelBar,nullBar,commitBar];
        toolBar.backgroundColor = self.backgroundColor;
        
        let lineView = UIView(frame: CGRectMake(0, 43.5, UISCEEN_WIDTH, 0.5));
        lineView.backgroundColor = UIColor(hexString: "#D3D3D3");
        
        toolBar.addSubview(lineView);
        toolBar.bringSubviewToFront(lineView);
    }
    
    //MARK: - initContainerView
    func initContainerView() {
        containerView.frame = CGRectMake(0, 0, UISCEEN_WIDTH, UISCEEN_HEIGHT - self.frame.height - 44)
        containerView.backgroundColor = UIColor.blackColor();
        containerView.alpha = 0.4;
        containerView.userInteractionEnabled = true;
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cancelAction"));
    }
    
    //MARK: - commitAction
    func commitAction() {
        self.cancelAction();
        let province = areaArr[selectedIndex_province].name;
        var id = "";
        var city = "";
        var area = "";
        if (areaArr[selectedIndex_province].list.count > 0) {
            city = areaArr[selectedIndex_province].list[selectedIndex_city].name;
            //id = areaArr[selectedIndex_province].list[selectedIndex_city].id;
            if (areaArr[selectedIndex_province].list[selectedIndex_city].list.count > 0) {
                area = areaArr[selectedIndex_province].list[selectedIndex_city].list[selectedIndex_area].name;
                id = areaArr[selectedIndex_province].list[selectedIndex_city].list[selectedIndex_area].code;
            }
        }
        mofsDelegate.selectedAddress(province, city: city, area: area, id: id);
        mofsDelegate.selectedAddressAtIndex(selectedIndex_province, city_index: selectedIndex_city, area_index: selectedIndex_area);
    }
    
    //MARK: - cancelAction
    func cancelAction() {
        toolBar.removeFromSuperview();
        containerView.removeFromSuperview();
        self.removeFromSuperview();
    }

    //MARK: - UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch (component) {
        case 0:
            return areaArr.count;
            //return provinceArr.count;
        case 1:
            return areaArr[selectedIndex_province].list.count;
            //return provinceArr[selectedIndex_province].arr.count;
        case 2:
            if (areaArr[selectedIndex_province].list.count == 0) {
                return 0;
            }
            return areaArr[selectedIndex_province].list[selectedIndex_city].list.count;
//            if (provinceArr[selectedIndex_province].arr.count == 0) {
//                return 0;
//            }
//            return provinceArr[selectedIndex_province].arr[selectedIndex_city].arr.count;
        default:
            return 0;
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch (component) {
        case 0:
            return areaArr[row].name;
            //return provinceArr[row].name;
        case 1:
            return areaArr[selectedIndex_province].list[row].name;
//            return provinceArr[selectedIndex_province].arr[row].name;
        case 2:
            return areaArr[selectedIndex_province].list[selectedIndex_city].list[row].name;
//            return provinceArr[selectedIndex_province].arr[selectedIndex_city].arr[row].name;
        default:
            return nil;
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch (component) {
        case 0:
            selectedIndex_province = row;
            selectedIndex_city = 0;
            selectedIndex_area = 0;
            pickerView.reloadComponent(1);
            pickerView.reloadComponent(2);
            pickerView.selectRow(0, inComponent: 1, animated: false);
            pickerView.selectRow(0, inComponent: 2, animated: false);
        case 1:
            selectedIndex_city = row;
            selectedIndex_area = 0;
            pickerView.reloadComponent(2);
            pickerView.selectRow(0, inComponent: 2, animated: false);
        case 2:
            selectedIndex_area = row;
        default:
            break;
        }
    }

}
