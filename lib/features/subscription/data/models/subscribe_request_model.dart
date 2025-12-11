/// Subscribe Request Model (DTO)
class SubscribeRequestModel {
  final String planName;
  final String billingCycle;
  final String? paymentMethodId;

  SubscribeRequestModel({
    required this.planName,
    required this.billingCycle,
    this.paymentMethodId,
  });

  /// Convert SubscribeRequestModel to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'planName': planName,
      'billingCycle': billingCycle,
    };
    if (paymentMethodId != null) {
      json['paymentMethodId'] = paymentMethodId;
    }
    return json;
  }
}

