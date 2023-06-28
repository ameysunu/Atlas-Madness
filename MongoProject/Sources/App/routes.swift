import MongoDBVapor
import Vapor

struct Groups: Content {
    let _id: BSONObjectID?
    var name: String
    var approved: String
    var description: String
    var timestamp: String
    var groupId: String
    
}

extension Request {
    var groupsCollection: MongoCollection<Groups> {
        self.application.mongoDB.client.db("support-groups").collection("group", withType: Groups.self)
    }
}

func routes(_ app: Application) throws {
    // A GET request will return a list of all kittens in the database.
    app.get { req async throws -> [Groups] in
        try await req.groupsCollection.find().toArray()
    }

    // A POST request will create a new kitten in the database.
    app.post { req async throws -> Response in
        var newGroup = try req.content.decode(Groups.self)
        newGroup.name = "Test"
        try await req.groupsCollection.insertOne(newGroup)
        return Response(status: .created)
    }
}
