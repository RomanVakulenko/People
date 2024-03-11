//
//  PersonModel.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import Foundation


struct PersonModel: Codable {
    let people: [PersonInfo]
}

struct PersonInfo: Codable {
    let id, avatarURL, firstName, lastName, userTag, department, position, birthday, phone: String
}
