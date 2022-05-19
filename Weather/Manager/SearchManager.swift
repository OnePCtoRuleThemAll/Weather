//
//  SearchManager.swift
//  Weather
//
//  Created by Michal Červenec on 19/05/2022.
//

import Foundation
import MapKit

typealias LocalSearchCopmletionHandler = (([Place]) -> Void)


class SearchManager: NSObject {
    
    
    private let searchCompleter = MKLocalSearchCompleter()

    private var searchCompletionHandler: LocalSearchCopmletionHandler?

    override init() {
        super.init()
        
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
    func getLocalSearch(from query: String, completion: @escaping LocalSearchCopmletionHandler) {
        self.searchCompletionHandler = completion
        
        if query.isEmpty {
            completion([])
        }
        
        searchCompleter.queryFragment = query
    }
}

struct Place {
    let city: String
    let country: String
}

extension SearchManager: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        let places = completer.results
            .filter { !$0.title.isEmpty }
            .map { $0.title.components(separatedBy: ",") }
            .filter { $0.count > 1 }
            .map { Place(city: $0[0], country: $0[1])}
        searchCompletionHandler?(places)
         print(places)
    }
}
