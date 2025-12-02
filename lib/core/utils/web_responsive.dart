import 'package:flutter/material.dart';

/// Web için optimize edilmiş responsive ölçekleme sistemi
///
/// Design reference: 1920x1080 (Full HD)
/// Tüm boyutlar bu referansa göre ölçeklenir
///
/// Kullanım:
/// ```dart
/// final scaler = WebResponsive.of(context);
/// Container(
///   width: scaler.w(350),  // 350px @ 1920px genişlik için ölçeklenmiş
///   height: scaler.h(200), // 200px @ 1080px yükseklik için ölçeklenmiş
///   padding: scaler.padding(20), // Tüm yönlerde ölçeklenmiş padding
/// )
/// ```
class WebResponsive {
  // Design referans boyutları - 1440p kullanarak daha büyük elementler
  static const double _designWidth = 1440.0;
  static const double _designHeight = 900.0;

  // Minimum ve maximum ölçek faktörleri - daha yüksek minimum
  static const double _minScale = 0.8;
  static const double _maxScale = 1.4;

  final double screenWidth;
  final double screenHeight;

  // Cache'lenmiş ölçek faktörleri
  late final double _widthScale;
  late final double _heightScale;
  late final double _scale; // Ortalama ölçek
  late final double _fontScale; // Font için özel ölçek

  WebResponsive._({required this.screenWidth, required this.screenHeight}) {
    _widthScale = (screenWidth / _designWidth).clamp(_minScale, _maxScale);
    _heightScale = (screenHeight / _designHeight).clamp(_minScale, _maxScale);
    _scale = (_widthScale + _heightScale) / 2;
    // Font için daha yüksek minimum değer
    _fontScale = _widthScale.clamp(0.9, 1.25);
  }

  /// Context'ten WebResponsive instance oluşturur
  /// MediaQuery sadece bir kez çağrılır ve değerler cache'lenir
  static WebResponsive of(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return WebResponsive._(
      screenWidth: mediaQuery.size.width,
      screenHeight: mediaQuery.size.height,
    );
  }

  /// Genişlik bazlı ölçekleme
  /// 1920px referans genişliğine göre ölçekler
  double w(double size) => size * _widthScale;

  /// Yükseklik bazlı ölçekleme
  /// 1080px referans yüksekliğine göre ölçekler
  double h(double size) => size * _heightScale;

  /// Orantılı ölçekleme (genişlik ve yükseklik ortalaması)
  /// Kare elementler için ideal
  double s(double size) => size * _scale;

  /// Font boyutu ölçekleme
  /// Daha muhafazakar ölçekleme ile okunabilirliği korur
  double sp(double size) => size * _fontScale;

  /// Radius ölçekleme (orantılı)
  double r(double radius) => radius * _scale;

  /// EdgeInsets oluşturma - tüm yönler
  EdgeInsets padding(double value) => EdgeInsets.all(s(value));

  /// EdgeInsets oluşturma - symmetric
  EdgeInsets paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(
      horizontal: w(horizontal),
      vertical: h(vertical),
    );
  }

  /// EdgeInsets oluşturma - only
  EdgeInsets paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: w(left),
      top: h(top),
      right: w(right),
      bottom: h(bottom),
    );
  }

  /// SizedBox genişlik
  SizedBox horizontalSpace(double width) => SizedBox(width: w(width));

  /// SizedBox yükseklik
  SizedBox verticalSpace(double height) => SizedBox(height: h(height));

  /// Border radius
  BorderRadius borderRadius(double radius) => BorderRadius.circular(r(radius));

  /// Ekran boyutu kontrolleri
  bool get isSmallScreen => screenWidth < 1280;
  bool get isMediumScreen => screenWidth >= 1280 && screenWidth < 1600;
  bool get isLargeScreen => screenWidth >= 1600;

  /// Breakpoint bazlı değer seçimi
  T responsive<T>({required T small, T? medium, T? large}) {
    if (isLargeScreen && large != null) return large;
    if (isMediumScreen && medium != null) return medium;
    return small;
  }

  /// Ölçek faktörlerini al (debug için)
  double get widthScale => _widthScale;
  double get heightScale => _heightScale;
  double get scale => _scale;
}

/// BuildContext extension - daha kolay kullanım için
extension WebResponsiveExtension on BuildContext {
  /// WebResponsive instance'ını hızlıca al
  WebResponsive get responsive => WebResponsive.of(this);

  /// Kısa erişim metodları
  double wScale(double size) => WebResponsive.of(this).w(size);
  double hScale(double size) => WebResponsive.of(this).h(size);
  double sScale(double size) => WebResponsive.of(this).s(size);
  double spScale(double size) => WebResponsive.of(this).sp(size);
}

/// Pre-calculated dimensions for common use cases
/// Widget'larda static olarak kullanılabilir
class WebDimensions {
  WebDimensions._();

  // AppBar
  static const double appBarHeight = 70;
  static const double appBarPadding = 50;
  static const double logoHeight = 36;

  // Content rows
  static const double rowTitleSize = 22;
  static const double rowPadding = 50;
  static const double rowSpacing = 45;
  static const double cardSpacing = 12;

  // Content cards
  static const double cardHeight = 150;
  static const double top10RowHeight = 220;
  static const double cardBorderRadius = 6;

  // Hero section
  static const double heroHeightPercent = 0.85;
  static const double heroTitleSize = 56;
  static const double heroDescriptionSize = 20;
  static const double heroBottomOffset = 140;
  static const double heroContentWidthPercent = 0.42;

  // Hover preview
  static const double previewWidth = 340;
  static const double previewPadding = 14;
  static const double previewButtonSize = 38;
  static const double previewIconSize = 22;

  // Buttons
  static const double buttonPaddingH = 28;
  static const double buttonPaddingV = 14;
  static const double buttonIconSize = 26;
  static const double buttonFontSize = 18;

  // Hero Buttons (Specific)
  static const double heroButtonPaddingH = 40;
  static const double heroButtonPaddingV = 18;
  static const double heroButtonIconSize = 32;
  static const double heroButtonFontSize = 24;

  // Nav
  static const double navLinkPadding = 12;
  static const double navLinkFontSize = 15;
  static const double navIconSpacing = 18;
  static const double profileIconSize = 34;
}
