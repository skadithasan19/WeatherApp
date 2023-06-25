//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Adit Hasan on 6/24/23.
//

import XCTest
@testable import WeatherApp

import Combine
final class WeatherAppTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
//        let viewModel = WeatherViewModel()
//        viewModel.getWeatherDetail(lat: 30.591948, lon: -97.647030)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
