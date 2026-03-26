import 'package:bloc_examples/chat/models/message_model.dart';
import 'package:equatable/equatable.dart';

enum ChatStatus { initial, loading, success, failure }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<Message> chatList;
  final bool isSocketConnected;

  const ChatState({
    this.status = ChatStatus.initial,
    this.chatList = const [],
    this.isSocketConnected = false,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<Message>? chatList,
    bool? isSocketConnected,
  }) {
    return ChatState(
      status: status ?? this.status,
      chatList: chatList ?? this.chatList,
      isSocketConnected: isSocketConnected ?? this.isSocketConnected,
    );
  }

  @override
  List<Object?> get props => [status, chatList, isSocketConnected];
}
