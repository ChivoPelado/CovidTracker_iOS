//
//  CasoView.swift
//  CovidTracker
//
//  Created by Andres Herrera on 2/1/21.
//

import SwiftUI
import CircularProgress

struct CasoView: View {
    
    @Binding var userToken: Token
    @Binding var casos: [Caso]
    @State private var nuevoGeoregistro = false
    @State private var nuevaFechaFin = Date()
   // @State private var eliminarCasoDlg = false
   // @State private var geo = [Geolocalizacion]()
    @State var activeSheet: ActiveSheet?
    
    @State private var registraGeolocalizacion = false
    
    var diasConfinado: Int {
        let fmt = ISO8601DateFormatter()
        let date1 = fmt.date(from: (casos.first?.fechaInicio)!)!
        return Calendar.current.dateComponents([.day], from: date1, to: Date()).day!
    }
    var totalDiasConfinamiento: Int {
        let fmt = ISO8601DateFormatter()
        let date1 = fmt.date(from: (casos.first?.fechaInicio)!)!
        let date2 = fmt.date(from: (casos.first?.fechaFin)!)!
        return Calendar.current.dateComponents([.day], from: date1, to: date2).day!
    }
    
    var progreso: CGFloat{
        return CGFloat(diasConfinado)/CGFloat(totalDiasConfinamiento)
    }
    
    var testPositivo: Bool {
        casos.first?.tipoCaso == TipoCaso.Confirmado.rawValue
    }
    
    var fechaInicio: String {
        Date.getFormattedDate(string: casos.first!.fechaInicio!,
                              formatter: "EEE, MMM dd,yyyy")
    }
    
    var fechaFin: String {
        Date.getFormattedDate(string: casos.first!.fechaFin!,
                              formatter: "EEE, MMM dd,yyyy")
    }
    
    @ObservedObject var obtenerCaso = Consulta(
        url: URL(string: "http://127.0.0.1:8080/casos/propio")!,
        transform: { data in
            try? JSONDecoder().decode([Caso].self, from: data)
        }
    )

    var body: some View {
        if casos.isEmpty {
            VacioView(userToken: $userToken, casos: $casos)
        } else {
            VStack {
                VStack(spacing: 10) {
                    Text("CovidTracker")
                        .font(.largeTitle)
                        .foregroundColor(Color.black)
                        .padding(.bottom, 15)
                    Text((userToken.usuario?.nombres)!)
                        .font(.title)
                        .padding(.bottom, -2)
                    Text(testPositivo ? "CASO REPORTAVO: POSITIVO" : "CASO REPORTADO: SOSPECHA")
                        .font(.caption)
                        .foregroundColor(testPositivo ? Color.red : Color.orange)
                        .bold()
                    CircularProgressView(
                            count: diasConfinado,
                            total: totalDiasConfinamiento,
                            progress: progreso,
                            lineWidth: 20)
                        .padding(8)
                        .frame(width: 250, height: 250, alignment: .center
                        )
                    Text("Dias restantes de confinamiento")
                        .font(.callout)
                    HStack {
                        VStack {
                            Text("Fecha de Inicio:")
                                .font(.body)
                            Text(fechaInicio).bold()
                        }
                        .padding(.leading, 20)
                        Spacer()
                        VStack {
                            Text("Fecha Fin:")
                                .font(.body)
                            Text(fechaFin).bold()
                        }
                        .padding(.trailing, 20)
                    }
                }
                VStack(alignment: .center){
                    DatePicker("Modificar Confinamiento", selection: $nuevaFechaFin, in: strDate(str: casos.first!.fechaFin!)..., displayedComponents: .date)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color(UIColor.systemGray5))
                        .foregroundColor(Color.blue)
                        .cornerRadius(10)
                    
                    Button("Prueba / Sospecha Negativa", action: {activeSheet = .second})
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                    
                    Button(defineBtnTexto(), action: {activeSheet = .first})
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(defineBtnColor())
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                .padding(50)
            }
            .sheet(item: $activeSheet) { item in
                
                switch item {
                    case .first:
                        NuevaGeoView(
                                     casos: $casos,
                                     token: $userToken,
                                     registraGeolocalizacion: $registraGeolocalizacion)
                                    // geo: $geo)
                    case .second:
                        EliminarCasoView(casos: $casos, token: $userToken)
                }

            }
//            .sheet(isPresented: $eliminarCasoDlg) {
//                EliminarCasoView(casos: $casos, token: $userToken, eliminarCasoDlg: $eliminarCasoDlg)
//            }
            .onAppear {
                if (casos.first?.geolocalizacion!.count)! > 0 {
                    self.registraGeolocalizacion = true
                }
            }
        }
    }
    func defineBtnTexto () -> String {
        if registraGeolocalizacion {
            return "Editar Geolocalización"
        } else  {
            return "Agregar Geolocalización"
        }
    }
    func defineBtnColor() -> Color {
        if registraGeolocalizacion {
            return .orange
        } else  {
            return .green
        }
    }
    func strDate(str: String) -> Date {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: str)!
    }
}


enum ActiveSheet: Identifiable {
    case first, second
    
    var id: Int {
        hashValue
    }
}
