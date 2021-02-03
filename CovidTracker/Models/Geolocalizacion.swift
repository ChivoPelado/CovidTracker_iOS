//
//  Geolocalizacion.swift
//  CovidTracker
//
//  Created by Andres Herrera on 2/2/21.
//

import Foundation
import MapKit

class Geolocalizacion: Codable , Identifiable{
    let latitud: Double?
    let id, referencia: String?
    let longitud: Double?
    let casoId: CasoId?
    let creadoEl, actualizadoEl: String?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitud ?? 0.0, longitude: longitud ?? 0.0)
    }

    init(latitud: Double?, id: String?, referencia: String?, longitud: Double?, casoId: CasoId?, creadoEl: String?, actualizadoEl: String?) {
        self.latitud = latitud
        self.id = id
        self.referencia = referencia
        self.longitud = longitud
        self.casoId = casoId
        self.creadoEl = creadoEl
        self.actualizadoEl = actualizadoEl
    }
}


// MARK: - Caso
class CasoId: Codable {
    let id: String?

    init(id: String?) {
        self.id = id
    }
}
