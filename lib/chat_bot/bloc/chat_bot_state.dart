import 'dart:io';

import 'package:bloc_examples/chat_bot/models/chat_model.dart';
import 'package:equatable/equatable.dart';

class ChatBotState extends Equatable {
  final List<ChatMessage> messages;
  final File? selectedImage;
  final bool isLoading;

  const ChatBotState({
    this.messages = const [],
    this.selectedImage,
    this.isLoading = false,
  });

  ChatBotState copyWith({
    List<ChatMessage>? messages,
    File? selectedImage,
    bool? isLoading,
    bool clearImage = false,
  }) {
    return ChatBotState(
      messages: messages ?? this.messages,
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [messages, selectedImage, isLoading];
}
