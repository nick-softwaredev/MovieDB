# 🎬 MovieDB

Small **iOS-only** app built lookup of **popular movies**, **movie details**, **deep linking**, and **clean architecture choices**.

- Minimum deployment target: **iOS 18.0**

## 🚀 Schemes And Running

Two schemes are provided:

- `MovieDB`: live TMDB-backed mode
- `MovieDB-Test`: mock mode, local only data

How they work:
- scheme sets `APP_MODE`
- `SceneDelegate` chooses live or mock dependency composition from that value

Run in Xcode:

1. Open `MovieDB.xcodeproj`
2. Choose a simulator
3. Select:
   - `MovieDB` for live API data
   - `MovieDB-Test` for mock/demo mode
4. Run

Deep link example:

```bash
xcrun simctl openurl booted "movieapp://moviedetails/603"
```

Run unit tests:

- Xcode: `Product > Test`
- CLI:

```bash
xcodebuild test \
  -project MovieDB.xcodeproj \
  -scheme MovieDB-Test \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

## 🧪 Tests

Unit tests cover the critical paths only:

- `MoviesListViewModel`
- `MovieDetailsViewModel`
- mock repositories
- `MoviesListPaginator`
- shared image loading behavior

Why this coverage exists:
- validates list/details state transitions
- protects pagination behavior
- verifies image decoding + cache hit behavior
- keeps the highest-risk logic testable without over-testing UI layout

## What The App Does

- Shows a paginated list of popular movies
- Loads poster images with caching
- Opens a movie details screen
- Supports `movieapp://moviedetails/{movie_id}`
- Handles loading, success, error, retry, pull to refresh, and no-network states

This directly addresses the assignment requirements around:
- popular movies list
- details screen
- deep link support
- dependency injection
- test coverage

## 🏗️ Architecture

The project is organized by **feature** and split into **Presentation / Domain / Data**, with **MVVM+C** in presentation:

- `App/`: startup, DI, routing, coordinator composition
- `Features/MoviesList`: list UI, pagination, repository contracts and implementations
- `Features/MovieDetails`: details UI, repository contracts and implementations
- `Shared/`: networking, images, logging, common state/errors, shared SwiftUI/UIKit helpers

Why this structure was chosen:
- keeps UIKit and SwiftUI screens isolated from networking details
- makes mock and live implementations swappable
- keeps the coordinator responsible for navigation only
- makes the assignment easy to build top-down and test incrementally

### Clean Architecture Thinking

The app follows a lightweight Clean Architecture approach:

- **Presentation** knows how to render state and react to user input
- **Domain** defines the feature contracts and core models
- **Data** implements those contracts using either mocks or the real TMDB API

This means the UI does not know whether data comes from:
- `MockMoviesListRepository`
- `LiveMoviesListRepository`
- `MockMovieDetailsRepository`
- `LiveMovieDetailsRepository`

That separation was useful for this task because the app could be built and reviewed in **mock mode first**, while preserving the same screen flow and dependency graph later in **live mode**.

### SOLID In Practice

- **S — Single Responsibility**
  - `MoviesListViewModel` manages list state and pagination orchestration
  - `MoviesListPaginator` only tracks page-loading state
  - `DefaultImageLoader` only loads and caches images
  - `AppCoordinator` only owns app-level navigation flow

- **O — Open/Closed**
  - repositories are extended with new implementations without changing UI code
  - example: switching from `MockMovieDetailsRepository` to `LiveMovieDetailsRepository` does not require changing `MovieDetailsViewModel`

- **L — Liskov Substitution**
  - view models depend on repository protocols, so mock and live repositories can be swapped safely
  - same applies to shared image loading through `ImageLoading`

- **I — Interface Segregation**
  - features depend on small focused protocols such as `MoviesListRepository`, `MovieDetailsRepository`, and `ImageLoading`
  - screens do not depend on broader networking or configuration APIs they do not need

- **D — Dependency Inversion**
  - high-level layers depend on abstractions, not concrete types
  - example: `MoviesListViewModel` depends on `MoviesListRepository`, not on `URLSession` or TMDB DTOs
  - concrete implementations are created in `AppDependencies`, which acts as the composition root

### Patterns Used

- **MVVM+C**
  - `ViewController` / SwiftUI `View` renders state
  - `ViewModel` owns screen behavior and state transitions
  - `Coordinator` owns navigation

- **Repository Pattern**
  - feature data access is hidden behind repository contracts
  - this keeps the domain and presentation layers independent from TMDB transport details

- **Composition Root / Manual DI**
  - `AppDependencies` creates and wires concrete implementations in one place
  - this keeps object creation out of view controllers and view models

- **Strategy-like environment switching**
  - schemes set `APP_MODE`
  - `SceneDelegate` chooses mock or live composition at startup
  - same app flow, different implementations underneath

- **Shared service abstraction**
  - `ImageLoading` is shared between UIKit and SwiftUI
  - this avoids duplicate image-loading logic across the two UI technologies

Overall, this was chosen because it solves the assignment requirements in a way that is easy to reason about, easy to swap between mock and live data, and straightforward to test without coupling UI code to networking code.

## 🔧 How Things Can Be Improved

- dedicated factory/module builders instead of the current light composition-root factory style
- stronger endpoint/request abstraction around TMDB image loading
- more polished loading skeletons instead of simple spinners/placeholders
- broader UI test coverage for deep links and pagination
- stronger formatting/presentation models for details screen data
- optional modularization into separate framework targets if the app grows

## Notes

- Light mode is enforced intentionally
- The app supports both **mock-first development** and **live API mode**
- Image loading is shared across UIKit and SwiftUI through one loader abstraction
