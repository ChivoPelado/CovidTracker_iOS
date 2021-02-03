//
//  MapaView.swift
//  CovidTracker
//
//  Created by Andres Herrera on 2/1/21.
//

import SwiftUI
import MapKit

struct MapaView: View {
    
    @State private var casosPublicos = [Caso]()
    @Binding var casos: [Caso]
    

    @State var coordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -0.953216072, longitude: -80.73362),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    var body: some View {
        ZStack {
            Map(coordinateRegion: $coordinateRegion, annotationItems: casosPublicos){ caso in
                
                MapMarker(coordinate:
                            (caso.geolocalizacion?.first?.coordinate)!,
                          tint: (caso.id == casos.first?.id) ? Color.green : Color.red)
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {descargarGeolocaciones()}
            VStack {
                HStack {
                    Spacer()
                    Button(action: {descargarGeolocaciones()}) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding([.trailing, .bottom])
                }
                Spacer()
            }
        }
    }
    func descargarGeolocaciones() {
        self.casosPublicos.removeAll()
        let obtenerGeolocalizacion = Consulta(
            url: URL(string: "http://127.0.0.1:8080/casos/registrados")!,
            transform: { data in
                try? JSONDecoder().decode([Caso].self, from: data)
            }
        )
        obtenerGeolocalizacion.getConToken(token: "no token"){ res in
            switch res {
            case .success(let resCaso):
                resCaso.forEach { caso in
                    if caso.geolocalizacion!.count > 0 {
                        self.casosPublicos.append(caso)
                    }
                }
            case .failure(_):
                print ("error")
            }
        }
    }
}
