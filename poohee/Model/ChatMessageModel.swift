//
//  PublicUserModel.swift
//  poohee
//
//  Created by Will Zhao on 4/8/22.
//

import Foundation
import Firebase

public struct ChatMessage : Identifiable{
    
    public var id: String{documentId}
    
    var documentId, fromId, toId, text: String
    var stage: Int
    
    var timestamp: Timestamp
    
    init(documentId: String, data: [String:Any]){
        self.documentId = documentId
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.stage = data["stage"] as? Int ?? 2
    }
}
