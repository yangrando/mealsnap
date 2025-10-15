# mealsnap
MealSnap 📸🍏

MealSnap is a modern iOS application designed to simplify nutritional tracking through the power of Artificial Intelligence. Users can take a photo of their meal, and the app will automatically identify the food items, retrieve detailed nutritional information, and save the meal to a local history for future reference. This project serves as a comprehensive portfolio piece, demonstrating advanced iOS development techniques, a robust software architecture, and the integration of cutting-edge technologies.



 Replace the placeholder above with a real screenshot or GIF of the app.

✨ Key Features

•
📸 AI-Powered Food Recognition: Utilizes a Core ML model (MobileNetV2) to identify multiple food items from a single image directly on the device.

•
📊 Detailed Nutritional Data: Fetches comprehensive nutritional information—including calories, carbs, protein, and fat—by integrating with the Spoonacular API.

•
💾 Persistent History: Saves every analyzed meal to a local database using Core Data, allowing users to track their dietary history over time.

•
🌐 Localization Support: Built with internationalization in mind, featuring support for English and Brazilian Portuguese (pt-BR).

•
📱 Modern & Responsive UI: Crafted with SwiftUI, ensuring a clean, modern, and responsive user interface that adapts to various iOS devices.

•
🔐 Secure API Key Management: Protects sensitive credentials by storing the API key in a plist file, which is git-ignored, preventing it from being exposed in the repository.

🎯 Project Goals

This project was developed not only as a functional application but also as a demonstration of best practices in iOS development. The primary goals were:

1.
To build a portfolio-worthy application that showcases a wide range of technical skills relevant to the current job market.

2.
To implement a clean, scalable, and maintainable architecture (MVVM with a Repository pattern).

3.
To integrate machine learning and external APIs in a practical, real-world use case.

4.
To adhere to modern development standards, including asynchronous programming with async/await, robust error handling, and a reactive UI. '''

'''

🏗️ Architecture

This project is built upon a clean and scalable MVVM-R (Model-View-ViewModel-Repository) architecture. This pattern was chosen to ensure a clear separation of concerns, making the codebase easier to test, maintain, and scale.

•
View: The UI layer, built with SwiftUI. It is responsible for displaying data and capturing user input. It knows nothing about the business logic.

•
ViewModel: Acts as the bridge between the View and the Model (via the Repository). It prepares data for the View and handles user interactions.

•
Repository: A single source of truth for all data operations. It abstracts the data sources, deciding whether to fetch data from a remote API, a local database, or other services.

•
Services: Specialized classes responsible for specific tasks, such as making network calls (NutritionAPIService), running the ML model (ImageRecognitionService), or handling database operations (PersistenceService).

Architecture Diagram

mermaid

graph TD
    subgraph "View Layer (UI)"
        direction LR
        MealEntryView -- Binds to --> MealEntryViewModel
        HistoryView -- Binds to --> HistoryViewModel
        CameraView -- Provides image to --> MealEntryViewModel
    end

    subgraph "ViewModel Layer"
        direction LR
        MealEntryViewModel -- Requests data --> MealRepository
        HistoryViewModel -- Requests data --> MealRepository
    end

    subgraph "Repository Layer"
        direction LR
        MealRepository -- Orchestrates --> ImageRecognitionService
        MealRepository -- Orchestrates --> NutritionAPIService
        MealRepository -- Orchestrates --> PersistenceService
    end

    subgraph "Service & Data Layer"
        direction LR
        ImageRecognitionService -- Uses --> CoreMLModel[("Core ML Model\n(MobileNetV2)")]
        NutritionAPIService -- Fetches from --> SpoonacularAPI[("Spoonacular API\n(Remote)")]
        PersistenceService -- Manages --> CoreData[("Core Data\n(Local Database)")]
    end

    style View fill:#D2E5FF,stroke:#333,stroke-width:2px
    style ViewModel fill:#C2DFFF,stroke:#333,stroke-width:2px
    style Repository fill:#B2D9FF,stroke:#333,stroke-width:2px
    style Services fill:#A2D3FF,stroke:#333,stroke-width:2px

🛠️ Technology Stack & Key Concepts

This project leverages a modern technology stack to deliver its features. The table below outlines the key frameworks and concepts implemented.

Technology / Concept
Description
SwiftUI
The entire user interface is built using Apple's modern, declarative UI framework. -
Combine
Used extensively within the ViewModels (ObservableObject) with @Published property wrappers to create a reactive data flow that automatically updates the UI when data changes. -
Core ML
For on-device machine learning. The app integrates a pre-trained MobileNetV2 model to perform image classification, identifying food items without needing a server. -
AVFoundation
The framework used to build a custom camera interface (CameraViewController), giving full control over the capture session and photo output. -
Core Data
Used for local data persistence. It stores the history of all analyzed meals, including the image, food items, and nutritional data, in a robust and efficient manner. -
Async/Await
Modern concurrency is used for all asynchronous operations, such as network requests and image analysis, leading to cleaner, more readable, and safer code compared to traditional completion handlers. -
API Integration
The app communicates with the Spoonacular REST API to fetch data. This involves making network requests, parsing JSON responses, and handling potential errors gracefully. -
Localization
The app is prepared for an international audience with localized strings for English and Portuguese, using NSLocalizedString and .strings files. -
Dependency Injection
The ViewModels and Repositories are initialized by injecting their dependencies (e.g., services, context), which promotes loose coupling and makes components highly testable. -


'''

🚀 Getting Started

To run this project locally, you will need Xcode 14 (or later) and a physical iOS device to test the camera functionality.

1. Clone the Repository

Bash


git clone https://github.com/your-username/MealSnap.git
cd MealSnap


2. Set Up the API Key

For security, the Spoonacular API key is not hardcoded. You need to create a plist file to store it.

1.
Get your API key: Sign up for a free plan at Spoonacular Food API.

2.
Create the ApiKeys.plist file: In Xcode, right-click on the MealSnap group, select "New File...", and choose "Property List". Name it ApiKeys.plist.

3.
Add the key: Inside the new file, add a new row with the following properties:

•
Key: SpoonacularAPIKey

•
Type: String

•
Value: Your-API-Key-Goes-Here



3. Configure the .gitignore

Ensure that your ApiKeys.plist file is never committed to the repository. Open your .gitignore file and add the following line:

Plain Text


# Credentials
ApiKeys.plist


4. Build and Run

Open the .xcodeproj file in Xcode, select your target device, and press Run (▶).

📖 How to Use

1.
Launch the app: The main screen will show a placeholder for the meal image.

2.
Take a Photo: Tap the camera icon to open the custom camera view. Position your meal and tap the shutter button.

3.
Analyze the Meal: Once the photo appears on the main screen, tap the "Analyze Meal" button.

4.
View Results: The app will display a list of identified food items and their corresponding nutritional information.

5.
Save to History: Tap the "Save Meal" button to persist the meal in your local history.

6.
Check History: Navigate to the "History" tab to see a list of all your saved meals.

🔮 Future Improvements

This project has a solid foundation, but there are many potential features that could be added:

•
User Authentication: Implement Sign in with Apple/Google to sync user data across devices.

•
Detailed Meal View: Create a detail screen when a user taps on a meal in the history.

•
Manual Entry: Allow users to manually add or correct food items.

•
Charts & Statistics: Provide weekly or monthly summaries of nutritional intake.

•
Cloud Sync: Use iCloud or a custom backend to sync meal history.

