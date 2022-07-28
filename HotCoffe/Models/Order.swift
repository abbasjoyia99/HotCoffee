//
//  Order.swift
//  HotCoffe
//
//  Created by Developer on 28/07/2022.
//

import Foundation


enum CoffeeType:String,Codable,CaseIterable {
    case cappuccino
    case latte
    case cortado
    case espressino
}

enum CoffeeSize:String,Codable,CaseIterable {
    case small
    case medium
    case large
}

struct Order:Codable {
    let name:String
    let email:String
    let type:CoffeeType
    let size:CoffeeSize
}
extension Order {
    static var all:Resource<[Order]> = {
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("error in geting url")
        }
        return Resource<[Order]>(url: url)
    }()
    
    static func create(_ vm:AddCoffeeOrderViewModel) ->Resource<Order?> {
       let order = Order(vm)
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("error in geting url")
        }
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("error encoding data")
            }
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = .post
        resource.boday = data
        return resource
    }
}

extension Order {
    init?(_ vm:AddCoffeeOrderViewModel) {
        guard let email = vm.email,
              let name = vm.name,
              let type = CoffeeType(rawValue: vm.type!.lowercased()),
              let size = CoffeeSize(rawValue: vm.size!.lowercased()) else {
                  return nil
              }
        self.email = email
        self.name = name
        self.type = type
        self.size = size
        
    }
}
