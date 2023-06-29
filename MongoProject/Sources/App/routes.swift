import MongoDBVapor
import Vapor

struct Groups: Content {
    let _id: BSONObjectID?
    let name: String
    let approved: String
    let description: String
    let timestamp: String
    let groupId: String
}

extension Request {
    var groupsCollection: MongoCollection<Groups> {
        self.application.mongoDB.client.db("support-groups").collection("group", withType: Groups.self)
    }
}

func routes(_ app: Application) throws {
    // A GET request will return a list of all items in the database.
    app.get("allgroups") { req async throws -> [Groups] in
        try await req.groupsCollection.find().toArray()
    }

    // A POST request will create a new group in the database.
    app.post { req async throws -> Response in
        guard let contentType = req.headers.contentType, contentType == .json else {
            throw Abort(.unsupportedMediaType)
        }
        
        guard let data = req.body.data else {
            throw Abort(.badRequest, reason: "Empty request body")
        }
        
        let decoder = JSONDecoder()
        let newGroup = try decoder.decode(Groups.self, from: data)
        
        try await req.groupsCollection.insertOne(newGroup).get()
        
        return Response(status: .created)
    }
}

/*
 -- TEST: cURL --
 
 curl -X POST -H "Content-Type: application/json" -d '{"name":"YourGroupName", "approved":"true", "description":"YourDescription", "timestamp":"YourTimestamp", "groupId":"YourGroupId"}' http://127.0.0.1:8080/
 */
