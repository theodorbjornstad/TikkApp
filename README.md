# Todo List App

## Overview
This project is a simple offline-first Todo List app built using SwiftUI and the MVVM pattern. It leverages Combine for reactive state management and Firebase Firestore as the sole database, ensuring seamless synchronization when the network is available. The app prioritizes modularity, testability, and clean architecture.

## Architecture
The app follows the MVVM (Model-View-ViewModel) architecture, ensuring a clear separation of concerns:
- **Model** 📄: Defines the data structures (e.g., `Todo` model) and handles business logic.
- **View** 🖥️: SwiftUI-based UI components that react to state changes.
- **ViewModel** 🎛️: Acts as an intermediary between the model and the view, handling business logic, event processing, and state management.
- **Repository** 🗄️: Handles data persistence and acts as an abstraction layer for data sources.
- **DataService** 🔥: A generic service for Firebase interactions, managing real-time database updates and CRUD operations for Firestore models.

## Data Flow
1. **User Interaction** 🎯: The user triggers an event (e.g., adding, editing, or deleting a todo item).
2. **ViewModel Processing** 🛠️: The `TodoListViewModel` processes the event, calling the repository to modify the data.
3. **Repository Operations** 💾: The repository handles the data operations by interacting with `FirebaseDataService`.
4. **DataService Execution** 🔥: The `DataService` performs CRUD operations with Firebase Firestore.
5. **State Update** 🔄: 
   - After any change to the data, the repository triggers an update by emitting the latest data via a `PassthroughSubject` to notify any subscribers (like the `ViewModel`).
   - The `ViewModel` subscribes to the repository’s publisher to receive updated data, which triggers a UI update automatically.

## Observer Pattern and Reactive Chain 👀🔄📡
The app uses the **Observer pattern** with **Combine** to ensure real-time data updates:
- The repository publishes changes to the data via a `PassthroughSubject`.
- The `ViewModel` subscribes to this publisher to receive updates when the data changes.
- The `ViewModel` updates its properties, which causes the SwiftUI view to refresh dynamically based on the changes.


## Responsibilities

### ViewModel (`TodoListViewModel`) 🎯📊🛠️
- Handles user interactions and event processing.
- Manages the app state using `@Published` properties.
- Calls the repository to fetch, update, or delete data.
- Observes network status to visualize if the user is online or offline.

### Repository (`TodoRepository`) 💾🔄🔍
- Provides an abstraction layer for data operations.
- Uses dependency injection for testability and maintainability.
- Communicates with `FirebaseDataService` for real-time Firestore operations.
- Ensures that changes are reflected in the `ViewModel` by updating the UI via Combine's reactive chain.
  
### DataService (`FirebaseDataService<Todo>`) 🔥🔄📡
- A generic service specialized for Firebase interactions.
- Exposes CRUD operations (add, update, delete, fetch) for models that conform to `FirebaseModel`.
- Each Firestore collection will have its own instance of `FirebaseDataService`, like `FirebaseDataService<Todo>`, where `Todo` is a model.
- Handles real-time updates by using Firestore listeners, which ensures that the data is automatically synced between the local device and the Firebase Firestore database.

### NetworkMonitorService 🌐📱
- The `NetworkMonitorService` is used for monitoring and visualizing the user's network status (online or offline).
- This service listens for changes in the device's network connectivity and provides an up-to-date view of whether the user is connected to the internet or not.
- It doesn't directly affect data synchronization but is used in the UI to show the user their current network state.
- The `NetworkMonitorService` is used to visualize the online/offline status, but syncing is handled automatically by Firebase.

## Data Flow
1. **User Interaction** 🎯: The user triggers an event (e.g., adding, editing, or deleting a todo item).
2. **ViewModel Processing** 🛠️: The `TodoListViewModel` processes the event, calling the repository to modify the data.
3. **Repository Operations** 💾: The repository interacts with `FirebaseDataService` for data operations.
4. **DataService Execution** 🔥: The `FirebaseDataService` handles the CRUD operations and automatically syncs data with Firestore.
5. **State Update** 🔄: The `ViewModel` receives the updated data from the repository and updates the UI accordingly.
  
## Observer Pattern and Reactive Chain 👀🔄📡
- The app uses the **Observer pattern** with **Combine** for real-time data updates.
- The repository does not directly manage data synchronization. Firebase handles syncing data automatically.
- The `ViewModel` subscribes to changes in the repository to update the UI whenever the data changes.
- The `NetworkMonitorService` visualizes the online/offline status, ensuring the user 

## Key Features 🚀🛠️🔄
✅ **Offline-first**: Local data storage ensures access even without an internet connection. Changes sync automatically when the network is restored.  
✅ **State management**: Utilizes `@ObservedObject` and Combine to manage app state reactively.  
✅ **Dependency injection**: Uses a lightweight dependency injection mechanism to improve testability and maintainability.  
✅ **Error handling**: Implements a structured error-handling mechanism to provide meaningful feedback to the user.  
✅ **Dynamic UI updates**: Automatically updates UI elements based on online/offline status and user interactions.  


Technologies Used 📱🔥⚡️
SwiftUI 🎨: Declarative UI framework.
Combine 🔗: Used for reactive programming and state management.
Firebase Firestore ☁️: Cloud database for data persistence and synchronization.
Lottie 🎬: Used for smooth and engaging animations.
Dependency Injection 🏗️: Ensures modularity and testability.
MVVM Pattern 🏛️: Provides a scalable and testable structure.

## Testing 🧪🔍
The app is designed with testability in mind, particularly focusing on the ViewModel, Repository, and DataService layers.

- ViewModel Tests: Using dependency injection, the TodoListViewModel can be tested in isolation by mocking the repository and network monitor services.
- Repository Tests: The TodoRepositoryImpl can be tested by providing mock data services, ensuring CRUD operations are performed correctly.
- DataService Tests: The FirebaseDataService layer can be mocked to simulate network interactions and test how the repository handles various data states (e.g., offline, online, error conditions).

Future Improvements 🚀📝🔧