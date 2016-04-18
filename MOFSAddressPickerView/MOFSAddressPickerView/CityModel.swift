//
//  CityModel.swift
//  MOFSAddressPickerView
//
//  Created by luoyuan on 16/3/13.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

import UIKit

class CityModel: NSObject {
    
    var name:String!;
    var list:Array<DistrictModel> = Array();

    init(XML xml:GDataXMLElement) {
        self.name = xml.attributeForName("name").stringValue();
        do {
            let cityList = try xml.nodesForXPath("district")
            for (var i = 0; i < cityList.count; i++) {
                let model = DistrictModel(XML: cityList[i] as! GDataXMLElement);
                self.list.append(model);
            }
        } catch {
            
        }
    }
}
