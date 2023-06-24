//
//  AsyncLoadableView.swift
//  WeatherApp
//
//  Created by Adit Hasan on 6/17/23.
//

import SwiftUI

struct AsyncLoadableView<Source: Loadable, Content: View>: View {
  var showSpinner: Bool? = false
  @ObservedObject var source: Source
  var content: (Source.Output) -> Content
  var errorAction: () -> Void
  init(showSpinner: Bool, source: Source, errorAction: @escaping () -> Void, @ViewBuilder content: @escaping (Source.Output) -> Content) {
    self.showSpinner = showSpinner
    self.source = source
    self.errorAction = errorAction
    self.content = content
  }
  
  var body: some View {
    switch source.state {
    case .failed(_):
        AnyView(Text("Server Error"))
    case .idle:
      EmptyView()
    case .loading:
      if showSpinner == true {
        ProgressView()
      }
    case .loaded(let output):
      content(output)
    }
  }
}
