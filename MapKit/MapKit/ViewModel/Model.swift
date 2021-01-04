//
//  Model.swift
//  MapKit_SwiftUI
//
//  Created by Maxim Granchenko on 04.01.2021.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    let id = UUID().uuidString
    let placemark: CLPlacemark
}
