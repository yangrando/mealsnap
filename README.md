# MealSnap

An iOS app for photo-based food recognition, nutrition lookup, and local meal history.

This repository is public as a technical portfolio project, making it easy to evaluate architecture, business logic, engineering decisions, and AI usage both in the product and in the development workflow.

## Project goals

- Demonstrate modern iOS development with SwiftUI.
- Apply MVVM + Repository architecture with clear separation of concerns.
- Integrate on-device AI (Core ML + Vision) and an external API (Spoonacular).
- Persist data with Core Data.
- Keep the project readable and review-friendly for recruiters and engineering teams.

## Current features

- Meal photo capture with a custom camera.
- Food classification using the `MobileNetV2.mlmodel` model.
- Nutrition lookup via the Spoonacular API.
- Display of top recognized items + macros (calories, carbs, fat, protein).
- Saving analyzed meals to local history.
- Localization in `pt-BR` and `en`.

## Architecture

Adopted pattern: **MVVM + Repository**

- `View`: SwiftUI screens (`MealEntryView`, `HistoryView`, `MainTabView`).
- `ViewModel`: orchestrates screen state and use cases (`MealEntryViewModel`).
- `Repository`: centralizes analysis and persistence flow (`MealRepository`).
- `Services`: isolated integrations (`ImageRecognitionService`, `NutritionAPIService`, `Persistence`).

Main flow:

1. User captures a meal photo.
2. `MealEntryViewModel` triggers `MealRepository`.
3. `ImageRecognitionService` classifies the image with Core ML.
4. `NutritionAPIService` fetches nutrition data for the top item.
5. Results are returned to the UI.
6. When saved, the meal is persisted in Core Data and shown in `HistoryView`.

## Folder structure

```text
MealSnap/
  Core/
    Models/
    Repositories/
    Services/
    ViewControllers/
    ViewModel/
    Views/
  Extensions/
  Resources/
  Utils/
MealSnapTests/
MealSnapUITests/
```

## AI in the project (transparency)

### AI in the product

- **On-device ML:** image recognition with `MobileNetV2` via Vision/Core ML.
- **AI + external data:** nutrition enrichment using Spoonacular.

### AI in development

- Generative AI was used as support for ideation, architecture refinement, and code/documentation clarity reviews.
- Every change was manually validated before being kept in the project.

This section exists to make the human + AI technical collaboration process explicit, which is increasingly relevant in interviews and engineering evaluations.

## Running locally

### Requirements

- Xcode 14+
- iOS 16+ (simulator or physical device; for real camera testing, prefer a physical device)

### 1) Clone the repository

```bash
git clone https://github.com/your-username/mealsnap.git
cd mealsnap
```

### 2) Configure the Spoonacular key

Create/edit `MealSnap/Utils/ApiKeys.plist` with:

- Key: `SpoonacularAPIKey`
- Type: `String`
- Value: your API key

Example:

```xml
<key>SpoonacularAPIKey</key>
<string>YOUR_API_KEY_HERE</string>
```

### 3) Make sure the key is not committed

Confirm that the key file is ignored in an active `.gitignore` in this repository.

### 4) Run a secret check before push

```bash
./scripts/check-secrets.sh
```

If the script reports potential secrets, fix them before committing.

### 5) Run

1. Open `MealSnap.xcodeproj`.
2. Select your target/simulator.
3. Press `Run` in Xcode.

## Security for public repositories

- Keep real keys only in local files ignored by Git (`MealSnap/Utils/ApiKeys.plist`).
- Commit only template/example files (like `MealSnap/Utils/ApiKeys.example.plist`).
- Run `./scripts/check-secrets.sh` before each push.
- If a key is leaked, rotate/revoke it immediately in the provider dashboard.
- If a secret was already committed, remove it from history before publishing.

## Technical evaluation points (for recruiters)

- Layer separation and testability.
- Use of async/await in asynchronous flows.
- UX-oriented error handling (`LocalizedError` + friendly messages).
- Integration between on-device AI and REST API.
- Local persistence and history visualization.

## Planned improvements

- Unit tests covering repository and services.
- Meal detail screen in history.
- Manual correction of recognized food items.
- Cloud sync.

## License

Define according to repository goals (e.g., MIT).
