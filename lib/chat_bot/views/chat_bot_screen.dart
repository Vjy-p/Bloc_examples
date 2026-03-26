import 'package:bloc_examples/chat_bot/bloc/chat_bot_bloc.dart';
import 'package:bloc_examples/chat_bot/bloc/chat_bot_event.dart';
import 'package:bloc_examples/chat_bot/bloc/chat_bot_state.dart';
import 'package:bloc_examples/chat_bot/models/chat_model.dart';
import 'package:bloc_examples/utils/colors.dart';
import 'package:bloc_examples/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class ChatBotScreen extends StatelessWidget {
  ChatBotScreen({super.key});
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBotBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: customText(
            text: "Chat Bot",
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatBotBloc, ChatBotState>(
                  builder: (context, state) {
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final msg = state.messages[index];
                        final isUser = msg.role == ChatRole.user;
                        return Container(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: isUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (msg.image != null)
                                Image.file(msg.image!, width: 150),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? Colors.blue[100]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: MarkdownBody(data: msg.text),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Image Preview & Loading Indicator
              BlocBuilder<ChatBotBloc, ChatBotState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      if (state.isLoading) const LinearProgressIndicator(),
                      if (state.selectedImage != null)
                        Image.file(state.selectedImage!, height: 100),
                    ],
                  );
                },
              ),

              // Input Area
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kWhiteColor),
                  color: kWhiteColor,
                ),
                margin: EdgeInsets.symmetric(horizontal: 12),
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    // IconButton(
                    //   icon: const Icon(Icons.image),
                    //   onPressed: () =>
                    //       context.read<ChatBotBloc>().add(PickImageEvent()),
                    // ),
                    Expanded(
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          enabled: true,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    BlocBuilder<ChatBotBloc, ChatBotState>(
                      builder: (context, state) {
                        return IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  context.read<ChatBotBloc>().add(
                                    SendMessageEvent(
                                      textController.text,
                                      state.selectedImage,
                                    ),
                                  );
                                  textController.clear();
                                },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
