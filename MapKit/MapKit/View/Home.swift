//
//  Home.swift
//  MapKit
//
//  Created by Maxim Granchenko on 04.01.2021.
//

import SwiftUI
import CoreLocation

struct Home: View {
    
    @StateObject var mapModel = MapViewModel()
    @State var locationManager = CLLocationManager()
    
    var body: some View {
        ZStack {
            MapView()
                .environmentObject(mapModel)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search", text: $mapModel.searchTxt)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color(.systemGray4))
                    .cornerRadius(15)
                    
                    if !mapModel.places.isEmpty && mapModel.searchTxt != "" {
                        ScrollView(.vertical, showsIndicators: false, content: {
                            VStack(spacing: 15) {
                                ForEach(mapModel.places) { place in
                                    Text(place.placemark.name ?? "")
                                        .foregroundColor(Color(.label))
                                        .padding(.horizontal)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .onTapGesture {
                                            mapModel.selectedPlace(place: place)
                                        }
                                    
                                    Divider()
                                }
                            }
                            .padding(.top)
                            .background(Color(.systemGray4))
                            .cornerRadius(15)
                        })
                    }
                }
                .padding()
                
                Spacer()
                
                VStack {
                    Button(action: { mapModel.focusLocation() }, label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .foregroundColor(Color(.systemBlue))
                            .clipShape(Circle())
                    })
                    
                    Button(action: { mapModel.updateMapType() }, label: {
                        Image(systemName: mapModel.mapType == .standard ? "network" : "map")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .foregroundColor(Color(.systemBlue))
                            .clipShape(Circle())
                    })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
            }
        }
        .onAppear(perform: {
            locationManager.delegate = mapModel
            locationManager.requestWhenInUseAuthorization()
        })
        .alert(isPresented: $mapModel.permissionDenied, content: {
            Alert(title: Text("Permission Denied"),
                  message: Text("Plaese Enable Permission in App Settings"),
                  dismissButton: .default(Text("Go to Setting"),
            action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
        .onChange(of: mapModel.searchTxt, perform: { value in
            let delay = 0.3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if value == mapModel.searchTxt {
                    mapModel.searchQuery()
                } else {
                    
                }
            }
        })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        return Home()
    }
}
