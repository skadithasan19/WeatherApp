//
//  WeatherApp.swift
//  WeatherApp
//
//  Created by Adit Hasan on 6/17/23.
//

import Foundation
import SwiftUI

@main
struct OrientationEXApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            AddressSearchView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
