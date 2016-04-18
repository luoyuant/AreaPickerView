用法：

1.var pickerView = MOFSAddressPickerView();

2.pickerView.mofsDelegate = self;

显示地址调用：

pickerView.show();

Delegate：

func selectedAddress(province: String, city: String, area: String, id: String) {
        
}
    
func selectedAddressAtIndex(province_index: Int, city_index: Int, area_index: Int) {
        
  
}
