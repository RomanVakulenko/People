//
//  PersonModel.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import Foundation


struct PersonModel: Codable {
    let items: [PersonInfo]
}

struct PersonInfo: Codable {
    let id, avatarUrl, firstName, lastName,
        userTag, department, position, birthday, phone: String

    init() {
        self.id = ""
        self.avatarUrl = ""
        self.firstName = ""
        self.lastName = ""
        self.userTag = ""
        self.department = ""
        self.position = ""
        self.birthday = ""
        self.phone = ""
    }
}

//допустимый список department
//android
//ios
//design
//management
//qa
//back_office
//frontend
//hr
//pr
//backend
//support
//analytics
