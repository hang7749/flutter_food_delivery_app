import 'package:flutter_dotenv/flutter_dotenv.dart';

class StripeConfig {
  static String get publishableKey {
    return dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  }

  // This should only be used in your backend server
  static String get secretKey {
    try {
      return dotenv.env['STRIPE_SECRET_KEY'] ?? '';
    } catch (e) {
      // Handle the error or log it
      throw Exception('Secret key should only be accessed from server');
    }
  }
}