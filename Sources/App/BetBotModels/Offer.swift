import Fluent
import FluentSQLite
import Foundation
import Vapor

struct Offer: Content, SQLiteUUIDModel, Migration {
    var id: UUID?
    var party: UUID // offeror of the wager
    var counterparty: UUID? //
    var wagerAmount: Int
    var wagerDescription: String
    var date: String
    var expirationDate: String?
}
