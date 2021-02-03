//
//  CuentaView.swift
//  CovidTracker
//
//  Created by Andres Herrera on 2/1/21.
//

import SwiftUI

struct CuentaView: View {
    
    @Binding var userToken: Token
    @Binding var logueado: Bool
    @Binding var casos: [Caso]
    
    var creadoEl: String {
        Date.getFormattedDate(string: userToken.usuario!.creadoEl!, formatter: "MMM dd,yyyy")
    }
    
    var actualizadoEl: String {
        Date.getFormattedDate(string: userToken.usuario!.actualizadoEl!, formatter: "MMM dd,yyyy")
    }

    var body: some View {
        List {
            Section(header: VStack(alignment: .leading) {
                Text("INFORMACIÓN DE MI CUENTA")

            }) {
                Cell(leading: "Nombres", trailing: userToken.usuario!.nombres ?? "n/a")
                Cell(leading: "Nombre de usuario", trailing: userToken.usuario!.username  ?? "n/a")
                Cell(leading: "Fecha de Creación", trailing: creadoEl )
                Cell(leading: "Ultima Actualización", trailing: actualizadoEl)
           }
            Section(header: Text("GESTION DE CUENTA")) {
                Button("Cerrar Sesión", action: {cerrarSesion()})
                Button("Editar mis Datos", action: {})

                
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    func cerrarSesion () {
        self.userToken.token = ""
        logueado.toggle()
    }
}

struct Cell: View {
    var leading: String
    var trailing: String
    
    var body: some View {
        HStack {
            Text(leading)
            Spacer()
            Text(trailing)
                .foregroundColor(.secondary)
        }
    }
}
