//
//  UserModel.swift
//  poohee
//
//  Created by Yuntao Li on 4/5/22.
//

import Foundation

public struct User {
    
    var uid, email, profileImageUrl, matching, current_match, match_similarity: String
    var available: Bool
    var profile: Profile
    var num_meet: Int
    
}
