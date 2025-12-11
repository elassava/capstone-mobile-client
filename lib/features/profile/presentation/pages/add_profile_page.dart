import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/extensions/snackbar_extension.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/responsive_helper.dart';
import 'package:mobile/core/widgets/netflix_logo.dart';
import 'package:mobile/core/widgets/custom_button.dart';
import 'package:mobile/core/widgets/custom_text_field.dart';
import 'package:mobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:mobile/features/profile/presentation/providers/profile_notifier.dart';

class AddProfilePage extends ConsumerStatefulWidget {
  final String accountId;

  const AddProfilePage({
    super.key,
    required this.accountId,
  });

  @override
  ConsumerState<AddProfilePage> createState() => _AddProfilePageState();
}

class _AddProfilePageState extends ConsumerState<AddProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _profileNameController = TextEditingController();
  final _profileNameFocusNode = FocusNode();

  String? _selectedAvatar;
  String _selectedLanguage = 'tr';
  String _selectedMaturityLevel = 'ALL';
  bool _isChildProfile = false;
  bool _isPinProtected = false;
  final _pinController = TextEditingController();
  bool _obscurePin = true;

  // Cached values for performance
  double? _horizontalPadding;
  double? _spacing;
  AppLocalizations? _localizations;

  // Available languages
  final List<Map<String, String>> _languages = [
    {'code': 'tr', 'name': 'Türkçe'},
    {'code': 'en', 'name': 'English'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'it', 'name': 'Italiano'},
  ];

  // Available maturity levels
  final List<Map<String, String>> _maturityLevels = [
    {'code': 'ALL', 'name': 'Tüm Yaşlar'},
    {'code': 'PG', 'name': 'PG'},
    {'code': 'PG13', 'name': 'PG-13'},
    {'code': 'R', 'name': 'R'},
    {'code': 'NC17', 'name': 'NC-17'},
  ];

  // Available avatars from assets/icons
  final List<String> _avatars = [
    'assets/icons/1.png',
    'assets/icons/2.png',
    'assets/icons/3.png',
    'assets/icons/4.png',
    'assets/icons/5.png',
  ];

  @override
  void dispose() {
    _profileNameController.dispose();
    _profileNameFocusNode.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateProfile() async {
    if (_formKey.currentState!.validate()) {
      final profileName = _profileNameController.text.trim();
      
      // Validate PIN if PIN protection is enabled
      if (_isPinProtected && (_pinController.text.isEmpty || _pinController.text.length < 4)) {
        context.showErrorSnackBar('PIN must be at least 4 characters');
        return;
      }

      await ref.read(profileNotifierProvider.notifier).createProfile(
            accountId: widget.accountId,
            profileName: profileName,
            avatarUrl: _selectedAvatar,
            isChildProfile: _isChildProfile,
            maturityLevel: _selectedMaturityLevel,
            language: _selectedLanguage,
            isPinProtected: _isPinProtected,
            pin: _isPinProtected ? _pinController.text : null,
            isDefault: false, // Backend will set first profile as default
          );

      final profileState = ref.read(profileNotifierProvider);
      if (profileState.isSuccess) {
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    // Cache values on first build only
    _horizontalPadding ??= ResponsiveHelper.getResponsiveHorizontalPadding(context);
    _spacing ??= ResponsiveHelper.getResponsiveSpacing(context);
    _localizations ??= AppLocalizations.of(context)!;

    // Handle errors
    ref.listen<ProfileState>(profileNotifierProvider, (previous, next) {
      if (next.error != null && next.error!.isNotEmpty && previous?.error != next.error) {
        context.showErrorSnackBar(next.error!);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.netflixBlack,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                backgroundColor: AppColors.netflixBlack,
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: const NetflixLogo(),
                centerTitle: true,
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: _horizontalPadding!),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: _spacing! * 2),

                      // Title
                      Text(
                        _localizations!.createProfile,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: _spacing! / 2),

                      // Subtitle
                      Text(
                        _localizations!.createProfileSubtitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(height: _spacing! * 2),

                      // Profile Name
                      CustomTextField(
                        controller: _profileNameController,
                        focusNode: _profileNameFocusNode,
                        hintText: _localizations!.profileNamePlaceholder,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return _localizations!.profileNameRequired;
                          }
                          if (value.trim().length > 50) {
                            return 'Profile name must be 50 characters or less';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: _spacing! * 2),

                      // Avatar Selection
                      Text(
                        _localizations!.selectingAvatar,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: _spacing!),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _avatars.length,
                          itemBuilder: (context, index) {
                            final avatar = _avatars[index];
                            final isSelected = _selectedAvatar == avatar;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedAvatar = avatar;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.netflixRed
                                        : Colors.grey.withValues(alpha: 0.3),
                                    width: isSelected ? 3 : 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.asset(
                                    avatar,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[800],
                                        child: Center(
                                          child: Icon(
                                            Icons.person,
                                            size: 40,
                                            color: Colors.white.withValues(alpha: 0.7),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: _spacing! * 2),

                      // Language Selection
                      Text(
                        _localizations!.selectingLanguage,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: _spacing!),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: _spacing!),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[700]!),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedLanguage,
                          isExpanded: true,
                          dropdownColor: Colors.grey[900],
                          style: const TextStyle(color: Colors.white),
                          underline: Container(),
                          items: _languages.map((lang) {
                            return DropdownMenuItem<String>(
                              value: lang['code'],
                              child: Text(lang['name']!),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedLanguage = value;
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(height: _spacing! * 2),

                      // Maturity Level Selection
                      Text(
                        _localizations!.selectingMaturityLevel,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: _spacing!),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: _spacing!),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[700]!),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedMaturityLevel,
                          isExpanded: true,
                          dropdownColor: Colors.grey[900],
                          style: const TextStyle(color: Colors.white),
                          underline: Container(),
                          items: _maturityLevels.map((level) {
                            return DropdownMenuItem<String>(
                              value: level['code'],
                              child: Text(level['name']!),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedMaturityLevel = value;
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(height: _spacing! * 2),

                      // Child Profile Toggle
                      SwitchListTile(
                        title: const Text(
                          'Child Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: const Text(
                          'This profile is for a child',
                          style: TextStyle(color: Colors.grey),
                        ),
                        value: _isChildProfile,
                        onChanged: (value) {
                          setState(() {
                            _isChildProfile = value;
                            if (value) {
                              _selectedMaturityLevel = 'ALL';
                            }
                          });
                        },
                        activeColor: AppColors.netflixRed,
                      ),
                      SizedBox(height: _spacing!),

                      // PIN Protection Toggle
                      SwitchListTile(
                        title: const Text(
                          'PIN Protection',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: const Text(
                          'Protect this profile with a PIN',
                          style: TextStyle(color: Colors.grey),
                        ),
                        value: _isPinProtected,
                        onChanged: (value) {
                          setState(() {
                            _isPinProtected = value;
                            if (!value) {
                              _pinController.clear();
                            }
                          });
                        },
                        activeColor: AppColors.netflixRed,
                      ),

                      // PIN Input (shown only if PIN protection is enabled)
                      if (_isPinProtected) ...[
                        SizedBox(height: _spacing!),
                        CustomTextField(
                          controller: _pinController,
                          hintText: 'Enter 4-8 digit PIN',
                          obscureText: _obscurePin,
                          keyboardType: TextInputType.number,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePin ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey[400],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePin = !_obscurePin;
                              });
                            },
                          ),
                          validator: (value) {
                            if (_isPinProtected) {
                              if (value == null || value.isEmpty) {
                                return 'PIN is required';
                              }
                              if (value.length < 4 || value.length > 8) {
                                return 'PIN must be between 4 and 8 digits';
                              }
                            }
                            return null;
                          },
                        ),
                      ],

                      SizedBox(height: _spacing! * 2),

                      // Create Button
                      CustomButton(
                        text: profileState.isCreating
                            ? '${_localizations!.createProfile}...'
                            : _localizations!.createProfile,
                        onPressed: profileState.isCreating ? null : _handleCreateProfile,
                      ),

                      SizedBox(height: _spacing! * 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

