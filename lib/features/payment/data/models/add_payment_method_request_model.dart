/// Add Payment Method Request Model (DTO)
class AddPaymentMethodRequestModel {
  final String cardHolderName;
  final String cardNumber;
  final String expiryMonth;
  final String expiryYear;
  final String cvv;
  final String cardBrand;
  final bool setAsDefault;

  AddPaymentMethodRequestModel({
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvv,
    required this.cardBrand,
    this.setAsDefault = false,
  });

  /// Convert AddPaymentMethodRequestModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'cardHolderName': cardHolderName,
      'cardNumber': cardNumber,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'cvv': cvv,
      'cardBrand': cardBrand,
      'setAsDefault': setAsDefault,
    };
  }
}

