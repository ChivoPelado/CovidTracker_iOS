//
//  NuevoGeoMapaView.swift
//  CovidTracker
//
//  Created by Andres Herrera on 2/2/21.
//

import SwiftUI
import MapKit

struct NuevoGeoMapaView: View {
    
    @Binding var latitud: String
    @Binding var longitud: String
    @Binding var registro: Bool
    @Binding var region: MKCoordinateRegion
    
//    @State var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude:  -1.831239, longitude: -78.183406),
//        span: MKCoordinateSpan(latitudeDelta: 6, longitudeDelta: 6))
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region)
                .edgesIgnoringSafeArea(.all)
            Image(systemName: "mappin.and.ellipse")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.red)
                .frame(width: 40)
                
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        self.latitud = String(region.center.latitude)
                        self.longitud = String(region.center.longitude)
                        registro = false
                    }) {
                        Image(systemName: "checkmark")
                    }
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding([.trailing, .bottom])
                    
                    Button(action: {registro = false}) {
                        Image(systemName: "xmark")
                    }
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding([.trailing, .bottom])

                }
            }
        }
    }
}
