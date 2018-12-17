import Fluent
import FluentSQLite
import Foundation
import Vapor

struct User: Content, SQLiteUUIDModel, Migration {
    var id: UUID?
    var username: String?
    var phoneNumber: String
}


