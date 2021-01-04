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
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        return Home()
    }
}
