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
        return UserDataModel(pDni: "33221100H", pTelefono: "111222333", pEmail: "myMail@mail.com")
    }
    
}

struct UserData: Encodable {
    var dni: String?
    var movil: String?
    var email: String?
    var term: Bool?
    var priv: Bool?
}
