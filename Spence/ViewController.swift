//
//  ViewController.swift
//  Spence
//
//  Created by Matteo Koczorek on 8/26/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

private let budgetSteps = 10

class ViewController: UIViewController {

    var localRepository: ILocalRepository = LocalRepository()
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.selectRow(Int(localRepository.monthlyBudget)/budgetSteps, inComponent: 0, animated: false)
        print("repo: \(localRepository.monthlyBudget)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func resetButtonPressed(_ sender: Any) {
        //localRepository.reset()
    }

}

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 350
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row*budgetSteps) \(localRepository.currency.symbol)"
    }
    
}

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        localRepository.monthlyBudget = Float(row*budgetSteps)
    }
    
}
