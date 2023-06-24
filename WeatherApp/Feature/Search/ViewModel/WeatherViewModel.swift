//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Adit Hasan on 6/17/23.
//

import MapKit
import Combine

class WeatherViewModel: ObservableObject, WeatherServiceProtocol {
    
    var apiSession: APISessionProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var weatherObject: WeatherObject?
    
    @Published var address = Address(cityName: "", stateName: "", country: "")
    
    private var persistenceController = PersistenceController.shared
    
    init(apiSession: APISessionProtocol = APISession(),
         localSearchItem: MKLocalSearchCompletion) {
        self.apiSession = apiSession
        self.extractAddress(result: localSearchItem)
    }
    
    init(apiSession: APISessionProtocol = APISession(),
         address: Item) {
        self.apiSession = apiSession
        self.address = Address(cityName: address.city ?? "", stateName: address.state ?? "", country: "")
        self.getWeatherDetail(lat: address.latitude, lon: address.longitude)
    }
    
    /// extracting selecting results and making it usable city and state name
    func extractAddress(result: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] (response, error) in
            guard let placemark = response?.mapItems.first?.placemark else {
                self?.address = Address(cityName: "", stateName: "", country: "")
                return
            }
            if let coordinate = placemark.location?.coordinate {
                self?.getWeatherDetail(lat: coordinate.latitude,
                                       lon: coordinate.longitude)
                self?.address.cityName = placemark.locality ?? ""
                self?.address.stateName = placemark.administrativeArea ?? ""
            }
            self?.addItem(placemark: placemark)
        }
    }
    
    /// Save recently selected  location
    ///  - Parameter placemark: selected item saving city, state,latitude and longitude to coredata
    ///
    
    private func addItem(placemark: CLPlacemark) {
        let viewContext = persistenceController.container.viewContext
        let newItem = Item(context: viewContext)
        newItem.timestamp = Date()
        newItem.city = placemark.locality ?? ""
        newItem.state = placemark.administrativeArea ?? ""
        newItem.latitude = placemark.location?.coordinate.latitude ?? 0.0
        newItem.longitude = placemark.location?.coordinate.longitude ?? 0.0
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    /// Default weather detail by location when service is on
    func getDefaultCoordinate() {
        LocationManager.shared.requestLocationAuthorizationCallback = { [weak self] (status, coordinateObject) in
            if [.authorizedAlways, .authorizedWhenInUse].contains(where: { $0 == status }) {
                guard let coordinate = coordinateObject else { return }
                self?.getWeatherDetail(lat: coordinate.latitude, lon: coordinate.longitude)
                print("Location Autorized")
            } else {
                print("Not Allowed")
            }
        }
    }
    
    /// Weather detaill
    ///  - Parameter lat: latitude
    ///  - Parameter lon: longitude
    ///
    func getWeatherDetail(lat: Double, lon: Double) {
        self.getWeatherDetailBy(lat: lat, lon: lon)
            .receive(on: DispatchQueue.main, options: nil)
            .sink { result in
                if case .failure(let error as NSError) = result {
                    print("Error with request: \(APIError.decodingError(error: error))")
                }
            } receiveValue: { [weak self] weatherObject in
                self?.weatherObject = weatherObject
            }.store(in: &cancellables)
    }
    
    /// Weather detaill
    ///  - Parameter city: city name
    ///
    func getWeatherDetail(by city: String) {
        self.getWeatherDetail(city: city).sink { result in
            if case .failure(let error as NSError) = result {
                print("Error with request: \(APIError.decodingError(error: error))")
            }
        } receiveValue: { [weak self] weatherObject in
            self?.weatherObject = weatherObject
        }.store(in: &cancellables)
    }
    
    /// Weather detaill
    ///  - Parameter city: city name
    ///  - Parameter state: State name
    ///
    func getWeatherDetail(by city: String, state: String) {
        self.getWeatherDetail(city: city).sink { result in
            if case .failure(let error as NSError) = result {
                print("Error with request: \(APIError.decodingError(error: error))")
            }
        } receiveValue: { [weak self] weatherObject in
            self?.weatherObject = weatherObject
        }.store(in: &cancellables)
    }
    
    /// Weather detaill
    ///  - Parameter city: city name
    ///  - Parameter state: State name
    ///  - Parameter country: country name
    ///
    func getWeatherDetail(by city: String, state: String, country: String) {
        self.getWeatherDetail(city: city, state: state, country: country)
            .sink { result in
                if case .failure(let error as NSError) = result {
                    print("Error with request: \(APIError.decodingError(error: error))")
                }
            } receiveValue: { [weak self] weatherObject in
                self?.weatherObject = weatherObject
            }
            .store(in: &cancellables)
    }
}
