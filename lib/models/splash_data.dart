import 'package:flutter/material.dart';

class SplashData {
  final String title;
  final String subtitle;
  final String description;
  final List<String> features;
  final IconData icon;
  final String backgroundImage;

  SplashData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.features,
    required this.icon,
    required this.backgroundImage,
  });
}
