//
//  AddQuote.swift
//  Weather
//
//  Created by Michal Červenec on 19/05/2022.
//

import UIKit

class AddQuote: UIViewController {
    
    @IBOutlet var field: UITextField!
    @IBOutlet var button: UIButton!
    
    @IBAction func buttonTapped() {
        let defaults = UserDefaults.standard
        var arrayQuotes =  defaults.object(forKey: "Quotes") as? [String] ?? [String]()
        if let textToAdd = field?.text {
            arrayQuotes.append(textToAdd)
            print(textToAdd)
        }
        defaults.set(arrayQuotes, forKey: "Quotes")
        
        dismiss(animated: true)
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
