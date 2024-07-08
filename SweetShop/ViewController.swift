//
//  ViewController.swift
//  SweetShop
//
//  Created by Mehtab Singh on 2024-07-04.
//

import UIKit

// Struct to store details of each purchase
struct Purchase {
    let product: Donut
    let quantity: Int
    let totalValue: Double
    let timestamp: Date
}

class ViewController: UIViewController {
    
    @IBOutlet weak var selectedProductLabel: UILabel!
    @IBOutlet weak var selectedProductImage: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    let store = Store() // Instance of Store to access donuts
    var selectedProduct: Donut? // Currently selected product
    var selectedQuantity: Int = 1 // Quantity selected by user
    
    var purchaseHistory: [Purchase] = [] // Array to store purchase history
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup pickerView's delegate and data source
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Initialize with the first product in the list if available
        if let firstProduct = store.donuts.first {
            selectedProduct = firstProduct
            selectedProductLabel.text = firstProduct.title
            selectedProductImage.image = UIImage(named: firstProduct.imageName)
            selectedQuantity = 1
            updateTotalPriceLabel() // Update the total price label
        }
    }
    
    // Function to update the total price label based on selected product and quantity
    func updateTotalPriceLabel() {
        guard let product = selectedProduct else {
            totalPriceLabel.text = "Total Price: $0.00"
            return
        }
        
        let totalPrice = Double(selectedQuantity) * product.price
        totalPriceLabel.text = String(format: "Total Price: $%.2f", totalPrice)
    }
    
    // Action triggered when the Buy button is pressed
    @IBAction func buyButtonPressed(_ sender: UIButton) {
        guard let product = selectedProduct else { return }
        
        let totalPrice = Double(selectedQuantity) * product.price
        // Create a new purchase record and add it to the history
        let purchase = Purchase(product: product, quantity: selectedQuantity, totalValue: totalPrice, timestamp: Date())
        purchaseHistory.append(purchase)
        
        // Show a success alert to the user
        let alert = UIAlertController(title: "Success", message: "Thank You for purchasing \(selectedQuantity) \(product.shortName) donut(s) for a total of $\(totalPrice).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// Conform to UIPickerViewDataSource and UIPickerViewDelegate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Number of components (columns) in the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // Number of rows in each component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return store.donuts.count
        } else {
            return selectedProduct?.availabilityCount ?? 0
        }
    }
    
    // Height for each row in the picker view
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    // Width for each component in the picker view
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return pickerView.frame.width * 0.5
        } else {
            return pickerView.frame.width * 0.2
        }
    }
    
    // View for each row in the picker view
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if component == 0 {
            let rowView: PickerRowView
            
            if let view = view as? PickerRowView {
                rowView = view
            } else {
                rowView = PickerRowView()
            }
            
            let product = store.donuts[row]
            rowView.configure(with: product) // Configure the row view with product details
            
            return rowView
        } else {
            let label = UILabel()
            label.textAlignment = .center
            label.text = "\(row + 1)" // Display quantity
            return label
        }
    }
    
    // Handle selection in the picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedProduct = store.donuts[row]
            selectedProductLabel.text = store.donuts[row].title
            selectedProductImage.image = UIImage(named: store.donuts[row].imageName)
            pickerView.reloadComponent(1) // Reload the second component to update quantity
            pickerView.selectRow(0, inComponent: 1, animated: true) // Reset quantity to 1
            selectedQuantity = 1
            totalPriceLabel.text = "Total Price: $\(store.donuts[row].price)"
        } else {
            selectedQuantity = row + 1
            updateTotalPriceLabel() // Update the total price label based on new quantity
        }
    }
}
