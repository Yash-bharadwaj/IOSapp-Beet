# BeetIOS

A modern cinema ticket booking app I built with SwiftUI, following Apple's Human Interface Guidelines.

## What I Built

I created BeetIOS to provide a seamless movie booking experience with an intuitive interface, smooth animations, and comprehensive accessibility support. The app guides users through the entire booking journey - from movie selection to payment confirmation.

## Screenshots

### Booking Flow

<table>
<tr>
<td width="33%">
<strong>1. Movie Selection</strong><br>
<img src="Screens/Buytickets-page1.png" width="100%">
</td>
<td width="33%">
<strong>2. Date & Time Selection</strong><br>
<img src="Screens/whentowatch-page2.png" width="100%">
</td>
<td width="33%">
<strong>3. Ticket Selection</strong><br>
<img src="Screens/TicketSelection-page3.png" width="100%">
</td>
</tr>
<tr>
<td width="33%">
<strong>4. Seat Selection</strong><br>
<img src="Screens/Wheretosit-page4.png" width="100%">
</td>
<td width="33%">
<strong>5. Checkout</strong><br>
<img src="Screens/Checkout-page4.png" width="100%">
</td>
<td width="33%">
<strong>6. Ticket View</strong><br>
<img src="Screens/theticket-page5.png" width="100%">
</td>
</tr>
<tr>
<td width="33%" colspan="3" align="center">
<strong>7. Booking Confirmed</strong><br>
<img src="Screens/bookingconfirmed-page6.png" width="50%">
</td>
</tr>
</table>

## Architecture

I structured the app using NO-MVVM architecture with SwiftUI's modern patterns, following 2025 best practices:

```
┌─────────────────────────────────────────────────────────┐
│                      ContentView                         │
│                  (Navigation Root)                       │
└────────────────────┬────────────────────────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
┌───────▼────────┐      ┌─────────▼──────────┐
│ NowShowingView │      │   Router           │
│                │      │   (@Observable)    │
└───────┬────────┘      └─────────┬──────────┘
        │                         │
        └────────────┬────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
┌───────▼────────┐      ┌─────────▼──────────┐
│ MovieDetailView│      │ DateTimeSelection  │
│                │      │      View           │
└───────┬────────┘      └─────────┬──────────┘
        │                         │
        └────────────┬────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
┌───────▼────────┐      ┌─────────▼──────────┐
│TicketSelection │      │ SeatSelectionView  │
│     View       │      │                    │
└───────┬────────┘      └─────────┬──────────┘
        │                         │
        └────────────┬────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
┌───────▼────────┐      ┌─────────▼──────────┐
│  CheckoutView  │      │ TicketSuccessView  │
│                │      │                    │
└────────────────┘      └───────────────────┘
```

## User Flow

I designed the booking flow to be intuitive and straightforward:

```
Movie Selection
      │
      ▼
Date & Time Selection
      │
      ▼
Ticket Quantity Selection
      │
      ▼
Seat Selection
      │
      ▼
Checkout & Payment
      │
      ▼
Booking Confirmation
```

## Key Features I Implemented

### Core Functionality
- **Movie Discovery**: Browse movies with detailed information and ratings
- **Showtime Selection**: Interactive calendar for date and time selection
- **Ticket Management**: Easy quantity selection with visual feedback
- **Interactive Seat Map**: Real-time seat availability with visual indicators
- **Secure Checkout**: Multiple payment methods with validation
- **Booking Confirmation**: Animated success screen with ticket details

### Technical Implementation
- **Modern State Management**: Used the Observation framework (`@Observable`) for efficient state handling
- **Type-Safe Navigation**: Implemented NavigationStack with NavigationPath for type-safe routing
- **Accessibility**: Added full VoiceOver support and Dynamic Type compatibility
- **Performance**: Optimized with lazy loading and efficient rendering
- **Animations**: Smooth transitions and micro-interactions throughout

## Project Structure

Here's how I organized the codebase:

```
BeetIOS-App/
├── Models/              # Data models
│   ├── Movie.swift
│   ├── Booking.swift
│   ├── Seat.swift
│   └── PaymentMethod.swift
│
├── State/               # Complex state management
│   └── SeatSelectionState.swift
│
├── Views/               # SwiftUI views
│   ├── NowShowingView.swift
│   ├── MovieDetailView.swift
│   ├── SeatSelectionView.swift
│   ├── CheckoutView.swift
│   └── Shared/          # Reusable components
│
├── Navigation/          # Routing
│   └── Router.swift
│
├── Extensions/          # Utilities
│   ├── Color+Theme.swift
│   ├── DesignConstants.swift
│   └── View+Haptics.swift
│
└── Animations/          # Custom animations
    └── ConfettiView.swift
```

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Getting Started

1. Clone the repository
   ```bash
   git clone https://github.com/Yash-bharadwaj/IOSapp-Beet.git
   cd IOSapp-Beet
   ```

2. Open in Xcode
   ```bash
   open BeetIOS-App.xcodeproj
   ```

3. Build and run
   - Select target device or simulator
   - Press `Cmd + R` to build and run

## Technologies I Used

- **SwiftUI** - Declarative UI framework
- **Observation** - Modern state management
- **NavigationStack** - Type-safe navigation
- **Combine** - Reactive programming

## Design Principles

I focused on:
- **Consistency**: Unified design language across all screens
- **Accessibility**: WCAG compliant, VoiceOver ready
- **Performance**: Optimized for smooth 60fps animations
- **User Experience**: Intuitive interactions with haptic feedback

## Code Quality

I maintained:
- NO-MVVM architecture with direct state management
- Comprehensive documentation
- Type-safe implementations
- Accessibility-first approach
- Performance optimizations

---

**Developed by Yashwanth Bharadwaj**

*Building premium iOS experiences*
