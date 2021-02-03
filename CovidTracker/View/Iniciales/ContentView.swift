//
//  ContentView.swift
//  CovidTracker
//
//  Created by Andres Herrera on 1/31/21.
//

import SwiftUI

struct ContentView: View {

    @State private var logueado = false
    @State private var userToken = Token()
    @State private var casos = [Caso]()
   // @ObservedObject var token = Token()
   // @ObservedObject var usuario = Usuario()
    
    var body: some View {
        if logueado {
            withAnimation {
                HomeView(userToken: $userToken, logueado: $logueado, casos: $casos)
            }
        } else {
            withAnimation{
                LoginView(userToken: $userToken, logueado: $logueado, casos: $casos)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
