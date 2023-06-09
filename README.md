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

The `FirestoreService` class allows you to interact with Firestore and perform various operations such as adding documents, retrieving lists of documents, observing document changes, updating documents, and deleting documents.

Example usage:

```swift
// Add a document to a collection
FirebaseServices.manager.firestore.add(documentAt: "collectionPath", dataDic: dataDic) { result in
    // Handle the result
}
// Update a document
FirebaseServices.manager.firestore.update(with: "documentID", documentIn: "collectionPath", dataDic: dataDic) { result in
    // Handle the result
}

// Delete a document
FirebaseServices.manager.firestore.delete(id: "documentID", documentAt: "collectionPath") { result in
    // Handle the result
}
```

###  With query example

**Query Creation example**
```
 let query = FSQuery.firestore.collection("collection name")
```

```
// Retrieve a list of documents
FirebaseServices.manager.firestore.getList(Object.self, firestore: query) { result in
    // Handle the result
}

// Observe changes to a collection
FirebaseServices.manager.firestore.observeDocuments(query: query, Object.self) { result in
    // Handle the result
}
```

### StorageService

The `StorageService` class allows you to interact with Firebase Storage and perform operations such as uploading, updating, and deleting files.

Example usage:

```swift
// Upload a file to Firebase Storage
FirebaseServices.manager.storage.upload(file: data, with: "fileName", in: "folderPath") { result in
    // Handle the result
}

// Update a file in Firebase Storage
FirebaseServices.manager.storage.update(file: data, with: "fileName", in: "folderPath") { result in
    // Handle the result
}

// Delete a file from Firebase Storage
FirebaseServices.manager.storage.delete(file: "filePath", collection: "collectionPath") { result in
    // Handle the result
}
```

### DatabaseService

The `DatabaseService` class allows you to interact with the Firebase Realtime Database and perform operations such as adding objects, retrieving lists of objects, observing object changes, updating objects, and deleting objects.

Example usage:

// Add an object to the Firebase Realtime Database

**Database path creation example**

`DatabaseReference` is a class provided by the Firebase Realtime Database framework that represents a reference to a specific location in the database. It allows you to read, write, and listen to data at that particular location and its child nodes. You follow the same pattern as Firebase realtime data does. Here following is the example to make `DatabaseReference`:

```
let ref = DBRef.database.child("")
```
For more detail visit [Firebase Console](https://firebase.google.com/docs/database/ios/lists-of-data)

```
FirebaseServices.manager.database.add(object: object, toPath: "path/to/object") { result in
    // Handle the result
}

// Retrieve a list of objects from the Firebase Realtime Database
FirebaseServices.manager.database.getList(Object.self, fromPath: "path/to/list") { result in
    // Handle the result
}

// Observe changes to an object in the Firebase Realtime Database
FirebaseServices.manager.database.observeSingleObject(Object.self, atPath: "path/to/object") { result in
    // Handle the result
}

// Observe changes to an list in the Firebase Realtime Database
FirebaseServices.manager.database.observeList(Object.self, atPath: "path/to/object") { result in
    // Handle the result
}

// Get an object in the Firebase Realtime Database
FirebaseServices.manager.database.getSingleObject(Object.self, atPath: "path/to/object") { result in
    // Handle the result
}

// Update an object in the Firebase Realtime Database
FirebaseServices.manager.database.update(object: object, atPath: "path/to/object") { result in
    // Handle the result
}

// Delete an object from the Firebase Realtime Database
FirebaseServices.manager.database.deleteObject(atPath: "path/to/object") { result in
    // Handle the result
}
```


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
