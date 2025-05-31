# Flutter Chat App Development Task List

## 1. Project Setup
- [x] Initialize a new Flutter project.
  ```bash
  flutter create chat_app
  cd chat_app
  ```
- [x] Add necessary dependencies to `pubspec.yaml` (e.g., `flutter_bloc`, `equatable`, `intl` for date formatting).
  ```yaml
  dependencies:
    flutter:
      sdk: flutter
    flutter_bloc: ^8.0.0 # Check for latest version
    equatable: ^2.0.0 # Check for latest version
    intl: ^0.19.0 # Check for latest version
  ```
- [x] Run `flutter pub get`.

## 2. Data Models
- [x] Create `lib/models/conversation_model.dart`:
  ```dart
  // Prompt: Create a Dart class Conversation with fields: id (String), contactName (String), lastMessage (String), timestamp (DateTime), and optionally avatarUrl (String) and unreadCount (int). Use Equatable for value comparison.
  ```
- [x] Create `lib/models/message_model.dart`:
  ```dart
  // Prompt: Create a Dart class Message with fields: id (String), conversationId (String), content (String), isMe (bool), and timestamp (DateTime). Use Equatable for value comparison.
  ```

## 3. BLoC Setup for Conversations
- [x] **Events**: Create `lib/bloc/conversation/conversation_event.dart`:
  ```dart
  // Prompt: Define abstract class ConversationEvent extends Equatable.
  // Create concrete event classes:
  // - LoadConversations extends ConversationEvent (triggered to load all conversations)
  // - SendMessage extends ConversationEvent (with a Message object payload, or necessary fields like conversationId, text)
  // - MarkConversationAsRead extends ConversationEvent (with conversationId)
  // (Note: ReceiveMessage might be handled differently, e.g. by an update from a repository/service, or another event like ConversationUpdated)
  ```
- [x] **States**: Create `lib/bloc/conversation/conversation_state.dart`:
  ```dart
  // Prompt: Define abstract class ConversationState extends Equatable.
  // Create concrete state classes:
  // - ConversationInitial extends ConversationState
  // - ConversationLoading extends ConversationState
  // - ConversationLoaded extends ConversationState (with a list of Conversation objects and a list of Message objects for the active conversation)
  // - ConversationError extends ConversationState (with an error message)
  ```
- [x] **BLoC**: Create `lib/bloc/conversation/conversation_bloc.dart`:
  ```dart
  // Prompt: Implement ConversationBloc extends Bloc<ConversationEvent, ConversationState>.
  // - Initialize with ConversationInitial state.
  // - Handle LoadConversations: emit ConversationLoading, then load mock conversations and emit ConversationLoaded.
  // - Handle SendMessage: (Simulate sending) update the relevant conversation's lastMessage and timestamp, add the new message to a mock list, and emit ConversationLoaded with updated data.
  // - Handle MarkConversationAsRead: (Simulate) update the unread status for a conversation and emit ConversationLoaded.
  // - Use mock data for now.
  ```

## 4. Mock Data
- [x] Create `lib/data/mock_data.dart`:
  ```dart
  // Prompt: Create mock lists:
  // - mockConversations: List<Conversation> with at least 3-4 sample conversations. Include avatars (placeholder URLs or local assets) and unread message counts.
  // - mockMessages: Map<String, List<Message>> where keys are conversationIds, and values are lists of messages for that conversation. Ensure messages have varying isMe values and timestamps.
  ```

## 5. UI - Conversation List Screen
- [x] Create `lib/screens/conversation_list_screen.dart`.
  ```dart
  // Prompt: Design the ConversationListScreen widget.
  // - Use a BlocProvider to provide ConversationBloc.
  // - Use a BlocBuilder to react to ConversationState.
  // - Display a ListView of conversations from ConversationLoaded state.
  // - Each item should show: Avatar (CircleAvatar), contactName, lastMessage, timestamp (formatted).
  // - Implement a badge for unread messages (e.g., a small circle with a count).
  // - On item tap, navigate to ConversationDetailScreen, passing the conversationId or Conversation object.
  // - Add a FloatingActionButton to simulate creating a new conversation (can navigate to a new screen or show a dialog).
  // - Dispatch LoadConversations event in initState or via a button.
  ```
- [x] Implement navigation to `ConversationDetailScreen`.

## 6. UI - Conversation Detail Screen
- [x] Create `lib/screens/conversation_detail_screen.dart`.
  ```dart
  // Prompt: Design the ConversationDetailScreen widget.
  // - Accept conversationId or Conversation object as a parameter.
  // - Use BlocProvider (or access existing BLoC if scoped higher) for ConversationBloc.
  // - Use BlocBuilder to display messages for the selected conversation.
  // - Messages should be visually distinct for `isMe == true` (e.g., right-aligned, different color) and `isMe == false`.
  // - Include a TextField for message input and a Send button.
  // - On Send, dispatch SendMessage event with the new message content and conversationId.
  // - (Optional: When this screen is opened, dispatch an event like MarkConversationAsRead(conversationId) to update the unread count in ConversationListScreen).
  ```

## 7. Main Application Setup
- [x] Update `lib/main.dart`:
  ```dart
  // Prompt: Configure main.dart.
  // - Set up BlocProvider for ConversationBloc at the root if needed, or within specific routes.
  // - Define routes for ConversationListScreen and ConversationDetailScreen.
  // - Set ConversationListScreen as the home screen.
  ```

## 8. Refinements & Testing
- [ ] Test navigation between screens.
- [ ] Test sending messages and updating the UI.
- [ ] Test loading conversations.
- [ ] Ensure BLoC states and events are handled correctly.
- [ ] Format dates and times appropriately (e.g., using the `intl` package).
- [ ] Add basic error handling and display (e.g., for ConversationError state).

## 9. Documentation (Compte Rendu - NomPrénom.pdf)
- [ ] Explain the BLoC architecture used:
    - Detail the states (`ConversationInitial`, `ConversationLoading`, `ConversationLoaded`, `ConversationError`).
    - Detail the events (`LoadConversations`, `SendMessage`, `ReceiveMessage` - clarify how `ReceiveMessage` is handled, e.g., as part of `SendMessage` simulation or a separate update mechanism).
- [ ] Describe navigation flow between `ConversationListScreen` and `ConversationDetailScreen`.
- [ ] List all implemented features as per `exam.md`.
- [ ] Prepare the PDF document.


---
**Prompts for each step are embedded as comments within the Dart code blocks.**
Use these prompts with an AI assistant to generate the initial code for each file.
Remember to adapt and refine the generated code to fit the project's specific needs and best practices.
