import 'package:bloc_examples/chat/models/message_model.dart';
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatInitialized extends ChatEvent {}

class ChatHistoryRequested extends ChatEvent {}

class ChatMessageReceived extends ChatEvent {
  final Message message;

  const ChatMessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatMessageSent extends ChatEvent {
  final String text;

  const ChatMessageSent(this.text);

  @override
  List<Object?> get props => [text];
}

class ChatSocketConnectionChanged extends ChatEvent {
  final bool isConnected;

  const ChatSocketConnectionChanged(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}
