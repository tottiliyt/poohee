//
//  PublicUserModel.swift
//  poohee
//
//  Created by Will Zhao on 4/8/22.
//

import Foundation

public struct ChatMessage : Identifiable{
    
    public var id: String{documentId}
    
    var documentId, fromId, toId, text: String
    
    init(documentId: String, data: [String:Any]){
        self.documentId = documentId
        fromId = data["fromId"] as? String ?? ""
        toId = data["toId"] as? String ?? ""
        text = data["text"] as? String ?? ""
    }
}
