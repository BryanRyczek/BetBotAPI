import Fluent
import FluentSQLite
import Foundation
import Vapor

struct Wager: Content, SQLiteUUIDModel, Migration {
    var id: UUID?
    var party: UUID // offeror of the wager
    var counterparty: UUID? // acceptor of the wager
    var wagerAmount: Int
    var wagerDescription: String
    var dateOffered: String
    var dateAccepted: String?
}
