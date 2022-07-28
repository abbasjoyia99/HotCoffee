//
//  AddOrderViewModel.swift
//  HotCoffe
//
//  Created by Developer on 28/07/2022.
//

import Foundation

struct AddCoffeeOrderViewModel {
    
    var name:String?
    var email:String?
    var type:String?
    var size:String?
    
    var types:[String] {
        return CoffeeType.allCases.map{ $0.rawValue.capitalized}
    }
    
    var sizes:[String] {
        return CoffeeSize.allCases.map{ $0.rawValue.capitalized}
    }
}
