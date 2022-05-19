//
//  Quote.swift
//  Weather
//
//  Created by Michal Červenec on 19/05/2022.
//

import UIKit

class QuoteViewController: UIViewController {
    
    var arrayQuotes = [String]()
    
    @IBOutlet weak var quoteLable: UILabel!
    
    @IBAction func enterAction(_ sender: UIButton) {
        loadQuote()
    }
    
    @IBAction func newQuote(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "AddQuote", bundle: nil)
//        if let newQuoteController = storyboard.instantiateViewController(withIdentifier: "AddQuote") as?
//        AddQuote {
//            navigationController?.pushViewController(newQuoteController, animated: true)
//        }
        performSegue(withIdentifier: "AddSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveQuotes()
        loadQuote()
    }
    
    func loadQuote() {
        let defaults = UserDefaults.standard
        
        arrayQuotes =  defaults.object(forKey: "Quotes") as? [String] ?? [String]()
        
        quoteLable.text = arrayQuotes.randomElement()
    }
    
    func saveQuotes() {
        let defaults = UserDefaults.standard
        let array = defaults.object(forKey: "Quotes") as? [String] ?? [String]()
        if !array.isEmpty {
            return
        }
        let myQuotes = ["If you want to see the sunshine, you have to weather the storm.", "Nature is so powerful, so strong. Capturing its essence is not easy - your work becomes a dance with light and the weather. It takes you to a place within yourself.", "Sunshine is delicious, rain is refreshing, wind braces us up, snow is exhilarating; there is really no such thing as bad weather, only different kinds of good weather.", "Wherever you go, no matter what the weather, always bring your own sunshine.", "Prepare yourself so that you can be a rainbow in somebody else's cloud.", "Conversation about the weather is the last refuge of the unimaginative.", "People don't notice whether it's winter or summer when they're happy.", "Advice is like snow; the softer it falls the deeper it sinks into the mind .", "Raise your words, not your voice. It is rain that grows flowers, not thunder.", "It is best to read the weather forecast before praying for rain.", "Don't forget: Beautiful sunsets need cloudy skies."]
        defaults.set(myQuotes, forKey: "Quotes")
    }
}
