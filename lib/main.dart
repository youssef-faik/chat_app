import 'package:chat_app/bloc/conversation/conversation_bloc.dart';
import 'package:chat_app/screens/conversation_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConversationBloc(),
      child: MaterialApp(
        title: 'Flutter Chat App',
        debugShowCheckedModeBanner: false, // Remove debug banner
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6750A4), // Purple primary color
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 0,
            backgroundColor: Color(0xFFF6F5FA), // Light purple background
            foregroundColor: Color(0xFF1D1B20), // Dark text
            iconTheme: IconThemeData(color: Color(0xFF6750A4)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF6F5FA).withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6750A4)),
            ),
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6750A4),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 0,
            backgroundColor: Color(0xFF1D1B20), // Dark background
            foregroundColor: Color(0xFFE6E0E9), // Light text
            iconTheme: IconThemeData(color: Color(0xFFD0BCFF)), // Light purple icons
          ),
        ),
        themeMode: ThemeMode.system, // Follow system theme
        home: const ConversationListScreen(),
      ),
    );
  }
}
