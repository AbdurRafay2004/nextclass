import 'dart:convert';
import 'dart:io';

import '../domain/schedule_share_dto.dart';

/// Exception thrown when QR payload decoding fails.
class ShareDecodeException implements Exception {
  final String message;
  ShareDecodeException(this.message);

  @override
  String toString() => 'ShareDecodeException: $message';
}

/// Service responsible for decoding a QR payload back into a DTO.
///
/// Pipeline: Base64 → GZIP decompress → JSON → ScheduleShareDTO
class ShareDecoderService {
  /// Decodes a Base64-encoded, GZIP-compressed payload into a [ScheduleShareDTO].
  ///
  /// Throws [ShareDecodeException] if the payload is malformed.
  ScheduleShareDTO decode(String base64Payload) {
    try {
      // Base64 → bytes
      final gzippedBytes = base64Decode(base64Payload);

      // GZIP decompress → JSON bytes
      final jsonBytes = gzip.decode(gzippedBytes);

      // JSON bytes → String → Map
      final jsonString = utf8.decode(jsonBytes);
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;

      // Map → DTO
      return ScheduleShareDTO.fromJson(jsonMap);
    } on FormatException catch (e) {
      throw ShareDecodeException('Invalid QR data format: ${e.message}');
    } on TypeError catch (e) {
      throw ShareDecodeException('Unexpected data structure: $e');
    } catch (e) {
      throw ShareDecodeException('Failed to decode QR data: $e');
    }
  }
}
