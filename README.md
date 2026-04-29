# QuietSpot

🔊 **Track, analyze, and share environmental noise levels in real-time**

A mobile application built with Flutter that helps users monitor noise pollution, understand acoustic patterns, and contribute to community environmental data.

## Features

✨ **Core Capabilities**
- 📊 Real-time noise level recording (dB measurement)
- 🗺️ Interactive map visualization with color-coded markers
- 📱 Offline-first local database with cloud synchronization support
- 🔐 Secure user authentication via Firebase
- 📍 GPS location tracking and address geocoding
- ⚙️ Firestore sync manager available (manual startup required)
- 🔔 Local push notifications
- 📝 Edit and manage noise records
- 📈 Historical data analysis and trends

## Quick Start

### Prerequisites
- Flutter SDK >= 3.11.0
- Dart SDK >= 3.11.0
- Firebase project (see [FIRESTORE_SETUP.md](FIRESTORE_SETUP.md))

### Installation

```bash
# Clone repository
git clone https://github.com/eggseedd/quietspot.git
cd quietspot

# Get dependencies
flutter pub get

# Generate code (freezed, json_serializable, drift)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## Documentation

📚 **Full documentation available at** [DOCUMENTATION.md](DOCUMENTATION.md)

For detailed guides, see:
- **[Complete Documentation](DOCUMENTATION.md)** - Full API reference, architecture, database schema
- **[Firebase Setup Guide](FIRESTORE_SETUP.md)** - Firestore integration and security rules
- **[Architecture Overview](DOCUMENTATION.md#architecture)** - Clean architecture patterns
- **[Developer Guide](DOCUMENTATION.md#developer-guide)** - Development setup and guidelines

## Architecture

Built with **Clean Architecture** and **offline-first** principles:

```
Flutter UI (Riverpod State Management)
        ↓
Domain Layer (Use Cases & Entities)
        ↓
Data Layer (Firestore + Local SQLite)
```

- **State Management**: Riverpod (providers & async notifiers)
- **Local Storage**: Drift (type-safe SQLite ORM)
- **Remote Storage**: Cloud Firestore
- **Code Generation**: Freezed, json_serializable, build_runner

## Tech Stack

| Category | Technology |
|----------|-----------|
| **Frontend** | Flutter 3.x, Dart 3.x |
| **State Management** | flutter_riverpod |
| **UI Components** | flutter_map, Material Design |
| **Backend** | Firebase (Auth, Firestore, Storage) |
| **Local DB** | Drift + SQLite |
| **Location** | geolocator, geocoding |
| **Audio** | noise_meter |
| **Notifications** | flutter_local_notifications |
| **Code Gen** | freezed, json_serializable |

## Project Structure

```
lib/
├── main.dart                    # App entry point
└── src/
    ├── app.dart                 # Main app widget
    ├── core/                    # Constants, utils, extensions
    ├── data/                    # Local database setup
    ├── features/
    │   ├── auth/                # Authentication feature
    │   └── noise_log/           # Noise recording & visualization
    └── shared/                  # Services, providers, widgets
```

## Screenshots & Demo

📹 **[Watch Full App Demonstration](DOCUMENTATION.md#video-demonstration)** 

Features showcase video covering:
- User registration & login
- Recording noise levels
- Viewing history
- Interactive map exploration
- Data synchronization

## API Usage Example

```dart
// Record a noise log
final noiseLogsNotifier = ref.read(noiseLogsNotifierProvider.notifier);
await noiseLogsNotifier.addNoiseLog(
  latitude: 40.7128,
  longitude: -74.0060,
  rmsValue: 85.5,
  estimatedDb: 75.2,
  classification: 'noisy',
  notes: 'Heavy traffic noise',
);

// Fetch nearby logs
final nearbyLogs = await ref.watch(nearbyNoiseLogsProvider);

// Sync with cloud
final syncManager = ref.watch(firestoreSyncManagerProvider);
await syncManager.syncNow();
```

## Database Schema

### Local Database (SQLite)
- `noiseLogs` table with indexes on userId, timestamp, coordinates

### Firestore
- `noiseLogs` collection (public read, user-owned write)
- Automatic server timestamps for sync tracking

See [DOCUMENTATION.md#database-schema](DOCUMENTATION.md#database-schema) for complete schema.

## Security & Privacy

🔒 **Data Protection**
- User authentication via Firebase Auth
- Firestore security rules enforcing user data ownership
- Location data handled locally with consent
- No third-party data sharing
- Data deletion option available

📋 **Permissions Required**
- Location (GPS tracking)
- Microphone (noise measurement)
- Contacts (optional, for sharing)

## Configuration

### Environment Setup
1. Create Firebase project at [firebase.google.com](https://firebase.google.com)
2. Follow [FIRESTORE_SETUP.md](FIRESTORE_SETUP.md) for detailed configuration
3. Update Firebase credentials in Android/iOS native configs

### Customization
- Sync interval: Modify `firestore_sync_manager.dart` (default: 30 min)
- Noise classification thresholds and classifier: `lib/src/features/noise_log/presentation/add_noise_log_screen.dart` (quiet <50 dB, moderate 50-69 dB, noisy >=70 dB)
- UI themes: `lib/src/shared/widgets/`

## Troubleshooting

**Common Issues & Solutions**:
- Build failures → Run `flutter clean && flutter pub get`
- Firestore connection → Check security rules and authentication
- Location permission → Manually grant in app settings
- Map not loading → Verify Flutter Map dependencies

See [DOCUMENTATION.md#troubleshooting](DOCUMENTATION.md#troubleshooting) for detailed fixes.

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create feature branch: `git checkout -b feature/YourFeature`
3. Commit changes: `git commit -m 'Add YourFeature'`
4. Push to branch: `git push origin feature/YourFeature`
5. Submit Pull Request

## Development

### Code Generation
```bash
# Run code generation
flutter pub run build_runner build

# Watch mode (rebuilds on changes)
flutter pub run build_runner watch

# Clean rebuild
flutter pub run build_runner build --delete-conflicting-outputs
```

### Testing
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Building Releases
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Performance Metrics

⚡ **Optimizations**
- Lazy loading of map markers
- Firestore pagination (limit 50 docs per query)
- Local-first caching with selective sync
- Background sync on schedule to reduce battery drain

## Roadmap (v1.1.0+)

- [ ] Data export (CSV, PDF)
- [ ] Advanced filtering & search
- [ ] Weekly/monthly noise reports
- [ ] Community noise heatmaps
- [ ] Configurable alert thresholds
- [ ] Dark mode
- [ ] Multi-language support
- [ ] REST API for integrations

## License

MIT License - See [LICENSE](LICENSE) file for details

## Support & Contact

- **Author**: eggseedd
- **GitHub**: https://github.com/eggseedd/quietspot
- **Issues**: https://github.com/eggseedd/quietspot/issues
- **Documentation**: [DOCUMENTATION.md](DOCUMENTATION.md)

## Resources

- [Flutter Docs](https://docs.flutter.dev)
- [Firebase Docs](https://firebase.google.com/docs)
- [Riverpod Docs](https://riverpod.dev)
- [Drift DB Docs](https://drift.simonbinder.eu)

---

**Status**: 🟢 Active Development  
**Version**: 1.0.0  
**Last Updated**: April 2026
