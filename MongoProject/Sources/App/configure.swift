import MongoDBVapor
import Vapor

/// Configures the application.
public func configure(_ app: Application) throws {
    // Uncomment to serve files from the /Public folder.
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // Configure the app to connect to a MongoDB deployment. If a connection string is provided via the `MONGODB_URI`
    // environment variable it will be used; otherwise, use the default connection string for a local MongoDB server.
    let secrets = Secrets()
    try app.mongoDB.configure(Environment.get("MONGODB_URI") ?? "mongodb://\(secrets.mongouserid):\(secrets.mongopassword)@35.228.18.140:27017")

    // Use `ExtendedJSONEncoder` and `ExtendedJSONDecoder` for encoding/decoding `Content`. We use extended JSON both
    // here and on the frontend to ensure all MongoDB type information is correctly preserved.
    // See: https://docs.mongodb.com/manual/reference/mongodb-extended-json
    ContentConfiguration.global.use(encoder: ExtendedJSONEncoder(), for: .json)
    ContentConfiguration.global.use(decoder: ExtendedJSONDecoder(), for: .json)

    // Register routes.
    try routes(app)
}
