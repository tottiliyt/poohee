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
}
