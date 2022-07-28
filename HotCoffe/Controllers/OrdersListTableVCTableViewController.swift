//
//  OrdersListTableVCTableViewController.swift
//  HotCoffe
//
//  Created by Developer on 22/07/2022.
//

import UIKit

class OrdersListTableVCTableViewController: UITableViewController,AddCoffeOrderDelegate {

    var orderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrder()
    }
    private func populateOrder () {
        
        Webservice().load(resource: Order.all, completion: { [weak self] result in
            
            switch result {
            case .success(let orders):
                self?.orderListViewModel.orderList = orders.map(OrderViewModel.init)
                self?.tableView.reloadData()
            case.failure(let error):
                print(error)
            }
        })
    }
    // MARK: - AddCoffee Order Delegate
    func addCoffeOrderDidClose(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    func addCoffeOrderViewControllerDidSave(order: Order, controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        let orderViewModel = OrderViewModel(order: order)
        orderListViewModel.orderList.append(orderViewModel)
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListViewModel.orderList.count-1, section: 0)], with: .automatic)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       guard let navVC = segue.destination as? UINavigationController,
        let addOrderVC = navVC.viewControllers.first as? AddOrderViewController else  {
            fatalError("fatal error")
        }
        addOrderVC.coffeeOrderDelegate = self
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.orderList.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = self.orderListViewModel.orderViewModel(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size
        return cell
    }
    
}
