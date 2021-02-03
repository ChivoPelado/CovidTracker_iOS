//
//  RegistroView.swift
//  CovidTracker
//
//  Created by Andres Herrera on 1/31/21.
//

import SwiftUI

struct RegistroView: View {
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var repassword: String = ""
    @State private var nombres: String = ""
    @State private var repasswordError = false
    @State private var nombreVacio = false
    @State private var usuarioError = false
    @State private var verificando = false
    @State private var loadingText = "Autenticando.."
    
    @Binding var registrarse: Bool
    @Binding var userToken: Token
    @Binding var logueado: Bool
    @Binding var casos: [Caso]
    
    @ObservedObject var registroRemoto = Consulta(
        url: URL(string: "http://127.0.0.1:8080/usuarios/registro")!,
        transform: { data in
            try? JSONDecoder().decode(Token.self, from: data)
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
                    Image(systemName: "person")
                        .foregroundColor(.secondary)
                    TextField("Nombres y Apellidos", text: $nombres)
                        .foregroundColor(Color.black)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2)
                
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.secondary)
                    TextField("Nombre de usuario", text: $name)
                        .foregroundColor(Color.black)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2)

                
                HStack {
                    Image(systemName: "key")
                        .foregroundColor(.secondary)
                    SecureField("contraseña", text: $password)
                        .foregroundColor(Color.black)
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2)
                
                HStack {
                    Image(systemName: "key")
                        .foregroundColor(.secondary)
                    SecureField("Repita contraseña", text: $repassword)
                        .foregroundColor(Color.black)
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2)

                Button(action: {
                    if password != repassword || password .isEmpty {
                        password = ""
                        repassword = ""
                        repasswordError.toggle()
                    } else if nombres .isEmpty {
                        nombreVacio.toggle()
                    } else if name .isEmpty || name.count < 6 {
                        usuarioError.toggle()
                    }
                    registro(nombres: nombres, username: name, password: password, repassword: repassword)
//                    registroRemoto.consulta(parametros: [
//                        "nombres": nombres,
//                        "username": name,
//                        "password": password
//                    ])
                }) {
                    Text("Registrarse")
                        .padding()
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .alert(isPresented: $repasswordError) {
                    Alert(title: Text("Error"), message: Text("Contraseña no coincide"), dismissButton: .default(Text("Reintentar")))
                }
                .alert(isPresented: $usuarioError) {
                    Alert(title: Text("Error"), message: Text("Campo usuario vacio o menor a 6 caracteres"), dismissButton: .default(Text("Reintentar")))
                }
                .alert(isPresented: $nombreVacio) {
                    Alert(title: Text("Error"), message: Text("Campo nombres vacio"), dismissButton: .default(Text("Reintentar")))
                }
                
                Button(action: {registrarse.toggle()}) {
                    Text("Cancelar")
    
                }
                
            }.padding(.horizontal,30)
            .padding()
            if verificando {
                Color.white.opacity(0.5)
                VStack(spacing: 20) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(2)
                    Text(loadingText)
                }
            }
        }
        
    }
    
    func registro(nombres: String, username: String, password: String, repassword: String){
        self.verificando = true
        registroRemoto.postSinToken(parametros: [
            "nombres": nombres,
            "username": username,
            "password": password
        ]) { res in
            switch res {
                case .success(let token):
                    self.casos.removeAll()
                    self.loadingText = "Verificando Caso.."
                    self.userToken = token
                    self.verificando = false
                    self.logueado = true
                    self.registrarse = false
                case .failure(_):
                    self.verificando = false
                 //   self.loginError.toggle()
            }
        }
    }
}


//struct RegistroView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegistroView(registrarse: .constant(false))
//    }
//}
