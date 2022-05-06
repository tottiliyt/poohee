//
//  FirebaseManager.swift
//  poohee
//
//  Created by Will Zhao on 4/1/22.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManager: NSObject {

    let auth: Auth
    let storage: Storage
    let firestore: Firestore

    static let shared = FirebaseManager()

    override init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }

}
