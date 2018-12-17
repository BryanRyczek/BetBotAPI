import Fluent
import FluentSQLite
import Foundation
import Vapor

struct NFLGame: Content, SQLiteUUIDModel, Migration {
    var id: UUID?
    var homeTeam: String
    var awayTeam: String
    var startTime: String
    var favoredTeam: String? //Home or away or nil
    var pointsFavored: String
}
