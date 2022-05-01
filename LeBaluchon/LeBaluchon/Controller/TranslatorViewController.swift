//
//  TranslatorViewController.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 23/04/2022.
//

import UIKit

class TranslatorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var frenchTexField: UITextView!

    @IBAction func dismissKeyBoard(_ sender: UITapGestureRecognizer) {
        frenchTexField.resignFirstResponder()
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
