import 'package:flutter/material.dart';

class AppTextStyles {
  // Usando fontes do sistema para evitar problemas de conexão
  static const String _fontFamily = 'SF Pro Display'; // iOS/macOS
  static const String _fontFamilyFallback = 'Segoe UI'; // Windows
  
  // Título grande
  static TextStyle headline1({Color? color}) => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: color,
    fontFamily: _fontFamily,
    fontFamilyFallback: const [_fontFamilyFallback, 'Roboto'],
  );
  
  // Título médio
  static TextStyle headline2({Color? color}) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: color,
    fontFamily: _fontFamily,
    fontFamilyFallback: const [_fontFamilyFallback, 'Roboto'],
  );
  
  // Título pequeno
  static TextStyle headline3({Color? color}) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: color,
    fontFamily: _fontFamily,
    fontFamilyFallback: const [_fontFamilyFallback, 'Roboto'],
  );
  
  // Subtítulo
  static TextStyle subtitle1({Color? color}) => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: color,
    fontFamily: _fontFamily,
    fontFamilyFallback: const [_fontFamilyFallback, 'Roboto'],
  );
  
  // Subtítulo pequeno
  static TextStyle subtitle2({Color? color}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: color,
    fontFamily: _fontFamily,
    fontFamilyFallback: const [_fontFamilyFallback, 'Roboto'],
  );
  
  // Corpo do texto
  static TextStyle body1({Color? color}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: color,
    fontFamily: _fontFamily,
    fontFamilyFallback: const [_fontFamilyFallback, 'Roboto'],
  );
  
  // Corpo do texto pequeno
  static TextStyle body2({Color? color}) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color,
    fontFamily: _fontFamily,
    fontFamilyFallback: const [_fontFamilyFallback, 'Roboto'],
  );
  
  // Caption
  static TextStyle caption({Color? color}) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color,
    fontFamily: _fontFamily,
    fontFamilyFallback: const [_fontFamilyFallback, 'Roboto'],
  );
  
  // Button
  static TextStyle button({Color? color}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: color,
    fontFamily: _fontFamily,
    fontFamilyFallback: const [_fontFamilyFallback, 'Roboto'],
  );
}
