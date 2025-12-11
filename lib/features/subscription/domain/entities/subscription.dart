/// Subscription Entity
class Subscription {
  final String id;
  final String planName;
  final String status;
  final String billingCycle;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? cancelledAt;

  Subscription({
    required this.id,
    required this.planName,
    required this.status,
    required this.billingCycle,
    required this.startDate,
    required this.endDate,
    this.cancelledAt,
  });

  bool get isActive => status == 'ACTIVE';
}

