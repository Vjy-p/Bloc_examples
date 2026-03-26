import 'dart:developer';
import 'dart:io';

import 'package:bloc_examples/chat_bot/bloc/chat_bot_event.dart';
import 'package:bloc_examples/chat_bot/bloc/chat_bot_state.dart';
import 'package:bloc_examples/chat_bot/models/chat_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  ChatBotBloc() : super(const ChatBotState()) {
    // Initialize Gemini
    const String geminiApiKey = String.fromEnvironment('AI_KEY');
    // log("AI Key $geminiApiKey");
    _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: geminiApiKey);
    _chatSession = _model.startChat();

    on<PickImageEvent>(_onPickImage);
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onPickImage(
    PickImageEvent event,
    Emitter<ChatBotState> emit,
  ) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      emit(state.copyWith(selectedImage: File(image.path)));
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatBotState> emit,
  ) async {
    if (event.text.isEmpty && event.image == null) return;

    // 1. Add user message to UI immediately
    final userMsg = ChatMessage(
      text: event.text,
      image: event.image,
      role: ChatRole.user,
    );
    final updatedMessages = List<ChatMessage>.from(state.messages)
      ..add(userMsg);

    emit(
      state.copyWith(
        messages: updatedMessages,
        isLoading: true,
        clearImage: true, // Reset image preview after sending
      ),
    );

    try {
      Stream<GenerateContentResponse> responseStream;
      // String? responseText;

      if (event.image != null) {
        // Multi-modal request (Image + Text)
        final bytes = await event.image!.readAsBytes();
        final content = [
          Content.multi([TextPart(event.text), DataPart('image/jpeg', bytes)]),
        ];
        // final response = await _model.generateContent(content);
        // responseText = response.text;

        responseStream = _model.generateContentStream(content);
      } else {
        // Text-only request (uses session history)
        // final response = await _chatSession.sendMessage(
        //   Content.text(event.text),
        // );
        // log(
        //   "response ${response.text} ${response.candidates} $response ${response.usageMetadata}",
        // );
        // responseText = response.text;

        responseStream = _chatSession.sendMessageStream(
          Content.text(event.text),
        );
      }

      // final botMsg = ChatMessage(
      //   text: responseText ?? "No response",
      //   role: ChatRole.model,
      // );
      // emit(
      //   state.copyWith(
      //     messages: List.from(state.messages)..add(botMsg),
      //     isLoading: false,
      //   ),
      // );

      String fullText = "";
      await for (final chunk in responseStream) {
        final chunkText = chunk.text ?? "";
        fullText += chunkText;
        final currentMessages = List<ChatMessage>.from(state.messages);
        log("count11 ${currentMessages.length}");
        if (currentMessages.isNotEmpty) {
          if (currentMessages.last.role == ChatRole.model) {
            currentMessages.last = ChatMessage(
              text: fullText,
              role: ChatRole.model,
            );
          } else {
            currentMessages.add(
              ChatMessage(text: fullText, role: ChatRole.model),
            );
          }

          emit(state.copyWith(messages: currentMessages, isLoading: true));
        }
      }
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      log("Error sending the message $e");
      emit(state.copyWith(isLoading: false));
    }
  }
}
