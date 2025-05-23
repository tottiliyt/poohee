//
//  UserModel.swift
//  poohee
//
//  Created by Yuntao Li on 4/5/22.
//

import Foundation

public struct User {
    
    var uid, email, matching, current_match, match_similarity, verificationCode: String
    var available, new_match: Bool
    var profile: Profile
    var num_meet: Int
    
}
