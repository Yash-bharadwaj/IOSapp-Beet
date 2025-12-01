# BeetIOS Cinema Ticket Booking App

A modern SwiftUI cinema ticket booking application following Apple's Human Interface Guidelines and best practices.

## Features

- **Movie Selection**: Browse and view movie details
- **Date & Time Selection**: Choose your preferred showtime
- **Ticket Selection**: Select number of tickets
- **Seat Selection**: Interactive seat map with visual feedback
- **Checkout**: Secure payment processing
- **Booking Confirmation**: Animated success screen with ticket details

## Architecture

- **SwiftUI**: Modern declarative UI framework
- **Observation Framework**: State management using `@Observable`
- **NavigationStack**: Type-safe navigation with `NavigationPath`
- **MVVM Pattern**: Clean separation of concerns

## Project Structure

```
BeetIOS-App/
├── Models/           # Data models (Movie, Booking, Seat, etc.)
├── ViewModels/       # Business logic and state management
├── Views/           # SwiftUI views
│   └── Shared/      # Reusable components
├── Navigation/      # Navigation routing
├── Extensions/      # Swift extensions
└── Animations/      # Custom animations
```

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Setup

1. Clone the repository
2. Open `BeetIOS-App.xcodeproj` in Xcode
3. Build and run on simulator or device

## Technologies

- SwiftUI
- Observation Framework
- NavigationStack
- Accessibility Support
- Dynamic Type Support

## License

Copyright © 2025

