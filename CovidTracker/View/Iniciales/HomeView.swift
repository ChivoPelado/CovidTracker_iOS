//
//  HomeView.swift
//  CovidTracker
//
//  Created by Andres Herrera on 2/1/21.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0
    @Binding var userToken: Token
    @Binding var logueado: Bool
    @Binding var casos: [Caso]
    

    var body: some View {
        TabView(selection: $selectedTab) {
            CasoView(userToken: $userToken, casos: $casos)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
             .tag(0)
            
            MapaView(casos: $casos)
               .tabItem {
                   Image(systemName: "map.fill")
                   Text("Geolocalizacion")
               }
            .tag(1)
        
            CuentaView(userToken: $userToken, logueado: $logueado, casos: $casos)
               .tabItem {
                   Image(systemName: "person.fill")
                   Text("Mi Cuenta")
               }
            .tag(2)
        }.onAppear {
      //      print(userToken.token)
      //$      obtenerCaso.getConToken(token: userToken.token!)
                
          //  print(self.usuario?.nombres)
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    let usuario = Usuario(username: "username", id: "1223-123-123", nombres: "Name Lastname", creadoEl: "01/01/2020T00:00Hz", actualizadoEl: "01/01/2020T00:00Hz")
//    static var previews: some View {
//        HomeView(usuario: usuario)
//    }
//}
