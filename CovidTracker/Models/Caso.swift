//
//  Caso.swift
//  CovidTracker
//
//  Created by Andres Herrera on 2/2/21.
//

import Foundation

enum TipoCaso: String {
    case Confirmado, Sospecha
}
class Caso: Codable, Identifiable {
    let fechaInicio: String?
    let id: String?
    var geolocalizacion: [Geolocalizacion]?
    let tipoCaso: String?
    let fechaFin: String?
    let usuarioId: UsuarioId?
    let creadoEl, actualizadoEl: String?

    init(fechaInicio: String?, id: String?, geolocalizacion: [Geolocalizacion]?, tipoCaso: String?, fechaFin: String?, usuarioId: UsuarioId?, creadoEl: String?, actualizadoEl: String?) {
        self.fechaInicio = fechaInicio
        self.id = id
        self.geolocalizacion = geolocalizacion
        self.tipoCaso = tipoCaso
        self.fechaFin = fechaFin
        self.usuarioId = usuarioId
        self.creadoEl = creadoEl
        self.actualizadoEl = actualizadoEl
    }
}

class UsuarioId: Codable {
    let id: String?
}
