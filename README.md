# RiftStats

An iOS application for tracking League of Legends player statistics and match history.

## Features

- 🔍 Search players by Riot ID (Name#TAG)
- 📊 View last 5 match details
- 📈 Display champion, KDA, CS, and item information
- ✅ Win/loss indicators with color coding
- 🎨 Dark League of Legends-inspired theme
- 📱 Modern SwiftUI interface

## Screenshots

[Add screenshots here]

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+
- Riot Games API Key

## Setup

1. Clone the repository:
```bash
git clone https://github.com/omairqazi29/RiftStats.git
cd RiftStats
```

2. Open the project in Xcode:
```bash
open RiftStats.xcodeproj
```

3. Add your Riot API key in `RiftStats/Services/RiotAPIService.swift`:
```swift
private let apiKey = "YOUR_API_KEY_HERE"
```

4. Update the region and platformId if needed (default: Americas/NA1)

5. Build and run on your iOS device or simulator

## Getting a Riot API Key

1. Visit [Riot Games Developer Portal](https://developer.riotgames.com/)
2. Sign in with your Riot account
3. Generate a Development API Key
4. Note: Development keys expire every 24 hours

## Project Structure

```
RiftStats/
├── RiftStatsApp.swift          # App entry point
├── Models/
│   ├── Player.swift            # Player data models
│   └── Match.swift             # Match data models
├── Services/
│   └── RiotAPIService.swift    # Riot API integration
├── Views/
│   ├── ContentView.swift       # Main search view
│   ├── PlayerHeaderView.swift  # Player info display
│   └── MatchCardView.swift     # Match history cards
└── Assets.xcassets/            # Color scheme and assets
```

## Tech Stack

- **SwiftUI** for UI
- **Async/await** for networking
- **Riot Games API** for data
- **Data Dragon CDN** for images

## Color Scheme

- Background: Dark (#0A141A)
- Card Background: Darker Gray (#1A232D)
- Gold Accent: League Gold (#C8AE3E)
- Win: Green
- Loss: Red

## License

MIT

## Related Projects

- [league-stats](https://github.com/omairqazi29/league-stats) - Web version of this app
