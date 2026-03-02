# Walkt

A walking tracker iOS app that syncs with Apple Health to provide rich walking analytics and route visualization. Built with UIKit, HealthKit, MapKit, and Core Data.

## User Segments

**Commuters** - Route comparison, time predictions, consistency metrics for daily walking routes.

**Fitness Enthusiasts** - Performance trends, personal records, pace analytics, and improvement tracking over time.

**Casual Walkers** - Achievement badges, streak tracking, and motivational visualizations of daily movement.

## Tech Stack

| Framework | Purpose |
|-----------|---------|
| UIKit | Entire UI layer (no SwiftUI) |
| HealthKit | Walking workout data, steps, distance, energy, GPS routes |
| MapKit | Route visualization with speed-gradient polylines |
| Core Location | Real-time GPS tracking during active walks |
| Core Data | Local persistence for walk sessions and route data |
| Combine | Reactive data binding between services and UI |

## Architecture

- **MVVM** with ViewModelType protocol (Input/Output transform pattern)
- **Coordinator pattern** for navigation (decoupled from view controllers)
- **UICollectionViewCompositionalLayout** with diffable data sources
- **Programmatic Auto Layout** (no storyboards except LaunchScreen)
- **Protocol-based HealthKit abstraction** for testability

## Project Structure

```
Walkt/
├── App/              # AppDelegate, SceneDelegate, AppCoordinator
├── Coordinators/     # Navigation coordinators (tab bar, feature flows)
├── Features/         # Feature modules (Dashboard, Map, History, Settings, Onboarding)
├── Services/         # HealthKit, Location, Sync, Persistence services
├── Models/           # Domain models and Core Data entities
├── Common/           # Extensions, design system tokens, shared protocols
└── Resources/        # Assets, Info.plist, entitlements, LaunchScreen
```

## Requirements

- iOS 15.0+
- Xcode 15.0+
- Physical device required for HealthKit testing (simulator returns `isHealthDataAvailable() == false`)

## Getting Started

1. Clone the repository
2. Open `Walkt.xcodeproj` in Xcode
3. Select a physical device as the build target
4. Enable HealthKit capability in Signing & Capabilities
5. Build and run

### HealthKit Setup

The app requires HealthKit entitlements and usage descriptions in Info.plist. These are included in the project. On first launch, the app will request permission to read walking data from Apple Health.

**Important:** HealthKit features cannot be tested on the iOS Simulator. Always use a physical device for development and testing.

## Development Roadmap

| Phase | Focus |
|-------|-------|
| 1. Scaffolding | Project setup, navigation, design system |
| 2. Models & Persistence | Domain models, Core Data schema |
| 3. HealthKit | Authorization, workout queries, route extraction |
| 4. Sync | Observer queries, incremental sync |
| 5. History & Detail | Walk list, detail screen, filtering |
| 6. Map | Route polyline, speed gradient, altitude profile |
| 7. Dashboard | Progress ring, metric cards, trend charts |
| 8. Analytics | Pace engine, speed segments, km splits |
| 9. Segments | Commuter/fitness/casual-specific features |
| 10. Background | Background delivery, real-time updates |
| 11. Edge Cases | Empty states, indoor walks, error handling |
| 12. Polish | Animations, haptics, dark mode, accessibility |
