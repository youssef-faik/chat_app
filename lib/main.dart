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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ConversationListScreen(),
        // Define routes if you need named navigation for other screens
        // routes: {
        //   ConversationDetailScreen.routeName: (context) => const ConversationDetailScreen(conversationId: '', // This needs to be passed correctly
        // },
      ),
    );
  }
}
