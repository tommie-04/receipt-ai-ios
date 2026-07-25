# 🧾 Receipt AI (iOS)

A native iOS expense tracker built with SwiftUI. Quickly log income and expenses, see your spending at a glance, and (soon) get AI-powered insights into your habits.

## Features

- Quick add for income and expenses with categories, notes, and dates
- Home dashboard: net balance, income/expense summary, weekly bar chart
- Stats page: income vs. expense overview and spending breakdown by category (donut chart)
- Profile page with editable name and local user ID
- Settings page with:
  - Accent color picker (theming groundwork for future customization)
  - Placeholder pages for custom categories and chart preferences
  - Bring-your-own API key field (for future AI-powered analysis)

## Tech Stack

- **Language:** Swift
- **UI:** SwiftUI
- **Charts:** Swift Charts
- **Persistence:** `@AppStorage` (local device storage)

## Project Structure
ReceiptAI/
├── ReceiptAIApp.swift # App entry point
├── ContentView.swift # Root view — tab navigation and routing
├── HomeView.swift # Dashboard: balance, chart, recent transactions
├── StatsView.swift # Income/expense summary and category breakdown
├── AddTransactionView.swift # Add expense/income form + Transaction model
├── ProfileView.swift # User name, avatar initials, local ID
├── SettingsView.swift # Theme, categories, chart prefs, API key
├── CameraPicker.swift # UIKit camera bridge (not currently in use)


## Getting Started

### Requirements

- Xcode 16+
- iOS 17+ (simulator or physical device)

### Run

1. Open `ReceiptAI.xcodeproj` in Xcode
2. Select a simulator (or a connected iPhone) as the run target
3. Press ▶️ to build and run

No API keys or environment setup required to run the current version — all data is stored locally on-device.

## Roadmap

- [ ] Persist transactions with SwiftData (currently in-memory only)
- [ ] Custom expense/income categories
- [ ] Chart customization
- [ ] AI-powered spending insights (user-provided API key)
- [ ] Real camera-based receipt scanning + AI extraction
- [ ] App-wide theming based on selected accent color

## License

MIT



