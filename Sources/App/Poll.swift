//
//  Poll.swift
//  App
//
//  Created by Bryan Ryczek on 11/29/18.
//

import Fluent
import FluentSQLite
import Foundation
import Vapor

struct Poll: Content, SQLiteUUIDModel, Migration {
    var id: UUID?
    var title: String
    var option1: String
    var option2: String
    var votes1: Int
    var votes2: Int
}
