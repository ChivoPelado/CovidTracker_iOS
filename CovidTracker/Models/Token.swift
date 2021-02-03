//
//  Token.swift
//  CovidTracker
//
//  Created by Andres Herrera on 2/1/21.
//

import Foundation
import SwiftUI

import Foundation


class Token: Codable, ObservableObject {
    @Published var token: String?
    @Published var usuario: Usuario?
    
    enum CodingKeys: CodingKey {
        case token, usuario
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
        usuario = try container.decode(Usuario.self, forKey: .usuario)
    }
    
    init(token: String? = "", usuario: Usuario? = nil) {
        self.token = token
        self.usuario = usuario
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token, forKey: .token)
        try container.encode(usuario, forKey: .usuario)
    }
}
