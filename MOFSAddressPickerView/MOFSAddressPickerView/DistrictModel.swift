//
//  DistrictModel.swift
//  MOFSAddressPickerView
//
//  Created by luoyuan on 16/3/13.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

import UIKit

class DistrictModel: NSObject {

    var name:String!;
    var code:String!;
    
    init(XML xml:GDataXMLElement) {
        self.name = xml.attributeForName("name").stringValue();
        self.code = xml.attributeForName("zipcode").stringValue();
    }
}
