import 'dart:math';
import 'package:flutter/material.dart';

class AvatarUtils {
  // Generate a consistent color based on name
  static Color getAvatarColor(String name) {
    if (name.isEmpty) return Colors.blueGrey;
    
    // List of pleasing avatar colors
    final colors = [
      const Color(0xFF6750A4), // Purple
      const Color(0xFF16A34A), // Green
      const Color(0xFFEF4444), // Red
      const Color(0xFF3B82F6), // Blue
      const Color(0xFFF59E0B), // Amber
      const Color(0xFF8B5CF6), // Violet
      const Color(0xFFEC4899), // Pink
      const Color(0xFF0D9488), // Teal
      const Color(0xFF4F46E5), // Indigo
      const Color(0xFFF97316), // Orange
    ];
    
    // Use hash of the name for consistent color selection
    final hashCode = name.hashCode.abs();
    return colors[hashCode % colors.length];
  }

  // Get initial(s) from name
  static String getInitials(String name) {
    if (name.isEmpty) return '?';
    
    // Split the name by spaces and take the first letter of each part
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      // If we have first and last name, use both initials
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else {
      // Otherwise use the first letter only
      return name[0].toUpperCase();
    }
  }

  // Generate a widget that displays a customized avatar with initials
  static Widget getAvatar({
    required String name,
    double radius = 24,
    Color? backgroundColor,
    Color? textColor,
    String? heroTag,
  }) {
    final bgColor = backgroundColor ?? getAvatarColor(name);
    final txtColor = textColor ?? Colors.white;
    final initials = getInitials(name);
    
    Widget avatar = CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      child: Text(
        initials,
        style: TextStyle(
          color: txtColor,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.7, // Scale font size with radius
        ),
      ),
    );
    
    // Wrap in Hero animation if a tag is provided
    if (heroTag != null) {
      return Hero(
        tag: heroTag,
        child: avatar,
      );
    }
    
    return avatar;
  }
}
