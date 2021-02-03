//
//  LoginView.swift
//  CovidTracker
//
//  Created by Andres Herrera on 1/31/21.
//

import SwiftUI
struct LoginView: View {
    @State private var username: String = "chivopelado"
    @State private var password: String = "Raha8004"
    @State private var registrarse = false
    @State private var loginError = false
    @State private var verificando = false
    @State private var loadingText = "Autenticando.."
    
    @Binding var userToken: Token
    @Binding var logueado: Bool
    @Binding var casos: [Caso]
    
    @ObservedObject var token = Token()
    
    @ObservedObject var obtenerCaso = Consulta(
        url: URL(string: "http://127.0.0.1:8080/casos/propio")!,
        transform: { data in
            try? JSONDecoder().decode([Caso].self, from: data)
        }
    )
    
   // @State private var caso = [Caso]()
    
    var body: some View {
        ZStack {
            Color.white
            VStack(spacing: 20) {
                Text("CovidTracker")
                    .font(.largeTitle)
                    .foregroundColor(Color.black)
                Text("Ingrese sus credenciales")
                    .font(.callout)
                    .foregroundColor(Color.gray)
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(Color.gray)
                    TextField("Nombre de usuario", text: $username)
                        .foregroundColor(Color.black)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2)
                
                HStack {
                    Image(systemName: "key")
                        .foregroundColor(Color.gray)
                    SecureField("contraseña", text: $password)
                        .foregroundColor(Color.black)
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2)

                Button(action: {autenticar()}) {
                    Text("Ingresar")
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                
                Button(action: {registrarse.toggle()}) {
                    Text("Registrarse")
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
        .alert(isPresented: $loginError) {
            Alert(title: Text("Error"), message: Text("Existió un error al autenticar usuario, por favor verifique sus datos e intente nuevamente"), dismissButton: .default(Text("Reintentar")))
        }
        .sheet(isPresented: $registrarse) {
            RegistroView(registrarse: $registrarse, userToken: $userToken, logueado:$logueado, casos: $casos)
        }
    }
    func autenticar() {
        self.verificando = true
        Consulta<Token>.autenticar(username: username, password: password) { res in
            switch res {
                case .success(let token):
                    self.loadingText = "Verificando Caso.."
                    self.userToken = token
                    obtenerCaso.getConToken(token: userToken.token!){ res in
                        switch res {
                            case .success(let resCaso):
                                self.casos = resCaso
                                self.verificando = false
                                self.logueado.toggle()
                            case .failure(_):
                                self.verificando = false
                                self.loginError.toggle()
                        }
                    }
                case .failure(_):
                    self.verificando = false
                    self.loginError.toggle()
            }
            
        }
    }
}
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(logueado: .constant(false))
//    }
//}
