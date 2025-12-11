/// Payment Method Response Model (DTO)
class PaymentMethodResponseModel {
  final String id;
  final String type;
  final String cardHolderName;
  final String lastFourDigits;
  final String cardBrand;
  final String expiryMonth;
  final String expiryYear;
  final bool isDefault;
  final bool isActive;

  PaymentMethodResponseModel({
    required this.id,
    required this.type,
    required this.cardHolderName,
    required this.lastFourDigits,
    required this.cardBrand,
    required this.expiryMonth,
    required this.expiryYear,
    required this.isDefault,
    required this.isActive,
  });

  /// Convert JSON to PaymentMethodResponseModel
  factory PaymentMethodResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodResponseModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] as String,
      cardHolderName: json['cardHolderName'] as String,
      lastFourDigits: json['lastFourDigits'] as String,
      cardBrand: json['cardBrand'] as String,
      expiryMonth: json['expiryMonth'] as String,
      expiryYear: json['expiryYear'] as String,
      isDefault: json['isDefault'] as bool,
      isActive: json['isActive'] as bool,
    );
  }
}

