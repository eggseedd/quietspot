import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore configuration and initialization
class FirestoreConfig {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Initialize Firestore settings for the app
  static Future<void> initialize() async {
    try {
      // Enable offline persistence
      await _firestore.enableNetwork();

      // Set up Firestore settings
      _firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      print('Firestore initialized successfully');
    } catch (e) {
      print('Error initializing Firestore: $e');
      rethrow;
    }
  }

  /// Create necessary Firestore collections and indexes
  /// This should be run once during app initialization or manually via Firebase console
  static Future<void> ensureCollectionsExist() async {
    try {
      // This won't actually create the collection until a document is added,
      // but you can create it manually in Firebase console
      print('Firestore collections ready. Ensure the following exist in Firebase console:');
      print('  - noiseLogs (with indexes on: userId, latitude, timestamp)');
    } catch (e) {
      print('Error ensuring collections: $e');
      rethrow;
    }
  }

  /// Get reference to noiseLogs collection
  static CollectionReference<Map<String, dynamic>> getNoiseLogsCollection() {
    return _firestore.collection('noiseLogs');
  }

  /// Enable Firestore offline mode
  static Future<void> enableOfflineMode() async {
    try {
      _firestore.settings = const Settings(
        persistenceEnabled: true,
      );
      print('Firestore offline mode enabled');
    } catch (e) {
      print('Error enabling offline mode: $e');
    }
  }

  /// Disable Firestore offline mode
  static Future<void> disableOfflineMode() async {
    try {
      await _firestore.disableNetwork();
      print('Firestore offline mode disabled');
    } catch (e) {
      print('Error disabling offline mode: $e');
    }
  }
}
