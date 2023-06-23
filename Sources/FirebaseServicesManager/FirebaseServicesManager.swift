/// Manager class for Firebase services.
public class FirebaseServices {
    /// Singleton instance of `FirebaseServices`.
    public static let manager = FirebaseServices()
    
    /// Firestore service instance.
    public var firestore = FirestoreService()
    
    /// Private initializer to prevent direct instantiation.
    private init() {
        
    }
}
