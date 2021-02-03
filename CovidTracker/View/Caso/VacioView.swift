//
//  VacioView.swift
//  CovidTracker
//
//  Created by Andres Herrera on 2/1/21.
//

import SwiftUI

struct VacioView: View {
    @State private var nuevoCaso = false
    @Binding var userToken: Token
    @Binding var casos: [Caso]
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3).ignoresSafeArea(.all)
            VStack(alignment: .center, spacing: 20) {
                Image(systemName: "staroflife")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 80)
                    .foregroundColor(.secondary)
                Text("No Reistra Caso")
                    .bold()
                    .font(.title)
                Button(action: {nuevoCaso.toggle()}) {
                    Text("Registre uno nuevo haciendo click aqui")
                        
                }
            }
        }
        .fullScreenCover(isPresented: $nuevoCaso, content: {
            NuevoCasoView(nuevoCaso: $nuevoCaso,
                          userToken: $userToken,
                          casos: $casos)
            }
        )
    }
}

