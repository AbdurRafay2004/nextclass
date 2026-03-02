import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

/// A simple async mutex that ensures only one write transaction runs at a time.
///
/// MDBX (Isar's storage engine) uses a single-writer model. Concurrent
/// [Isar.writeTxn] calls cause `MdbxError (11): Try again` — especially on
/// low-end 32-bit (armeabi-v7a) devices with slow eMMC storage where lock
/// hold times are longer.
///
/// Usage: wrap every [Isar.writeTxn] call with [serializedWrite] to queue
/// writes so they never contend for the MDBX writer lock.
class DatabaseWriteSerializer {
  /// Queue tail — each new writer awaits the previous one's future before
  /// acquiring the lock.
  Future<void> _lastWrite = Future.value();

  /// Enqueue [operation] so it runs after all previously enqueued writes
  /// have completed. Returns the result of [operation].
  ///
  /// If [operation] throws, subsequent queued writes still proceed.
  Future<T> serializedWrite<T>(Future<T> Function() operation) {
    final previousWrite = _lastWrite;
    final completer = Completer<void>();
    _lastWrite = completer.future;

    return previousWrite.then((_) async {
      try {
        return await operation();
      } finally {
        completer.complete();
      }
    });
  }

  /// Wraps an operation with exponential-backoff retry logic targeting
  /// specifically the `MdbxError (11): Try again` transient lock error.
  ///
  /// Parameters:
  /// - [maxRetries]: Maximum number of attempts (default: 5).
  /// - [baseDelay]: Initial delay before the first retry (default: 100ms).
  ///
  /// Backoff schedule (defaults): 100ms → 200ms → 400ms → 800ms → give up.
  /// Total maximum wait: ~1.5 seconds, which accommodates slow eMMC I/O.
  Future<T> withRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 5,
    Duration baseDelay = const Duration(milliseconds: 100),
  }) async {
    for (var attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        return await operation();
      } catch (e) {
        if (_isMdbxRetryError(e) && attempt < maxRetries) {
          final delay = baseDelay * pow(2, attempt - 1).toInt();
          await Future.delayed(delay);
        } else {
          rethrow;
        }
      }
    }
    // Unreachable — the loop always returns or rethrows.
    throw StateError('Unreachable: retry loop exited without result');
  }

  /// Convenience method: serialize + retry a write operation.
  ///
  /// This is the recommended way to perform all Isar write transactions.
  /// It first queues the write behind any in-flight writes, then retries
  /// on transient MDBX lock errors.
  Future<T> safeWrite<T>(Future<T> Function() operation) {
    return serializedWrite(() => withRetry(operation));
  }

  /// Detects the specific `MdbxError (11): Try again` error from Isar.
  static bool _isMdbxRetryError(Object error) {
    if (error is IsarError) {
      final msg = error.toString();
      return msg.contains('MdbxError') && msg.contains('Try again');
    }
    return false;
  }
}

/// Global singleton provider for the write serializer.
///
/// All controllers and services should use this to perform write operations.
final databaseWriteSerializerProvider = Provider<DatabaseWriteSerializer>(
  (ref) => DatabaseWriteSerializer(),
);
