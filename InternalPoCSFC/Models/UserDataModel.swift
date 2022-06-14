//
//  UserDataModel.swift
//  InternalPoCSFC
//
//  Created by TECDATA ENGINEERING on 25/3/22.
//

import Foundation

struct UserDataModel{
    
    var dni: String?
    var telefono: String?
    var email: String?
    
    init(pDni: String? = nil, pTelefono: String? = nil, pEmail: String? = nil){
        self.dni = pDni
        self.telefono = pTelefono
        self.email = pEmail
    }
    
    func fetchUserDataModel() -> UserDataModel {
        return UserDataModel(pDni: "79815583V", pTelefono: "653940579", pEmail: "yourmail_9876@gmail.com")
    }
    
}

struct UserData: Encodable {
    var dni: String?
    var movil: String?
    var email: String?
    var term: Bool?
    var priv: Bool?
}
