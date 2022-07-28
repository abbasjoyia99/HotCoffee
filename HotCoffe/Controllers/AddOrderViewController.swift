//
//  AddOrderViewController.swift
//  HotCoffe
//
//  Created by Developer on 22/07/2022.
//

import UIKit
protocol AddCoffeOrderDelegate {
    func addCoffeOrderViewControllerDidSave(order:Order,controller:UIViewController)
    func addCoffeOrderDidClose(controller:UIViewController)
}

class AddOrderViewController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var emailTextField:UITextField!
    var coffeeOrderDelegate:AddCoffeOrderDelegate!
   private var vm = AddCoffeeOrderViewModel()
    private var coffeeSizesSegmentControl:UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    private func setupUI() {
        self.coffeeSizesSegmentControl = UISegmentedControl(items: self.vm.sizes)
        self.view.addSubview(coffeeSizesSegmentControl)
        self.coffeeSizesSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        self.coffeeSizesSegmentControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive = true
        self.coffeeSizesSegmentControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    // MARK: - IBAction
    @IBAction func didClose(sender:UIButton) {
        if let delegate = coffeeOrderDelegate {
            delegate.addCoffeOrderDidClose(controller: self)
        }
    }
    @IBAction func save(sender:UIButton) {
        let name = self.nameTextField.text
        let email = self.emailTextField.text
        let selectedSize = self.coffeeSizesSegmentControl.titleForSegment(at: self.coffeeSizesSegmentControl.selectedSegmentIndex)
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            return
        }
        self.vm.name = name
        self.vm.email = email
        self.vm.type = self.vm.types[indexPath.row]
        self.vm.size = selectedSize
        
        Webservice().load(resource: Order.create(self.vm)) { result in
            
            switch result {
            case.failure(let error):
                print(error)
            case.success(let orders):
                guard let order = orders,
                      let delegate = self.coffeeOrderDelegate else {
                          fatalError("fatal error")
                      }
                DispatchQueue.main.async {
                    delegate.addCoffeOrderViewControllerDidSave(order: order, controller: self)
                }
                
            }
        }
    }

}
// MARK: - UITableView Delegate & Datasource
extension AddOrderViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.types.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coffeTypeCell", for: indexPath)
        cell.textLabel?.text = self.vm.types[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
