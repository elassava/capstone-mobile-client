/// Create Profile Request Model (DTO)
class CreateProfileRequestModel {
  final String accountId;
  final String profileName;
  final String? avatarUrl;
  final bool isChildProfile;
  final String maturityLevel;
  final String language;
  final bool isPinProtected;
  final String? pin;
  final bool isDefault;

  CreateProfileRequestModel({
    required this.accountId,
    required this.profileName,
    this.avatarUrl,
    this.isChildProfile = false,
    this.maturityLevel = 'ALL',
    this.language = 'tr',
    this.isPinProtected = false,
    this.pin,
    this.isDefault = false,
  });

  /// Convert CreateProfileRequestModel to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'accountId': accountId,
      'profileName': profileName,
      'isChildProfile': isChildProfile,
      'maturityLevel': maturityLevel,
      'language': language,
      'isPinProtected': isPinProtected,
      'isDefault': isDefault,
    };
    
    if (avatarUrl != null) {
      json['avatarUrl'] = avatarUrl;
    }
    
    if (pin != null && pin!.isNotEmpty) {
      json['pin'] = pin;
    }
    
    return json;
  }
}

