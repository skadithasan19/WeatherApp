//
//  Loadable.swift
//  WeatherApp
//
//  Created by Adit Hasan on 6/17/23.
//

import SwiftUI

protocol Loadable: ObservableObject {
  associatedtype Output
  var state: LoadingState<Output> { get }
  func load()
}

enum LoadingState<Output> {
  case idle
  case failed(Error)
  case loaded(Output)
  case loading
}
