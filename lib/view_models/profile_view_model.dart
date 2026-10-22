import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_mvvm_template/models/entities/appearance.dart';
import 'package:flutter_mvvm_template/store/appearance_controller.dart';
import 'package:flutter_mvvm_template/store/auth_state_provider.dart';
import 'package:flutter_mvvm_template/store/session_provider.dart';

@immutable
class ProfileState {
  const ProfileState({
    required this.fullName,
    required this.phone,
    required this.appearance,
    this.isSigningOut = false,
  });

  final String fullName;
  final String phone;
  final Appearance appearance;
  final bool isSigningOut;

  String get initials {
    final parts = fullName.split(' ').where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  ProfileState copyWith({bool? isSigningOut}) => ProfileState(
    fullName: fullName,
    phone: phone,
    appearance: appearance,
    isSigningOut: isSigningOut ?? this.isSigningOut,
  );
}

class ProfileViewModel extends AutoDisposeNotifier<ProfileState> {
  @override
  ProfileState build() {
    final user = ref.watch(sessionProvider.select((s) => s?.user));
    return ProfileState(
      fullName: user?.fullName ?? '',
      phone: user?.phone ?? '',
      appearance: ref.watch(appearanceProvider),
    );
  }

  Future<void> setAppearance(Appearance appearance) =>
      ref.read(appearanceProvider.notifier).set(appearance);

  Future<void> signOut() async {
    if (state.isSigningOut) return;
    state = state.copyWith(isSigningOut: true);
    await ref.read(authStateProvider.notifier).signOut();
  }
}

final profileViewModelProvider =
    NotifierProvider.autoDispose<ProfileViewModel, ProfileState>(
      ProfileViewModel.new,
    );
