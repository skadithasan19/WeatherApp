//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Adit Hasan on 6/17/23.
//

import UIKit
import SwiftUI
import Combine

struct WeatherView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    var viewModel: WeatherViewModel
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }
   
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = WeatherViewController(viewModel: viewModel)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}


class WeatherViewController: UIViewController {
    
    
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var temperatureLbl: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var highestTmpLbl: UILabel!
    
    @IBOutlet weak var lowestTmpLbl: UILabel!
    
    @IBOutlet weak var feelsLikeLbl: UILabel!
    
    @IBOutlet weak var pressureLbl: UILabel!
    
    @IBOutlet weak var WindLbl: UILabel!
    
    @IBOutlet weak var humidityLbl: UILabel!
    
    @IBOutlet weak var Visibility: UILabel!
    
    @IBOutlet weak var sunriseLbl: UILabel!
    
    @IBOutlet weak var sunsetLbl: UILabel!
    
    @IBOutlet weak var statusIcon: UIImageView!
    
    var viewModel: WeatherViewModel?
    
    private var cancellables : Set<AnyCancellable> = []
    
    init(viewModel: WeatherViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel?.$weatherObject
            .receive(on: RunLoop.main, options: nil)
            .sink { [weak self] weather in
                self?.addressLbl.text = "\(self?.viewModel?.address.cityName ?? ""), \(self?.viewModel?.address.stateName ?? "")"
                self?.temperatureLbl.text = weather?.main?.temp.convertTemp()
                self?.highestTmpLbl.text = "↑" + (weather?.main?.temp_max.convertTemp() ?? "")
                self?.lowestTmpLbl.text = "↓" + (weather?.main?.temp_min.convertTemp() ?? "")
                self?.descriptionLabel.text = weather?.weather?.first?.description.uppercased()
                
                self?.humidityLbl.text = "\(weather?.main?.humidity ?? 0)%"
                self?.feelsLikeLbl.text = weather?.main?.feels_like.convertTemp()
                self?.pressureLbl.text = "\(weather?.main?.pressure ?? 0)"
                self?.WindLbl.text = "\(((weather?.wind?.speed ?? 0) * 2.237).roundedBy(toPlaces: 2))"
                self?.Visibility.text = weather?.visibility?.convertDistance()
                if let sys = weather?.sys {
                    let sunset = Date(timeIntervalSince1970: TimeInterval(sys.sunset))
                    self?.sunsetLbl.text = sunset.getFormattedDate(format: "hh:mm a")
                    let sunrise = Date(timeIntervalSince1970: TimeInterval(sys.sunrise))
                    self?.sunriseLbl.text = sunrise.getFormattedDate(format: "hh:mm a")
                }
                
                if let url = weather?.weather?.first?.url {
                    self?.statusIcon.downloaded(from: url)
                }
            }.store(in: &cancellables)
    }
}


