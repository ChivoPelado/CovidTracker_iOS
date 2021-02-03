//
//  EliminarCasoView.swift
//  CovidTracker
//
//  Created by Andres Herrera on 2/3/21.
//

import SwiftUI

struct EliminarCasoView: View {
    
    @Binding var casos: [Caso]
    @Binding var token: Token
  //  @Binding var eliminarCasoDlg: Bool
    
    @State private var verificando = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var casoId: String {
        (casos.first?.id)!
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .foregroundColor(.orange)
                
                Text("Confirme que desea eliminar su caso?")
                    .font(.headline)
                Text("Es su responsabilidad verificar que su caso confirmado o sospechoso se confirme negativo antes de abandonar el proceso de confinamiento")
                    .frame(alignment: .center)
                
                Button(action: {eliminarCaso()}) {
                    Text("Eliminar Caso")
                        .padding()
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                
                
                Button(action: {presentationMode.wrappedValue.dismiss()}) {
                    Text("Cancelar")
                    
                }
                
            }.padding()
            if verificando {
                Color.white.opacity(0.5)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2)
            }
        }
    }
    func eliminarCaso() {
        self.verificando = true
        let crearCaso = Consulta(
            url: URL(string: "http://127.0.0.1:8080/casos/eliminar/\(casoId)")!,
            transform: { data in
                try? JSONDecoder().decode(Caso.self, from: data)
            }
        )
        crearCaso.putConToken(token: token.token!, parametros: ["void":"void"]) { res in
            self.casos.removeAll()
            self.verificando = false
            presentationMode.wrappedValue.dismiss()
        }
    }
}


