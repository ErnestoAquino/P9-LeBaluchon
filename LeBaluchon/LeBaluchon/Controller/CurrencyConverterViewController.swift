//
//  CurrencyConverterViewController.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 23/04/2022.
//

import UIKit

class CurrencyConverterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonConvert.round()
    }
    @IBOutlet weak var euroTextField: UITextField!
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!
    @IBOutlet weak var buttonConvert: UIButton!
    

    @IBAction func currencySelector() {
        switch currencySegmentedControl.selectedSegmentIndex {
        case 0:
            print("Selected USD")
        case 1:
            print("Selected MXN")
        case 2:
            print("Selected JYP")
        case 3:
            print("Selected GBP")
        default: break
            
        }
        
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        euroTextField.resignFirstResponder()
    }
    
    @IBAction func tappedConvertButton() {
        CurrencyConverterService.getExchangeRate()
    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
