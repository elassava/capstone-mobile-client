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
  // Design referans boyutları (Full HD)
  static const double _designWidth = 1920.0;
  static const double _designHeight = 1080.0;
  
  // Minimum ve maximum ölçek faktörleri
  static const double _minScale = 0.5;
  static const double _maxScale = 1.5;
  
  final double screenWidth;
  final double screenHeight;
  
  // Cache'lenmiş ölçek faktörleri
  late final double _widthScale;
  late final double _heightScale;
  late final double _scale; // Ortalama ölçek
  late final double _fontScale; // Font için özel ölçek
  
  WebResponsive._({
    required this.screenWidth,
    required this.screenHeight,
  }) {
    _widthScale = (screenWidth / _designWidth).clamp(_minScale, _maxScale);
    _heightScale = (screenHeight / _designHeight).clamp(_minScale, _maxScale);
    _scale = (_widthScale + _heightScale) / 2;
    // Font için daha muhafazakar ölçekleme
    _fontScale = _widthScale.clamp(0.7, 1.2);
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
  T responsive<T>({
    required T small,
    T? medium,
    T? large,
  }) {
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
  static const double appBarHeight = 80;
  static const double appBarPadding = 60;
  static const double logoHeight = 40;
  
  // Content rows
  static const double rowTitleSize = 20;
  static const double rowPadding = 60;
  static const double rowSpacing = 40;
  static const double cardSpacing = 10;
  
  // Content cards
  static const double cardHeight = 130;
  static const double top10RowHeight = 200;
  static const double cardBorderRadius = 4;
  
  // Hero section
  static const double heroHeightPercent = 0.85;
  static const double heroTitleSize = 60;
  static const double heroDescriptionSize = 18;
  static const double heroBottomOffset = 150;
  static const double heroContentWidthPercent = 0.4;
  
  // Hover preview
  static const double previewWidth = 350;
  static const double previewPadding = 12;
  static const double previewButtonSize = 36;
  static const double previewIconSize = 20;
  
  // Buttons
  static const double buttonPaddingH = 30;
  static const double buttonPaddingV = 12;
  static const double buttonIconSize = 28;
  static const double buttonFontSize = 18;
  
  // Nav
  static const double navLinkPadding = 10;
  static const double navLinkFontSize = 14;
  static const double navIconSpacing = 20;
  static const double profileIconSize = 32;
}

