import 'dart:developer';

import 'package:bloc_examples/chat/data/chat_services.dart';
import 'package:bloc_examples/chat/models/message_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatServices chatServices = ChatServices();
  io.Socket? _socket;

  ChatBloc() : super(const ChatState()) {
    on<ChatInitialized>(_onChatInitialized);
    on<ChatHistoryRequested>(_onChatHistoryRequested);
    on<ChatMessageReceived>(_onChatMessageReceived);
    on<ChatMessageSent>(_onChatMessageSent);
    on<ChatSocketConnectionChanged>(_onSocketConnectionChanged);
  }

  void _onChatInitialized(ChatInitialized event, Emitter<ChatState> emit) {
    _socket = io.io('http://localhost:5555', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': ""},
    });

    _socket?.connect();

    _socket?.on('connect', (_) {
      log('\nSocket connected');
      add(const ChatSocketConnectionChanged(true));
    });

    _socket?.on('disconnect', (_) {
      log('\nSocket disconnected');
      add(const ChatSocketConnectionChanged(false));
    });

    _socket?.on('message', (data) {
      log("\nsocket data $data");
      if (data != null && data.toString().isNotEmpty) {
        add(ChatMessageReceived(Message.fromJson(data)));
      }
    });
  }

  void _onChatMessageReceived(
    ChatMessageReceived event,
    Emitter<ChatState> emit,
  ) {
    final updatedList = List<Message>.from(state.chatList)..add(event.message);
    emit(state.copyWith(chatList: updatedList));
  }

  void _onChatMessageSent(ChatMessageSent event, Emitter<ChatState> emit) {
    try {
      Message message = Message(text: event.text, id: '', isMe: true);
      _socket?.emit("message", message.toJson());

      log("\nmessage sent");

      final updatedList = List<Message>.from(state.chatList)..add(message);
      emit(state.copyWith(chatList: updatedList));
    } catch (e) {
      log("error sending the message $e");
    }
  }

  Future<void> _onChatHistoryRequested(
    ChatHistoryRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.loading));
    try {
      final value = await chatServices.getChatHistory();
      if (value != null && value['content'] != null) {
        final List? products = value['content'];
        final history =
            products?.map((e) => Message.fromJson(e)).toList() ?? [];

        emit(state.copyWith(status: ChatStatus.success, chatList: history));
      } else {
        emit(state.copyWith(status: ChatStatus.success));
      }
    } catch (e) {
      log("Error getting chat history $e");
      emit(state.copyWith(status: ChatStatus.failure));
    }
  }

  void _onSocketConnectionChanged(
    ChatSocketConnectionChanged event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(isSocketConnected: event.isConnected));
  }

  @override
  Future<void> close() {
    _socket?.dispose();
    return super.close();
  }
}
