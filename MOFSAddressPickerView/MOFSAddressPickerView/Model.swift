//
//  Model.swift
//  MOFSAddressPickerView
//
//  Created by luoyuan on 16/2/28.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

import UIKit

class Model: NSObject {

    var id:String!;
    
    var name:String!;
    
    var arr:Array<Model> = Array();
    
    init(json j:JSON) {
        self.id = j["id"].stringValue;
        self.name = j["name"].stringValue;
        for (_,obj) in j[j["name"].stringValue] {
            let model = Model(json: obj);
            self.arr.append(model);
        }
    }
    
}
