//
//  Usuario.swift
//  CovidTracker
//
//  Created by Andres Herrera on 1/31/21.
//

import Foundation

// MARK: - Usuario
class Usuario: Codable, ObservableObject {
    var username, id, nombres: String?
    var creadoEl, actualizadoEl: String?
    
    enum CodingKeys: CodingKey {
        case username, id, nombres, creadoEl, actualizadoEl
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        username = try container.decode(String.self, forKey: .username)
        id = try container.decode(String.self, forKey: .id)
        nombres = try container.decode(String.self, forKey: .nombres)
        creadoEl = try container.decode(String.self, forKey: .creadoEl)
        actualizadoEl = try container.decode(String.self, forKey: .actualizadoEl)
    }
    
    init(username: String? = "", id: String = "", nombres: String = "", creadoEl: String = "", actualizadoEl:String = "") {
        self.username = username
        self.id = id
        self.nombres = nombres
        self.creadoEl = creadoEl
        self.actualizadoEl = actualizadoEl
    }
//    init(token: String? = "", usuario: Usuario? = nil) {
//        self.token = token
//        self.usuario = usuario
//    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(id, forKey: .id)
        try container.encode(nombres, forKey: .nombres)
        try container.encode(creadoEl, forKey: .creadoEl)
        try container.encode(actualizadoEl, forKey: .actualizadoEl)
    }
}
