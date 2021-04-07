//
//  Todo.swift
//  ProjectManager
//
//  Created by 김태형 on 2021/03/29.
//

import Foundation

struct Todo: Codable {
    let title: String
    let description: String
    let deadLine: Double
    
    enum CodingKeys: String, CodingKey {
        case title, description, deadLine
    }
    var convertedDate: String {
        return DateFormatter().convertToLocaleDate(deadLine)
    }
}
