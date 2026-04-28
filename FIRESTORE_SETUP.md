# Firestore Integration Setup Guide

## Overview
This guide explains the Firestore integration for QuietSpot, including architecture, setup steps, and usage examples.

## Architecture

### Data Flow
```
User Records Noise → Local DB (Drift) → Background Sync → Firestore
                                              ↓
                                    Auto-synced every 30 mins
```

### Component Structure
- **NoiseLogRemoteDataSource**: Handles all Firestore operations
- **FirestoreSyncManager**: Manages periodic sync every 30 minutes (configurable)
- **SurroundingNoiseService**: Handles periodic fetching of nearby logs hourly
- **NoiseLogRepositoryImpl**: Bridges local & remote with dual-source pattern

---

## Setup Instructions

### 1. Firestore Collection Structure

Create the following in Firebase Console:

**Collection: `noiseLogs`**

Document structure:
```json
{
  "id": "uuid",
  "userId": "user-id",
  "timestamp": "Timestamp",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "locationName": "Times Square, New York",
  "rmsValue": 95.5,
  "estimatedDb": 85.2,
  "classification": "noisy",
  "manualLabel": "traffic",
  "notes": "Heavy traffic noise",
  "isDeleted": false,
  "syncedAt": "Timestamp (server)",
  "updatedAt": "Timestamp (server, optional)",
  "deletedAt": "Timestamp (server, optional)"
}
```

### 2. Firestore Security Rules

Add these rules to your Firestore security settings:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /noiseLogs/{document=**} {
      // Everyone can read all noise logs (public data)
      allow read: if true;
      
      // Only authenticated users can create new logs
      allow create: if request.auth != null;
      
      // Users can only update/delete their own logs
      allow update, delete: if request.auth != null && 
                              request.resource.data.userId == request.auth.uid;
    }
  }
}
```

### 3. Firestore Indexes

Create these composite indexes in Firebase Console for optimal performance:

**Index 1: noiseLogs**
- Collection: `noiseLogs`
- Fields: `isDeleted` (Ascending), `timestamp` (Descending)
- Status: Enabled

**Index 2: noiseLogs (Geo queries)**
- Collection: `noiseLogs`
- Fields: `isDeleted` (Ascending), `latitude` (Ascending), `longitude` (Ascending)
- Status: Enabled

You can create these automatically by running a query in Firebase Console, or manually via the Indexes tab.

---

## Usage Examples

### 1. Start Background Sync (Recommended on Login)

```dart
// In your auth/login flow
final syncManager = ref.watch(firestoreSyncManagerProvider);
final userId = ref.watch(currentUserIdProvider);

// Start syncing every 30 minutes (or custom interval)
if (userId != null) {
  syncManager.startPeriodicSync(
    userId: userId,
    interval: const Duration(minutes: 30),
  );
}
```

### 2. Create a Noise Log (Automatically Syncs)

```dart
final repository = ref.watch(noiseLogRepositoryProvider);

final log = NoiseLogModel(
  id: uuid.v4(),
  userId: userId,
  timestamp: DateTime.now(),
  latitude: 40.7128,
  longitude: -74.0060,
  locationName: 'Times Square',
  rmsValue: 95.5,
  estimatedDb: 85.2,
  classification: NoiseClassification.noisy,
  notes: 'Heavy traffic',
);

// This saves locally AND syncs to Firestore in background
await repository.addNoiseLog(log);
```

### 3. Fetch Nearby Noises for Map View

```dart
final repository = ref.watch(noiseLogRepositoryProvider);

// Fetch all logs within 5km radius
final nearbyLogs = await repository.fetchNearbyNoiseLogs(
  latitude: 40.7128,
  longitude: -74.0060,
  radiusInKm: 5.0,
);
```

### 4. Using Riverpod Provider (Recommended)

```dart
// Fetch nearby logs with auto-refresh
final nearbyLogs = ref.watch(
  nearbyNoiseLogsProvider((40.7128, -74.0060, 5.0))
);

nearbyLogs.when(
  data: (logs) => displayOnMap(logs),
  loading: () => showLoadingSpinner(),
  error: (err, stack) => showErrorMessage(err.toString()),
);
```

### 5. Start Periodic Fetching of Surrounding Noises

```dart
final surroundingService = ref.watch(surroundingNoiseServiceProvider);
final userLocation = getCurrentUserLocation(); // Get from location service

// Start fetching every hour
surroundingService.startPeriodicFetch(
  latitude: userLocation.latitude,
  longitude: userLocation.longitude,
  radiusInKm: 5.0,
  interval: const Duration(hours: 1),
);

// Optionally add a listener for updates
surroundingService.addListener((logs) {
  // Update map UI with new logs
  updateMapWithLogs(logs);
});
```

---

## Configuration

### Sync Intervals
- **Firestore Sync**: Every 30 minutes (in FirestoreSyncManager.startPeriodicSync)
- **Nearby Logs Fetch**: Every 1 hour (in SurroundingNoiseService.startPeriodicFetch)
- **Local Log Cleanup**: Every 3 hours (in NoiseLogCleanupService)

### Modify Intervals

```dart
// Change sync interval to 15 minutes
syncManager.startPeriodicSync(
  userId: userId,
  interval: const Duration(minutes: 15),
);

// Change surrounding noise fetch to 30 minutes
surroundingService.startPeriodicFetch(
  latitude: lat,
  longitude: lon,
  radiusInKm: 5.0,
  interval: const Duration(minutes: 30),
);
```

### Geo-Query Radius
The current implementation uses a bounding box with distance verification. For large-scale apps, consider implementing:
- GeoFire library for better geospatial indexing
- Geohashing on client-side for pre-filtering

---

## Data Privacy & Security

✅ **What's Shared**:
- Noise level (estimatedDb)
- Classification (quiet/moderate/noisy)
- Location (latitude, longitude, locationName)
- Manual label & notes (user chose to share)
- Timestamp

✅ **What's Private**:
- No personal user information (use security rules)
- Users can only modify/delete their own data
- Public read access (for map viewing)

---

## Troubleshooting

### Logs Not Syncing
1. Check internet connection
2. Verify Firestore security rules allow `create`
3. Check Firebase Console for any errors
4. Manually trigger sync: `await syncManager.syncNow(userId)`

### Queries Too Slow
1. Ensure indexes are created (check Firebase Console)
2. Reduce radius for nearby queries
3. Implement pagination for large datasets

### Offline Issues
- App automatically handles offline mode via Firestore's persistence
- Logs are queued and synced when online

---

## API Reference

### Repository Methods

```dart
// Sync local logs to Firestore
Future<void> syncNoiseLogsToFirestore(String userId)

// Fetch all public noise logs
Future<List<NoiseLogModel>> fetchRemoteNoiseLogs()

// Fetch logs within radius
Future<List<NoiseLogModel>> fetchNearbyNoiseLogs(
  double latitude,
  double longitude,
  double radiusInKm,
)

// Update remote log
Future<void> updateRemoteNoiseLog(NoiseLogModel log)

// Delete remote log (soft delete)
Future<void> deleteRemoteNoiseLog(String logId)
```

### Providers

```dart
// Auto-sync manager
firestoreSyncManagerProvider

// Surrounding noise service
surroundingNoiseServiceProvider

// Fetch all remote logs
remoteNoiseLogsProvider

// Fetch nearby logs
nearbyNoiseLogsProvider((lat, lon, radius))

// Manual sync trigger
syncNoiseLogsProvider(userId)
```
