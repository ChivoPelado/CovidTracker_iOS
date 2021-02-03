//
//  NuevoCasoView.swift
//  CovidTracker
//
//  Created by Andres Herrera on 2/1/21.
//

import SwiftUI

struct NuevoCasoView: View {
    @State private var confirmado = false
    @State private var fechaInicio: Date = Date()
    @State private var fechaFin: Date = Date()
    @State private var nombreVacio = false
    @State private var casoInError = false
    @State private var verificando = false
    @Binding var nuevoCaso: Bool
    @Binding var userToken: Token
    @Binding var casos: [Caso]
    
    
    @ObservedObject var crearCaso = Consulta(
        url: URL(string: "http://127.0.0.1:8080/casos/nuevo")!,
        transform: { data in
            try? JSONDecoder().decode(Caso.self, from: data)
        }
    )
 
 
    var body: some View {
        ZStack {
            Color.white
            VStack(spacing: 20) {
                Text("CovidTracker")
                    .font(.largeTitle)
                    .foregroundColor(Color.black)
                Text("Formulario de registro")
                    .font(.callout)
                    .foregroundColor(Color.secondary)
                
                HStack {
                    Toggle(isOn: $confirmado, label: {
                        Text("Caso Confirmado?")
                    })
                    Text(confirmado ? "Si" : "No")
                }
                
         
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    DatePicker(selection: $fechaInicio, in: ...Date(), displayedComponents: .date) {
                        Text("Fecha de Prueba / Sospecha").font(.caption)
                    }

                        .foregroundColor(Color.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2)

                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    DatePicker(selection: $fechaFin, in: Date()..., displayedComponents: .date) {
                        Text("Fecha Fin de Cuarenten").font(.caption)
                    }

                        .foregroundColor(Color.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2)


                Button(action: { registro(fechaInicio: fechaInicio,
                                          fechaFin: fechaFin,
                                          usuarioId:  String((userToken.usuario?.id)!))
                    
                }) {
                    Text("Registrar Caso")
                        .padding()
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)

                
                Button(action: {nuevoCaso.toggle()}) {
                    Text("Cancelar")
    
                }
                
            }.padding(.horizontal,30)
            .padding()
            if verificando {
                Color.white.opacity(0.5)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2)
            }
        }
        .alert(isPresented: $casoInError) {
            Alert(title: Text("Error"), message: Text("Existió un error al registrar caso, por favor verifique sus datos e intente nuevamente"), dismissButton: .default(Text("Reintentar")))
        }
    }
    
    func registro(fechaInicio: Date, fechaFin: Date, usuarioId: String){
        self.verificando = true
        crearCaso.postConToken(token: userToken.token! , parametros: [
            "tipoCaso": (confirmado ? TipoCaso.Confirmado.rawValue : TipoCaso.Sospecha.rawValue),
            "fechaInicio": fechaStr(fecha: fechaInicio),
            "fechaFin": fechaStr(fecha: fechaFin),
            "usuarioId": String((userToken.usuario?.id)!)
        ]) { res in
            switch res {
                case .success(let resCaso):
                    self.casos.append(resCaso)
                    self.casos.first?.geolocalizacion = []
                    self.verificando = false
                    self.nuevoCaso = false
                case .failure( let error):
                    print(error.localizedDescription)
                    self.verificando = false
                    self.casoInError = true
            }
        }
    }
    
    func fechaStr(fecha: Date) -> String {
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime]
        return iso8601DateFormatter.string(from: fecha)
    }
}

