//
//  AddressSearchView.swift
//  WeatherApp
//
//  Created by Adit Hasan on 6/17/23.
//

import SwiftUI

struct AddressSearchView: View {
    @ObservedObject var addressViewModel = AddressViewModel()
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    @Environment(\.dismissSearch) private var dismissSearch
    
    @State var showSearchBar = false
    
    var body: some View {
        NavigationView {
            
            VStack {
                TextField("Search ...", text: $addressViewModel.searchTerm)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
                
                List {
                    if items.count > 0 {
                        Section("Previous") {
                            ForEach(items) { item in
                                NavigationLink(destination: NavigationLazyView(WeatherView(viewModel: WeatherViewModel(address: item))), label: {
                                    Text("\(item.city ?? ""), \(item.state ?? "")")
                                })
                            }
                            .onDelete(perform: deleteItems)
                        }
                    }
                    if addressViewModel.locationResults.count > 0 {
                        Section("New Results") {
                            ForEach(addressViewModel.locationResults, id: \.self) { location in
                                NavigationLink(destination: NavigationLazyView(WeatherView(viewModel: WeatherViewModel(localSearchItem: location))).onAppear{
                                    dismissSearch()
                                }) {
                                    VStack(alignment: .leading) {
                                        Text(location.title)
                                        Text(location.subtitle)
                                            .font(.system(.caption))
                                    }
                                }.buttonStyle(PlainButtonStyle())
                                
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Address"), displayMode: .inline)
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.city = "Chicago"
            newItem.state = "IL"
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


