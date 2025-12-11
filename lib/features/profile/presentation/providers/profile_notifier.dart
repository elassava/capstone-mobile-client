import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/profile/domain/entities/profile.dart';
import 'package:mobile/features/profile/domain/usecases/get_profiles_usecase.dart';
import 'package:mobile/features/profile/domain/usecases/create_profile_usecase.dart';
import 'package:mobile/features/profile/domain/usecases/delete_profile_usecase.dart';

/// Profile State
class ProfileState {
  final bool isLoading;
  final List<Profile> profiles;
  final bool isCreating;
  final bool isDeleting;
  final String? error;
  final bool isSuccess;
  final int? maxProfiles;

  const ProfileState({
    this.isLoading = false,
    this.profiles = const [],
    this.isCreating = false,
    this.isDeleting = false,
    this.error,
    this.isSuccess = false,
    this.maxProfiles,
  });

  ProfileState copyWith({
    bool? isLoading,
    List<Profile>? profiles,
    bool? isCreating,
    bool? isDeleting,
    String? error,
    bool? isSuccess,
    int? maxProfiles,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profiles: profiles ?? this.profiles,
      isCreating: isCreating ?? this.isCreating,
      isDeleting: isDeleting ?? this.isDeleting,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
      maxProfiles: maxProfiles ?? this.maxProfiles,
    );
  }

  bool get canAddMoreProfiles {
    if (maxProfiles == null) return true;
    return profiles.length < maxProfiles!;
  }

  int get remainingProfileSlots {
    if (maxProfiles == null) return 0;
    return (maxProfiles! - profiles.length).clamp(0, maxProfiles!);
  }
}

/// Profile Notifier - Manages profile state
class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetProfilesUseCase _getProfilesUseCase;
  final CreateProfileUseCase _createProfileUseCase;
  final DeleteProfileUseCase _deleteProfileUseCase;

  ProfileNotifier(
    this._getProfilesUseCase,
    this._createProfileUseCase,
    this._deleteProfileUseCase,
  ) : super(const ProfileState());

  /// Fetch profiles for an account
  Future<void> fetchProfiles(String accountId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final profiles = await _getProfilesUseCase.execute(accountId);
      state = state.copyWith(
        isLoading: false,
        profiles: profiles,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Set max profiles from subscription plan
  void setMaxProfiles(int maxProfiles) {
    state = state.copyWith(maxProfiles: maxProfiles);
  }

  /// Create a new profile
  Future<void> createProfile({
    required String accountId,
    required String profileName,
    String? avatarUrl,
    bool isChildProfile = false,
    String maturityLevel = 'ALL',
    String language = 'tr',
    bool isPinProtected = false,
    String? pin,
    bool isDefault = false,
  }) async {
    state = state.copyWith(isCreating: true, error: null, isSuccess: false);

    try {
      final profile = await _createProfileUseCase.execute(
        accountId: accountId,
        profileName: profileName,
        avatarUrl: avatarUrl,
        isChildProfile: isChildProfile,
        maturityLevel: maturityLevel,
        language: language,
        isPinProtected: isPinProtected,
        pin: pin,
        isDefault: isDefault,
      );
      
      // Add new profile to list
      final updatedProfiles = [...state.profiles, profile];
      
      state = state.copyWith(
        isCreating: false,
        profiles: updatedProfiles,
        isSuccess: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        error: e.toString().replaceAll('Exception: ', ''),
        isSuccess: false,
      );
    }
  }

  /// Delete a profile
  Future<void> deleteProfile({
    required String profileId,
    required String accountId,
  }) async {
    state = state.copyWith(isDeleting: true, error: null, isSuccess: false);

    try {
      await _deleteProfileUseCase.execute(
        profileId: profileId,
        accountId: accountId,
      );
      
      // Remove deleted profile from list
      final updatedProfiles = state.profiles.where((p) => p.id != profileId).toList();
      
      state = state.copyWith(
        isDeleting: false,
        profiles: updatedProfiles,
        isSuccess: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isDeleting: false,
        error: e.toString().replaceAll('Exception: ', ''),
        isSuccess: false,
      );
    }
  }

  /// Reset state
  void reset() {
    state = const ProfileState();
  }
}

