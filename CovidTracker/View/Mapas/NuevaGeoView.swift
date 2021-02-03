//
//  NuevaGeoView.swift
//  CovidTracker
//
//  Created by Andres Herrera on 2/2/21.
//

import SwiftUI
import MapKit

struct NuevaGeoView: View {
    
    @State private var referencia: String = ""
    @State private var latitud: String = ""
    @State private var longitud: String = ""
    @State private var nuevoGeoEnMapa = false
    @State private var verificando = false
    @State private var geoInError = false
    @State private var actualizando = false
    
    @Environment(\.presentationMode) var presentationMode
    
 //   @Binding var nuevoGeoregistro: Bool
    @Binding var casos: [Caso]
    @Binding var token: Token
    @Binding var registraGeolocalizacion: Bool
  //  @Binding var geo: [Geolocalizacion]
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude:  -0.953216072, longitude: -80.73362),
        span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
    
    private var casoId: String {
        (casos.first?.id)!
    }
    
    private var geolocalizacionId: String {
        casos.first?.geolocalizacion?.first?.id ?? ""
    }
    
    var body: some View {
        ZStack {
            Color.white
            VStack(spacing: 20) {
                Text("CovidTracker")
                    .font(.largeTitle)
                    .foregroundColor(Color.black)
                Text("Registro de Geolocalización")
                    .font(.callout)
                    .foregroundColor(Color.secondary)
                HStack {
                    Image(systemName: "map")
                        .foregroundColor(.secondary)
                    TextField("Lugar de Referencia", text: $referencia)
                        .foregroundColor(Color.black)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2)
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.secondary)
                    TextField("Latitud", text: $latitud)
                        .foregroundColor(Color.black)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2)

                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.secondary)
                    TextField("Longitud", text: $longitud)
                        .foregroundColor(Color.black)
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2)
                

                Button(action: {nuevoGeoEnMapa.toggle()}) {
                    Text("Seleccionar en Mapa")
                        .padding()
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                
                if actualizando {
                    Button(action: {actualizarGeolocalizacion()}) {
                        Text("Actualizar")
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .padding(.top, 20)
                } else {
                    Button(action: {crearGeolocalizacion()}) {
                        Text("Registrar")
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .padding(.top, 20)
                }

                
                if actualizando {
                    Button(action: {eliminarGeolocalizacion()}) {
                        Text("Eliminar")
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                   // .padding(.top, 20)
                }

                Button(action: {presentationMode.wrappedValue.dismiss()}) {
                    Text("Cancelar")
                }
                
            }.padding(.horizontal,30)
            .padding()
            .sheet(isPresented: $nuevoGeoEnMapa) {
                NuevoGeoMapaView(latitud: $latitud,
                                 longitud: $longitud,
                                 registro: $nuevoGeoEnMapa,
                                 region: $region)
            }
            
            if verificando {
                Color.white.opacity(0.5)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2)
            }

        }
        .alert(isPresented: $geoInError) {
            Alert(title: Text("Error"), message: Text("Existió un error al registrar geolocalización, por favor verifique sus datos e intente nuevamente"), dismissButton: .default(Text("Reintentar")))
        }
        .onAppear {
            if (self.casos.first?.geolocalizacion!.count)! > 0 {
                let latitud = (self.casos.first?.geolocalizacion?.first?.latitud)!
                let longitud = (self.casos.first?.geolocalizacion?.first?.longitud)!
                
                self.actualizando = true
                self.referencia = (self.casos.first?.geolocalizacion?.first?.referencia)!
                self.latitud = String(latitud)
                self.longitud = String(longitud)
                
                self.region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude:  latitud, longitude: longitud),
                    span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            }
        }
    }
    func eliminarGeolocalizacion() {
        self.verificando = true
        let crearCaso = Consulta(
            url: URL(string: "http://127.0.0.1:8080/geolocalizacion/eliminar/\(geolocalizacionId)")!,
            transform: { data in
                try? JSONDecoder().decode(Geolocalizacion.self, from: data)
            }
        )
        crearCaso.putConToken(token: token.token!, parametros: ["void":"void"]) { res in
            self.casos.first?.geolocalizacion?.removeAll()
            self.registraGeolocalizacion = false
            self.verificando = false
            presentationMode.wrappedValue.dismiss()
         //   self.nuevoGeoregistro = false
        }
    }
    func crearGeolocalizacion() {
        self.verificando = true
        let crearCaso = Consulta(
            url: URL(string: "http://127.0.0.1:8080/geolocalizacion/nuevo/\(casoId)")!,
            transform: { data in
                try? JSONDecoder().decode(Geolocalizacion.self, from: data)
            }
        )
        
        crearCaso.postConToken(token: token.token!, parametros: [
            "referencia": referencia,
            "latitud": Double(latitud) ?? 0.0,
            "longitud": Double(longitud) ?? 0.0
        ]) { res in
            switch res {
                case .success(let respuesta):
                    self.casos.first?.geolocalizacion!.append(respuesta)
                    self.verificando = false
                    self.registraGeolocalizacion = true
                 //   self.nuevoGeoregistro = false
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    print(error.localizedDescription)
                    self.verificando = false
                    self.geoInError = true
            }
        }
    }
    
    func actualizarGeolocalizacion() {
        self.verificando = true
        let crearCaso = Consulta(
            url: URL(string: "http://127.0.0.1:8080/geolocalizacion/modificar/\(geolocalizacionId)")!,
            transform: { data in
                try? JSONDecoder().decode(Geolocalizacion.self, from: data)
            }
        )
        
        crearCaso.putConToken(token: token.token!, parametros: [
            "referencia": referencia,
            "latitud": Double(latitud) ?? 0.0,
            "longitud": Double(longitud) ?? 0.0
        ]) { res in
            switch res {
                case .success(let respuesta):
                    self.casos.first?.geolocalizacion!.removeAll()
                    self.casos.first?.geolocalizacion!.append(respuesta)
                    self.verificando = false
                    self.registraGeolocalizacion = true
                   // self.nuevoGeoregistro = false
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    print(error.localizedDescription)
                    self.verificando = false
                    self.geoInError = true
            }
        }
    }
}

