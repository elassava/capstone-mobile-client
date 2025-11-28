import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/extensions/snackbar_extension.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/theme/app_colors.dart';
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

  // Available avatars from assets/icons
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
    // Default avatar
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
            language: 'tr', // Default to TR for now, can be expanded
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: Text(
          AppLocalizations.of(context)!.selectingAvatar,
          style: const TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: 400,
          height: 300,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
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
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                    borderRadius: BorderRadius.circular(4),
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
              style: const TextStyle(color: Colors.white),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 48.0,
                  vertical: 24.0,
                ),
                child: Row(
                  children: [
                    const SizedBox(height: 35, child: NetflixLogo()),
                    const Spacer(),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            localizations.addProfile,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            localizations.createProfileSubtitle,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 48),

                          Divider(color: Colors.grey.withValues(alpha: 0.3)),
                          const SizedBox(height: 32),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar Selection
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: _showAvatarSelectionDialog,
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        image: DecorationImage(
                                          image: AssetImage(_selectedAvatar!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Simple avatar cycler for now
                                  TextButton(
                                    onPressed: _showAvatarSelectionDialog,
                                    child: const Text(
                                      'Change', // TODO: Localize
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 32),

                              // Form Fields
                              Expanded(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF333333),
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: _profileNameController,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: localizations
                                                .profileNamePlaceholder,
                                            hintStyle: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return localizations
                                                  .profileNameRequired;
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 24),

                                      // Kid Profile Checkbox
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: Checkbox(
                                              value: _isChildProfile,
                                              onChanged: (value) {
                                                setState(() {
                                                  _isChildProfile =
                                                      value ?? false;
                                                });
                                              },
                                              fillColor:
                                                  WidgetStateProperty.resolveWith(
                                                    (states) {
                                                      if (states.contains(
                                                        WidgetState.selected,
                                                      )) {
                                                        return Colors.white;
                                                      }
                                                      return Colors.transparent;
                                                    },
                                                  ),
                                              checkColor: Colors.black,
                                              side: const BorderSide(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Text(
                                            'Kid?',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
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

                          const SizedBox(height: 32),
                          Divider(color: Colors.grey.withValues(alpha: 0.3)),
                          const SizedBox(height: 32),

                          // Buttons
                          Row(
                            children: [
                              SizedBox(
                                width: 150,
                                height: 40,
                                child: CustomButton(
                                  text: profileState.isCreating
                                      ? '${localizations.continueButton}...'
                                      : localizations.continueButton,
                                  onPressed: profileState.isCreating
                                      ? null
                                      : _handleCreateProfile,
                                  backgroundColor: AppColors.netflixRed,
                                  foregroundColor: Colors.white,
                                  borderRadius: 0, // Rectangular
                                  style: CustomButtonStyle.flat,
                                ),
                              ),
                              const SizedBox(width: 24),
                              OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.grey),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 18,
                                  ), // Match height roughly
                                ),
                                child: Text(
                                  localizations.cancel,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
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
