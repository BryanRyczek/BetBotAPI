import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "it works! what next?"
    }
    
    //MARK : user routes
    router.post(User.self, at: "users", "create") {req, user -> Future<User> in
        return user.save(on:req)
    }
    
    router.get("users") { req -> Future<[User]> in
        return User.query(on: req).all()
    }
    
    router.get("users", UUID.parameter) { req -> Future<User> in
        let id = try req.parameters.next(UUID.self)
        return try User.find(id, on: req).map(to: User.self) { user in
            guard var user = user else {
                throw Abort(.notFound)
            }
            return user
        }
    }
    
    router.delete("users", UUID.parameter) { req -> Future<HTTPStatus> in
        let id = try req.parameters.next(UUID.self)
        return try User.find(id, on: req).flatMap(to: HTTPStatus.self) { user in
            guard let user = user else {
                throw Abort(.notFound)
            }
            return user.delete(on: req).transform(to: HTTPStatus.noContent)
        }
    }
    
    //WAGERS
    //create a wager
    router.post(Wager.self, at: "wagers", "create") {req, wager -> Future<Wager> in
        return wager.save(on:req)
    }
    
    //accept a wager
    router.post("wagers", "accept", UUID.parameter, UUID.parameter) { (req) -> Future<Wager> in
        let id = try req.parameters.next(UUID.self)
        let counterParty = try req.parameters.next(UUID.self)
        return try Wager.find(id, on: req).map(to: Wager.self) { wager in
            guard var wager = wager else {
                throw Abort(.notFound)
            }
            if wager.party == counterParty {
                throw Abort(.badRequest)
            }
            wager.counterparty = counterParty
            wager.dateAccepted = Date().stringDate
            return wager
        }.save(on: req)
    }
    
    //get all wagers
    router.get("wagers") { req -> Future<[Wager]> in
        return Wager.query(on: req).all()
    }
    
    //get all wagers for User
    router.get("wagers", UUID.parameter, "users") { req -> Future<[Wager]> in
        let id = try req.parameters.next(UUID.self)
        //let w = Wager.query(on: req).filter(\.party == id).all().flatMap()
        return Wager.query(on: req).all().flatMap(to: [Wager].self) { wagers in
            return req.future(wagers.filter({ (wager) -> Bool in
                if wager.party == id {
                    return true
                }
                return false
            }))
        }
    }
    
    //get wager for Wager ID
    router.get("wagers", UUID.parameter) { req -> Future<Wager> in
        let id = try req.parameters.next(UUID.self)
        return try Wager.find(id, on: req).flatMap(to: Wager.self) { wager in
            guard var wager = wager else {
                throw Abort(.notFound)
            }
            return req.future(wager)
        }
    }
    
    //delete a Wager
    router.delete("wagers", UUID.parameter) { req -> Future<HTTPStatus> in
        let id = try req.parameters.next(UUID.self)
        return try Wager.find(id, on: req).flatMap(to: HTTPStatus.self) { wager in
            guard let wager = wager else {
                throw Abort(.notFound)
            }
            return wager.delete(on: req).transform(to: HTTPStatus.noContent)
        }
    }
    
    //NFL GAMES
    router.post(NFLGame.self, at: "games", "create") { req, game -> Future<NFLGame> in
        return game.save(on: req)
    }
    
    router.get("games", "list") { req -> Future<[NFLGame]> in
        return NFLGame.query(on: req).all()
    }
    
    router.get("games", UUID.parameter) { req -> Future<NFLGame> in
        let id = try req.parameters.next(UUID.self)
        return try NFLGame.find(id, on: req).map(to: NFLGame.self) { game in
            guard var game = game else {
                throw Abort(.notFound)
            }
            return game
        }
    }

    router.delete("games", UUID.parameter) { req -> Future<HTTPStatus> in
        let id = try req.parameters.next(UUID.self)
        return try NFLGame.find(id, on: req).flatMap(to: HTTPStatus.self) { game in
            guard let game = game else {
                throw Abort(.notFound)
            }
            return game.delete(on: req).transform(to: HTTPStatus.noContent)
        }
    }
    
    //OFFERS
    
    router.post(Offer.self, at: "offers") {req, offer -> Future<Offer> in
        return offer.save(on:req)
    }
    
    router.post(Offer.self, at: "offers", "accept", UUID.parameter, UUID.parameter) { (req, offer) -> Future<Offer> in
        let id = try req.parameters.next(UUID.self)
        let counterParty = try req.parameters.next(UUID.self)
        return try Offer.find(id, on: req).map(to: Offer.self) { offer in
            guard var offer = offer else {
                throw Abort(.notFound)
            }
            offer.counterparty = counterParty
            return offer
        }
    }
    
    router.get("offers") { req -> Future<[Offer]> in
        return Offer.query(on: req).all()
    }
    
    router.get("offers", UUID.parameter) { req -> Future<Offer> in
        let id = try req.parameters.next(UUID.self)
        return try Offer.find(id, on: req).map(to: Offer.self) { offer in
            guard var offer = offer else {
                throw Abort(.notFound)
            }
            return offer
        }
    }
    
    router.delete("offers", "delete", UUID.parameter) { req -> Future<HTTPStatus> in
        let id = try req.parameters.next(UUID.self)
        return try Offer.find(id, on: req).flatMap(to: HTTPStatus.self) { offer in
            guard let offer = offer else {
                throw Abort(.notFound)
            }
            return offer.delete(on: req).transform(to: HTTPStatus.noContent)
        }
    }
    
    
    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
