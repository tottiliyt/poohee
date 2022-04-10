//
//  ProfileModel.swift
//  poohee
//
//  Created by Yuntao Li on 4/5/22.
//

import Foundation


public struct Profile : Identifiable{
    
    public var id : String {uid}
    
    var uid, first_name, gender, goal, graduation_year, last_name, political, religious, profileImageUrl: String
    
    var career_interests, hobbies, majors, questionnaire: [String]
    
    init (uid: String, data: [String: Any]) {
        self.uid = uid
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.first_name = data["first_name"] as? String ?? ""
        self.gender = data["gender"] as? String ?? ""
        self.goal = data["goal"] as? String ?? ""
        self.graduation_year = data["graduation_year"] as? String ?? ""
        self.last_name = data["last_name"] as? String ?? ""
        self.political = data["political"] as? String ?? ""
        self.religious = data["religious"] as? String ?? ""
        
        self.career_interests = data["career_interests"] as? [String] ?? []
        self.hobbies = data["hobbies"] as? [String] ?? []
        self.majors = data["majors"] as? [String] ?? []
        self.questionnaire = data["questionnaire"] as? [String] ?? []
    }
}
