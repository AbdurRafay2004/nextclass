import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A reusable widget that displays a user-friendly error state with a
/// retry button. Designed for database errors (e.g. MdbxError) on low-end
/// devices where transient failures are expected.
///
/// Usage inside `AsyncValue.when()`:
/// ```dart
/// error: (e, st) => DatabaseErrorWidget(
///   error: e,
///   onRetry: () => ref.invalidate(someProvider),
/// ),
/// ```
class DatabaseErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  final String? message;

  const DatabaseErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
    this.message,
  });

  /// Returns true if the error looks like a transient MDBX lock error.
  static bool isMdbxError(Object error) {
    final msg = error.toString();
    return msg.contains('MdbxError') || msg.contains('Try again');
  }

  @override
  Widget build(BuildContext context) {
    final isTransient = isMdbxError(error);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isTransient ? Icons.refresh_rounded : Icons.error_outline_rounded,
              size: 56,
              color: AppColors.mutedText(context),
            ),
            const SizedBox(height: 16),
            Text(
              isTransient ? 'Temporary Issue' : 'Something Went Wrong',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message ??
                  (isTransient
                      ? 'The database is busy. Tap retry to try again.'
                      : 'An unexpected error occurred.'),
              style: AppTextStyles.emptyStateMessage(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
