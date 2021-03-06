//
//  ViewController.swift
//  BitcoinPriceTrackerApp
//
//  Created by Tiago Pestana on 15/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var lblPriceTitle: UILabel!
    @IBOutlet weak var lblPriceValue: UILabel!
    @IBOutlet weak var pickerCurrency: UIPickerView!
    
    var currencyArray: [String] = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]
    var currencySymbols: [String] = ["A$", "R$", "C$", "¥", "€", "£", "HKD$", "Rp", "₪", "₹", "¥", "Mex$", "kr", "$", "zł", "lei", "₽", "kr", "S$", "$", "R"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        pickerCurrency.delegate = self
        pickerCurrency.dataSource = self
        
        updateCurrency(index: 0)
    }
    
    func updateCurrency(index: Int)
    {
        Networking().getBtcValue(currency: currencyArray[index], onComplete:
            { value in
                self.lblPriceValue.text = "\(self.currencySymbols[index]) \(value)"
        })
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        updateCurrency(index: row)
    }
}

