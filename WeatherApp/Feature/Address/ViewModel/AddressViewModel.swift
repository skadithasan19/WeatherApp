//
//  AddressViewModel.swift
//  WeatherApp
//
//  Created by Adit Hasan on 6/17/23.
//

import SwiftUI
import Combine
import MapKit

struct Address {
    var cityName: String
    var stateName: String
    var country: String
}

class AddressViewModel : NSObject, ObservableObject {
    @Published private(set) var locationResults : [MKLocalSearchCompletion] = []
    @Published var searchTerm = ""
    
    private var cancellables : Set<AnyCancellable> = []
    private var searchCompleter = MKLocalSearchCompleter()
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
        $searchTerm
            .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchItem in
                self?.searchCompleter.queryFragment = searchItem
            }.store(in: &cancellables)
    }
}

extension AddressViewModel : MKLocalSearchCompleterDelegate {
    /// Have all the search results
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.locationResults = completer.results
    }
    
    /// Make the results property empty for invalid results
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.locationResults = []
    }
}
