import Foundation
import Vapor

extension FireStoreVaporClient: ConfigInitializable {
    public init(config: Config) throws {
        guard let firebase = config["firebase"] else {
            throw ConfigError.missingFile("firebase")
        }
        guard let projectId = firebase["projectId"]?.string else {
            throw ConfigError.missing(key: ["projectId"], file: "firebase", desiredType: String.self)
        }
        guard let authToken = firebase["firestoreToken"]?.string else {
            throw ConfigError.missing(key: ["firestoreToken"], file: "firebase", desiredType: String.self)
        }
        self = FireStoreVaporClient(projectId: projectId,
                                    authToken: authToken,
                                    client: try config.resolveClient(),
                                    logger: try config.resolveLog())
    }
}

extension Config {
    public func addConfigurable<
        F: FirestoreClient
        >(firestore: @escaping Config.Lazy<F>, name: String) {
        customAddConfigurable(closure: firestore, unique: "firestore", name: name)
    }
    public func resolveFirestore() throws -> FirestoreClient {
        return try customResolve(
            unique: "firestore",
            file: "firebase",
            keyPath: ["firestore"],
            as: FirestoreClient.self,
            default: FireStoreVaporClient.init
        )
    }
}
