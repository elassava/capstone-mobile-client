import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/content/domain/entities/content.dart';

class HoverPreviewState {
  final Content? activeContent;
  final Offset? position;
  final bool isScrollActive;

  const HoverPreviewState({
    this.activeContent,
    this.position,
    this.isScrollActive = false,
  });

  HoverPreviewState copyWith({
    Content? activeContent,
    Offset? position,
    bool? isScrollActive,
    bool clearContent = false,
  }) {
    return HoverPreviewState(
      activeContent: clearContent
          ? null
          : (activeContent ?? this.activeContent),
      position: clearContent ? null : (position ?? this.position),
      isScrollActive: isScrollActive ?? this.isScrollActive,
    );
  }
}

class HoverPreviewNotifier extends StateNotifier<HoverPreviewState> {
  HoverPreviewNotifier() : super(const HoverPreviewState());

  void showPreview(Content content, Offset position) {
    if (state.isScrollActive) return;
    state = state.copyWith(activeContent: content, position: position);
  }

  void hidePreview() {
    state = state.copyWith(clearContent: true);
  }

  void setScrollActive(bool isActive) {
    state = state.copyWith(isScrollActive: isActive);
    if (isActive) {
      hidePreview();
    }
  }
}

final hoverPreviewProvider =
    StateNotifierProvider<HoverPreviewNotifier, HoverPreviewState>((ref) {
      return HoverPreviewNotifier();
    });
