//
//  ChatModel.swift
//  poohee
//
//  Created by Will Zhao on 4/9/22.
//

import Foundation
import Firebase

public struct Chat : Identifiable{
    
    public var id: String{documentId}
    
    var documentId, fromId, toId, text, firstName, profileImageUrl: String
    
    var timestamp: Timestamp
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.string(for: timestamp.dateValue()) ?? ""
    }
    
    init(documentId: String, data: [String:Any]){
        self.documentId = documentId
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.firstName = data["first_name"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
    
    
    
}
