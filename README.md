# FirebaseServicesManager

[![license](https://img.shields.io/badge/license-MIT-green)](https://github.com/DevCrew-io/firebase-utils-ios/blob/main/LICENSE)
![](https://img.shields.io/badge/Code-Swift-informational?style=flat&logo=swift&color=FFA500)
![](https://img.shields.io/github/v/tag/DevCrew-io/firebase-utils-ios)

FirebaseServices is a Swift framework that provides a convenient way to interact with various Firebase services, including Firestore, Storage, and Realtime Database.

## Installation

### Swift Package Manager
The [Swift Package Manager](https://www.swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

```
dependencies: [
    .package(url: "https://github.com/DevCrew-io/firebase-utils-ios.git", .upToNextMajor(from: "1.0.0"))
]
```

### Manually

To use FirebaseServices manually  in your project, follow these steps:

1. Install the Firebase SDK by integrating it into your project using either Cocoapods or Swift Package Manager.

2. Add the FirebaseServices framework to your project:
   - Clone or download the FirebaseServices repository.
   - Drag and drop the `FirebaseServices.xcodeproj` file into your Xcode project.
   - In your project's target settings, navigate to "General" -> "Frameworks, Libraries, and Embedded Content".
   - Click the "+" button, select "FirebaseServices.framework", and choose "Add".

3. Import the FirebaseServices module wherever you need to use it:
```swift
import FirebaseServices
```
### Firebase Project Setup

1. Go to the [Firebase Console](https://console.firebase.google.com/), sign in with your Google account, create a new Firebase project or select an existing one and follow the steps mentioned by firebase to complete firebase configurations.

**Note**: Ensure that the `GoogleService-Info.plist` file is included in your project's target and is present in your app's bundle during runtime.

### Initialisation
To initialise `FirebaseServiceManager`, In AppDelegate.swift:
 ```
 import FirebaseServiceManager
  ```
```swift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseServices.manager.configure()


        return true
    }
}

```

## Usage

The FirebaseServices framework provides the following services:

### FirestoreService

The `FirestoreService` class is included within this package and is used for handling Firebase Firestore operations. Here's how you can use it:

```swift
// Example usage of FirestoreService
// Adding a document to the specified collection
FirebaseServices.manager.firestore.add(documentAt: yourCollectionPath, dataDic: yourDataDictionary) { result in
    switch result {
    case .success(let addedDocument):
        // Handle success
        print("Document added: \(addedDocument ?? nil)")
    case .failure(let error):
        // Handle error
        print("Error adding document: \(error)")
    }
}

// Retrieving a list of documents based on the provided query
FirebaseServices.manager.firestore.getList(YourFirestoreDocument.self, firestore: yourQuery) { result in
    switch result {
    case .success(let documents):
        // Handle success
        print("Retrieved documents: \(documents)")
    case .failure(let error):
        // Handle error
        print("Error retrieving documents: \(error)")
    }
}

// Retrieving a specific document from Firestore
FirebaseServices.manager.firestore.getDocument(with: documentId, from: yourCollection, YourFirestoreDocument.self) { result in
    switch result {
    case .success(let document):
        // Handle success
        print("Retrieved document: \(document ?? nil)")
    case .failure(let error):
        // Handle error
        print("Error retrieving document: \(error)")
    }
}

// Observing changes to a collection based on the provided query
let observerHandle = FirebaseServices.manager.firestore.observeDocuments(query: yourQuery, YourFirestoreDocument.self) { result in
    switch result {
    case .success(let documents):
        // Handle success
        print("Observed documents: \(documents)")
    case .failure(let error):
        // Handle error
        print("Error observing documents: \(error)")
    }
}

// Removing an observer
FirebaseServices.manager.firestore.removeObserver(handle: observerHandle)

// Updating a document in Firestore
FirebaseServices.manager.firestore.update(with: documentId, documentIn: yourCollection, dataDic: updatedDataDictionary) { result in
    switch result {
    case .success(let updatedDocument):
        // Handle success
        print("Document updated: \(updatedDocument ?? nil)")
    case .failure(let error):
        // Handle error
        print("Error updating document: \(error)")
    }
}

// Deleting a document from Firestore
FirebaseServices.manager.firestore.delete(id: documentId, documentAt: yourCollectionPath) { result in
    switch result {
    case .success(let deleted):
        // Handle success
        print("Document deleted: \(deleted)")
    case .failure(let error):
        // Handle error
        print("Error deleting document: \(error)")
    }
}
```

Similarly, all other methods can be used as per your need. To see all exposed methods/actions available in the package by navigating to `FirestoreService` class.

#### Note:

To create `FirestoreQuery`, use ```FSQuery.firestore``` followed by your database path for example:

```let firestoreQuery = FSQuery.firestore.collection("collectionPath")```

### StorageService

The `StorageService` class is used for handling Firebase Storage operations. Here's how you can use it:

```swift
// Example usage of StorageService
// Uploading a file to Firebase Storage
let data = ... // Your file data
let name = "example.jpg"
let folder = "images"
let metaData = StorageMetadata()
FirebaseServices.manager.storage.upload(file: data, with: name, in: folder, metaData: metaData, progressCompletion: { progress in
    // Handle progress updates
}, completion: { result in
    switch result {
    case .success(let urls):
        // Handle success
        print("File uploaded successfully. URLs: \(urls)")
    case .failure(let error):
        // Handle error
        print("Error uploading file: \(error)")
    }
})

// Downloading data from Firebase Storage
let path = "images/example.jpg"
FirebaseServices.manager.storage.downloadData(from: path, progressCompletion: { progress in
    // Handle progress updates
}, completion: { result in
    switch result {
    case .success(let data):
        // Handle success
        print("Downloaded data: \(data)")
    case .failure(let error):
        // Handle error
        print("Error downloading data: \(error)")
    }
})

// Deleting a file from Firebase Storage
FirebaseServices.manager.storage.delete(file: "example.jpg", colletion: "images") { result in
    switch result {
    case .success(let deleted):
        // Handle success
        if let deleted = deleted, deleted {
            print("File deleted successfully.")
        } else {
            print("File does not exist.")
        }
    case .failure(let error):
        // Handle error
        print("Error deleting file: \(error)")
    }
}

// Other available functions:

// - upload(file: Data, with name: String, in folder: String, metaData: StorageMetadata?, progressCompletion: @escaping (_ progress: Progress) -> (), completion: @escaping (_ result: Result<(String?, String?), Error>) -> ()) -> StorageUploadTask
// - update(file: Data, with name: String, in folder: String, progressCompletion: @escaping (_ progress: Progress) -> (), completion: @escaping (_ result: Result<(String?, String?), Error>) -> ()) -> StorageUploadTask
// - upload(file: URL, with name: String, in folder: String, metaData: StorageMetadata?, progressCompletion: @escaping (_ progress: Progress) -> (), completion: @escaping (_ result: Result<(String?, String?), Error>) -> ()) -> StorageUploadTask
// - update(file: URL, with name: String, in folder: String, progressCompletion: @escaping (_ progress: Progress) -> (), completion: @escaping (_ result: Result<(String?, String?), Error>) -> ()) -> StorageUploadTask
// - downloadData(from path: String, size: Int64 = Int64.max, progressCompletion: @escaping (_ progress: Progress) -> (), completion: @escaping (_ result: Result<Data?, Error>) -> Void) -> StorageDownloadTask
// - downloadFile(from path: String, to localURL: URL, progressCompletion: @escaping (_ progress: Progress) -> (), completion: @escaping (_ result: Result<URL?, Error>) -> Void) -> StorageDownloadTask
// - downloadURL(for path: String, completion: @escaping (_ result:  Result<URL?, Error>) -> Void)
```

### DatabaseService

The `DatabaseService` class is included within this package and is used for handling Firebase Realtime Database operations. Here's how you can use it:

```swift
// Example usage of DatabaseService

// Adding data to the database
FirebaseServices.manager.database.add(ref: yourDatabaseReference, dataDic: yourDataDictionary) { result in
    switch result {
    case .success(let addedData):
        // Handle success
        print("Data added: \(addedData ?? [:])")
    case .failure(let error):
        // Handle error
        print("Error adding data: \(error)")
    }
}

// Adding data using a custom object conforming to the `DatabaseNode` protocol
FirebaseServices.manager.database.add(ref: yourDatabaseReference, dataObject: yourCustomObject) { result in
    switch result {
    case .success(let addedObject):
        // Handle success
        if let addedObject = addedObject {
            print("Object added: \(addedObject)")
        } else {
            print("Object not added.")
        }
    case .failure(let error):
        // Handle error
        print("Error adding object: \(error)")
    }
}

// Updating data in the database
FirebaseServices.manager.database.update(ref: yourDatabaseReference, dataDic: updatedDataDictionary) { result in
    switch result {
    case .success(let updatedData):
        // Handle success
        print("Data updated: \(updatedData ?? [:])")
    case .failure(let error):
        // Handle error
        print("Error updating data: \(error)")
    }
}

// Updating data using a custom object conforming to the `DatabaseNode` protocol
FirebaseServices.manager.database.update(ref: yourDatabaseReference, dataObject: updatedCustomObject) { result in
    switch result {
    case .success(let updatedObject):
        // Handle success
        if let updatedObject = updatedObject {
            print("Object updated: \(updatedObject)")
        } else {
            print("Object not updated.")
        }
    case .failure(let error):
        // Handle error
        print("Error updating object: \(error)")
    }
}

// Retrieving a single object from the database
FirebaseServices.manager.database.getSingleObject(ref: yourDatabaseReference) { result in
    switch result {
    case .success(let object):
        // Handle success
        if let object = object {
            print("Retrieved object: \(object)")
        } else {
            print("Object not found.")
        }
    case .failure(let error):
        // Handle error
        print("Error retrieving object: \(error)")
    }
}

// Retrieving a list of objects from the database
FirebaseServices.manager.database.getList(ref: yourDatabaseReference) { result in
    switch result {
    case .success(let objects):
        // Handle success
        if let objects = objects {
            print("Retrieved objects: \(objects)")
        } else {
            print("No objects found.")
        }
    case .failure(let error):
        // Handle error
        print("Error retrieving objects: \(error)")
    }
}

// Observing changes in a list of objects in the database
let observerHandle = FirebaseServices.manager.database.observeList(ref: yourDatabaseReference) { result in
    switch result {
    case .success(let objects):
        // Handle success
        if let objects = objects {
            print("Observed objects: \(objects)")
        } else {
            print("No objects observed.")
        }
    case .failure(let error):
        // Handle error
        print("Error observing objects: \(error)")
    }
}

// Removing an observer
databaseService.removeObserver(ref: yourDatabaseReference, handle: observerHandle)

// Removing all registered observers
databaseService.removeAllObservers(ref: yourDatabaseReference)
```
Similarly, all other methods can be used as per your need. To see all exposed methods/actions available in the package by navigating to `DatabaseService` class.

#### Note:

To create `DatabaseReference`, use ```DBRef.database``` followed by your database path for example:

```let databaseReference = DBRef.database.child("your path")```

## Author
[DevCrew.IO](https://devcrew.io/)

If you have any questions or comments about **FirebaseServicesManager** , please feel free to contact us at info@devcrew.io.

<h3 align="left">Connect with Us:</h3>
<p align="left">
<a href="https://devcrew.io" target="blank"><img align="center" src="https://devcrew.io/wp-content/uploads/2022/09/logo.svg" alt="devcrew.io" height="35" width="35" /></a>
<a href="https://www.linkedin.com/company/devcrew-io/mycompany/" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/linked-in-alt.svg" alt="mycompany" height="30" width="40" /></a>
<a href="https://github.com/DevCrew-io" target="blank"><img align="center" src="https://cdn-icons-png.flaticon.com/512/733/733553.png" alt="DevCrew-io" height="32" width="32" /></a>
</p>


## Contributing 
Contributions, issues, and feature requests are welcome! See [Contributors](https://github.com/DevCrew-io/firebase-utils-ios/graphs/contributors) for details.

### Contributions
Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

### Show your Support
Give a star if this project helped you.

### Copyright & License
Code copyright 2023 DevCrew I/O. Code released under the [MIT license](https://github.com/DevCrew-io/firebase-utils-ios/blob/main/LICENSE).
