//
//  OrderViewModel.swift
//  HotCoffe
//
//  Created by Developer on 28/07/2022.
//

import Foundation

class OrderListViewModel {
    var orderList:[OrderViewModel]
    init () {
        self.orderList = [OrderViewModel]()
    }
    func orderViewModel (at index:Int) -> OrderViewModel {
        return self.orderList[index]
    }
}

struct OrderViewModel {
    let order:Order
}

extension OrderViewModel {
    var name:String {
       return self.order.name
    }
    var email:String {
        return self.order.email
    }
    var type:String {
        return self.order.type.rawValue.capitalized
    }
    var size:String {
        return self.order.size.rawValue.capitalized
    }
}
