import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/extensions/snackbar_extension.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/web_responsive.dart';
import 'package:mobile/core/widgets/netflix_logo.dart';
import 'package:mobile/core/widgets/custom_button.dart';
import 'package:mobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:mobile/features/profile/presentation/providers/profile_notifier.dart';

class WebAddProfilePage extends ConsumerStatefulWidget {
  final int accountId;

  const WebAddProfilePage({super.key, required this.accountId});

  @override
  ConsumerState<WebAddProfilePage> createState() => _WebAddProfilePageState();
}

class _WebAddProfilePageState extends ConsumerState<WebAddProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _profileNameController = TextEditingController();

  String? _selectedAvatar;
  bool _isChildProfile = false;

  final List<String> _avatars = [
    'assets/icons/1.png',
    'assets/icons/2.png',
    'assets/icons/3.png',
    'assets/icons/4.png',
    'assets/icons/5.png',
  ];

  @override
  void initState() {
    super.initState();
    _selectedAvatar = _avatars[0];
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateProfile() async {
    if (_formKey.currentState!.validate()) {
      final profileName = _profileNameController.text.trim();

      await ref
          .read(profileNotifierProvider.notifier)
          .createProfile(
            accountId: widget.accountId,
            profileName: profileName,
            avatarUrl: _selectedAvatar,
            isChildProfile: _isChildProfile,
            maturityLevel: _isChildProfile ? 'PG' : 'ALL',
            language: 'tr',
            isPinProtected: false,
            isDefault: false,
          );

      final profileState = ref.read(profileNotifierProvider);
      if (profileState.isSuccess && mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  void _showAvatarSelectionDialog() {
    final scaler = context.responsive;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: Text(
          AppLocalizations.of(context)!.selectingAvatar,
          style: TextStyle(
            color: Colors.white,
            fontSize: scaler.sp(20),
          ),
        ),
        content: SizedBox(
          width: scaler.w(400),
          height: scaler.h(300),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: scaler.w(16),
              mainAxisSpacing: scaler.h(16),
            ),
            itemCount: _avatars.length,
            itemBuilder: (context, index) {
              final avatar = _avatars[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAvatar = avatar;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: _selectedAvatar == avatar
                        ? Border.all(color: Colors.white, width: scaler.s(3))
                        : null,
                    borderRadius: scaler.borderRadius(4),
                    image: DecorationImage(
                      image: AssetImage(avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                color: Colors.white,
                fontSize: scaler.sp(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final profileState = ref.watch(profileNotifierProvider);
    final scaler = context.responsive;

    ref.listen<ProfileState>(profileNotifierProvider, (previous, next) {
      if (next.error != null &&
          next.error!.isNotEmpty &&
          previous?.error != next.error) {
        context.showErrorSnackBar(next.error!);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.netflixBlack,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  AppColors.netflixDarkGray.withValues(alpha: 0.3),
                  AppColors.netflixBlack,
                ],
              ),
            ),
          ),

          Column(
            children: [
              // Navbar
              Padding(
                padding: scaler.paddingSymmetric(horizontal: 48, vertical: 24),
                child: Row(
                  children: [
                    SizedBox(
                      height: scaler.h(35),
                      child: const NetflixLogo(),
                    ),
                    const Spacer(),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: scaler.padding(24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: scaler.w(600)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            localizations.addProfile,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: scaler.sp(48),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          scaler.verticalSpace(16),
                          Text(
                            localizations.createProfileSubtitle,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: scaler.sp(18),
                            ),
                          ),
                          scaler.verticalSpace(48),

                          Divider(color: Colors.grey.withValues(alpha: 0.3)),
                          scaler.verticalSpace(32),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar Selection
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: _showAvatarSelectionDialog,
                                    child: Container(
                                      width: scaler.s(120),
                                      height: scaler.s(120),
                                      decoration: BoxDecoration(
                                        borderRadius: scaler.borderRadius(4),
                                        image: DecorationImage(
                                          image: AssetImage(_selectedAvatar!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  scaler.verticalSpace(16),
                                  TextButton(
                                    onPressed: _showAvatarSelectionDialog,
                                    child: Text(
                                      'Change',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: scaler.sp(14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              scaler.horizontalSpace(32),

                              // Form Fields
                              Expanded(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: scaler.paddingSymmetric(
                                          horizontal: 16,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF333333),
                                          borderRadius: scaler.borderRadius(2),
                                        ),
                                        child: TextFormField(
                                          controller: _profileNameController,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: scaler.sp(16),
                                          ),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: localizations.profileNamePlaceholder,
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: scaler.sp(16),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.trim().isEmpty) {
                                              return localizations.profileNameRequired;
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      scaler.verticalSpace(24),

                                      // Kid Profile Checkbox
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: scaler.s(24),
                                            width: scaler.s(24),
                                            child: Checkbox(
                                              value: _isChildProfile,
                                              onChanged: (value) {
                                                setState(() {
                                                  _isChildProfile = value ?? false;
                                                });
                                              },
                                              fillColor: WidgetStateProperty.resolveWith((states) {
                                                if (states.contains(WidgetState.selected)) {
                                                  return Colors.white;
                                                }
                                                return Colors.transparent;
                                              }),
                                              checkColor: Colors.black,
                                              side: const BorderSide(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          scaler.horizontalSpace(12),
                                          Text(
                                            'Kid?',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: scaler.sp(16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          scaler.verticalSpace(32),
                          Divider(color: Colors.grey.withValues(alpha: 0.3)),
                          scaler.verticalSpace(32),

                          // Buttons
                          Row(
                            children: [
                              SizedBox(
                                width: scaler.w(150),
                                height: scaler.h(40),
                                child: CustomButton(
                                  text: profileState.isCreating
                                      ? '${localizations.continueButton}...'
                                      : localizations.continueButton,
                                  onPressed: profileState.isCreating
                                      ? null
                                      : _handleCreateProfile,
                                  backgroundColor: AppColors.netflixRed,
                                  foregroundColor: Colors.white,
                                  borderRadius: 0,
                                  style: CustomButtonStyle.flat,
                                ),
                              ),
                              scaler.horizontalSpace(24),
                              OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.grey),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  padding: scaler.paddingSymmetric(
                                    horizontal: 32,
                                    vertical: 18,
                                  ),
                                ),
                                child: Text(
                                  localizations.cancel,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: scaler.sp(16),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
