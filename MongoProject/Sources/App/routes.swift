import MongoDBVapor
import Vapor

struct Groups: Content {
    let _id: BSONObjectID?
    let name: String
    let description: String
    let facilitators: [Facilitator]
    let members: [Member]
    let meetingSchedule: MeetingSchedule
    let rules: [String]
    let createdAt: String
    let updatedAt: String
    var groupId: String
}

struct Facilitator: Content {
    let userid: String
}

struct Member: Content {
    let userId: String
    let name: String
}

struct MeetingSchedule: Content {
    let day: String
    let time: String
}

struct GroupChat: Codable {
    let _id: BSONObjectID?
    let groupId: String
    let name: String
    let participants: [Participant]
    let messages: [Message]
    let createdAt: String
    let updatedAt: String
}

struct Participant: Codable {
    let userId: String
    let username: String
}

struct Message: Codable {
    let messageId: String
    let sender: Participant
    let content: String
    let timestamp: String
}

struct Activity: Codable {
    let userId: String
    let name: String
    let description: String
    let timestamp: String
}

struct ActivityData: Codable {
    let _id: BSONObjectID?
    let activity: [Activity]
    let createdAt: String
    let groupId: String
}


extension Request {
    var groupsCollection: MongoCollection<Groups> {
        self.application.mongoDB.client.db("support-groups").collection("group", withType: Groups.self)
    }
    
    var groupChats: MongoCollection<GroupChat> {
        self.application.mongoDB.client.db("support-groups").collection("chats", withType: GroupChat.self)
    }
    
    var activitiesCollection: MongoCollection<ActivityData> {
        self.application.mongoDB.client.db("support-groups").collection("activities", withType: ActivityData.self)
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
    
    app.post("addMember", ":groupId", ":userid") { req async throws -> Response in
        guard let groupId = req.parameters.get("groupId"),
              let userid = req.parameters.get("userid") else {
            throw Abort(.badRequest, reason: "Missing groupId or userid parameter")
        }
        
        guard let contentType = req.headers.contentType, contentType == .json else {
            throw Abort(.unsupportedMediaType)
        }
        
        guard let data = req.body.data else {
            throw Abort(.badRequest, reason: "Empty request body")
        }
        
        let decoder = JSONDecoder()
        let newMember = try decoder.decode(Member.self, from: data)
        
        let memberDocument: BSONDocument = [
            "userId": .string(newMember.userId),
            "name": .string(newMember.name)
        ]
        
        let filter: BSONDocument = [
            "groupId": .string(groupId)
        ]
        
        let update: BSONDocument = [
            "$addToSet": .document([
                "members": .document(memberDocument)
            ])
        ]
        
        try await req.groupsCollection.updateOne(filter: filter, update: update).get()
        
        return Response(status: .created)
    }
    
    // Check if member exists in a group
    
    app.get("checkMember", ":userid", ":groupId") { req -> EventLoopFuture<Response> in
        guard let userid = req.parameters.get("userid"),
              let groupId = req.parameters.get("groupId") else {
            throw Abort(.badRequest, reason: "Missing userid or groupId parameter")
        }

        let filter: BSONDocument = [
            "members.userId": .string(userid),
            "groupId": .string(groupId)
        ]

        return req.groupsCollection.find(filter).flatMap { cursor in
            cursor.toArray()
        }.flatMapThrowing { groups in
            if let _ = groups.first {
                return Response(status: .ok, body: "Member exists in the group")
            } else {
                return Response(status: .notFound, body: "Member does not exist in the group")
            }
        }
    }
    
    app.get("groupChats", ":groupId") { req -> EventLoopFuture<Response> in
        guard let groupId = req.parameters.get("groupId") else {
            throw Abort(.badRequest, reason: "GroupId is missing in the request")
        }
        
        let filter: BSONDocument = [
            "groupId": .string(groupId)
        ]
        
        return req.groupChats.find(filter).flatMap { cursor in
            cursor.toArray()
        }.flatMapThrowing { groups in
            if let groupChat = groups.first {
                let encoder = JSONEncoder()
                let data = try encoder.encode(groupChat)
                let response = Response(status: .ok, body: Response.Body(data: data))
                response.headers.contentType = .json
                return response
            } else {
                return Response(status: .notFound, body: "Group chat not found")
            }
        }
    }
    
    app.post("sendMessage", ":groupId", ":userid", ":username", ":text") { req async throws -> Response in
        guard let groupId = req.parameters.get("groupId"),
              let username = req.parameters.get("username"),
              let messageText = req.parameters.get("text"),
              let userid = req.parameters.get("userid") else {
            throw Abort(.badRequest, reason: "Missing groupId or userid parameter")
        }

        guard let contentType = req.headers.contentType, contentType == .json else {
            throw Abort(.unsupportedMediaType)
        }

        guard let data = req.body.data else {
            throw Abort(.badRequest, reason: "Empty request body")
        }

        let decoder = JSONDecoder()
        let newMessage = try decoder.decode(Message.self, from: data)

        let sender: BSONDocument = [
            "userId": .string(userid),
            "username": .string(username)
        ]

        let message: BSONDocument = [
            "messageId": .string(UUID().uuidString),
            "content": .string(messageText),
            "sender": .document(sender),
            "timestamp": .string(Date().ISO8601Format())
        ]

        let filter: BSONDocument = [
            "groupId": .string(groupId)
        ]

        let update: BSONDocument = [
            "$addToSet": .document([
                "messages": .document(message)
            ])
        ]

        try await req.groupChats.updateOne(filter: filter, update: update).get()

        return Response(status: .created)
    }
    
    app.get("activities", ":groupId") { req -> EventLoopFuture<Response> in
        guard let groupId = req.parameters.get("groupId") else {
            throw Abort(.badRequest, reason: "GroupId is missing in the request")
        }
        
        let filter: BSONDocument = [
            "groupId": .string(groupId)
        ]
        
        return req.activitiesCollection.find(filter).flatMap { cursor in
            cursor.toArray()
        }.flatMapThrowing { activities in
            if !activities.isEmpty {
                let encoder = JSONEncoder()
                let data = try encoder.encode(activities)
                let response = Response(status: .ok, body: Response.Body(data: data))
                response.headers.contentType = .json
                return response
            } else {
                return Response(status: .notFound, body: "No activities found for the specified groupId")
            }
        }
    }

}

/*
 -- TEST: cURL --
 curl -X POST -H "Content-Type: application/json" -d '{
   "name": "Anxiety Support Group",
   "description": "A group for individuals struggling with anxiety",
   "facilitators": [
     { "userid": "John Doe" },
     { "userid": "Jane Smith" }
   ],
   "members": [
     { "userId": "609fb3b0285a1a12ab5c7851", "name": "user1" },
     { "userId": "609fb3d8285a1a12ab5c7852", "name": "user2" }
   ],
   "meetingSchedule": { "day": "Wednesday", "time": "7:00 PM" },
   "rules": [
     "Respect each other'\''s privacy",
     "Maintain a supportive and non-judgmental environment",
     "Confidentiality is key"
   ],
   "createdAt": "2021-05-15T10:30:00Z",
   "updatedAt": "2021-06-20T14:45:00Z"
 }' http://127.0.0.1:8080/

 */
