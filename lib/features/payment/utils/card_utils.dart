/// Card utility functions
class CardUtils {
  CardUtils._();

  /// Detect card brand from card number
  /// Returns: VISA, MASTERCARD, AMEX, or UNKNOWN
  static String detectCardBrand(String cardNumber) {
    // Remove spaces and non-digits
    final digitsOnly = cardNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.isEmpty) {
      return 'UNKNOWN';
    }
    
    // Visa: starts with 4
    if (digitsOnly.startsWith('4')) {
      return 'VISA';
    }
    
    // Mastercard: starts with 5 or 2
    if (digitsOnly.startsWith('5') || digitsOnly.startsWith('2')) {
      return 'MASTERCARD';
    }
    
    // American Express: starts with 34 or 37
    if (digitsOnly.startsWith('34') || digitsOnly.startsWith('37')) {
      return 'AMEX';
    }
    
    // Discover: starts with 6
    if (digitsOnly.startsWith('6')) {
      return 'DISCOVER';
    }
    
    return 'UNKNOWN';
  }
}

