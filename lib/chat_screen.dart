import 'dart:async';
import 'dart:convert';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> chatMessages = [];
  final textController = TextEditingController();

  ChatGPT? chatGPT;
  StreamSubscription? streamSubscription;

  void sendMessage() {
    ChatMessage message = ChatMessage(
      text: textController.text,
      sender: "User",
    );
    setState(() {
      chatMessages.insert(0, message);
    });
    textController.clear();
    print("generating response");
    generateText(message);
    print("response generated");
  }

  void generateText(ChatMessage message) async {
    //     try {
    //       var url = await Uri.http(
    //           "https://api.openai.com/v1/engines/text-davinci/jobs");
    //       final response = await http.post(
    //         url,
    //         headers: {
    //           "Authorization":
    //               "Bearer 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",
    //           "Content-Type": "application/json",
    //         },
    //         body: json.encode({
    //           "prompt": prompt,
    //           "max_tokens": 100,
    //           "temperature": 0.5,
    //         }),
    //       );

    //       if (response.statusCode == 200) {
    //         ChatMessage bot = ChatMessage(
    //             text: json.decode(response.body)["choices"][0]["text"],
    //             sender: "Bot");
    //         setState(() {
    //           chatMessages.insert(0, bot);
    //         });
    //         // return json.decode(response.body)["choices"][0]["text"];
    //       } else {
    //         print("Something is wrong");
    //       }
    //     } catch (e) {
    //       print(e);
    //     }
    //   }
    // }

    final request = CompleteReq(
        prompt: message.text, model: kTranslateModelV3, max_tokens: 2000);
    streamSubscription = chatGPT!
        .builder("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")
        .onCompleteStream(request: request)
        .listen((event) {
      ChatMessage bot =
          ChatMessage(text: event!.choices[0].text, sender: "bot");
      setState(() {
        chatMessages.insert(0, bot);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    chatGPT = ChatGPT.instance;
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription?.cancel();
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: textController,
            onSubmitted: (value) => sendMessage(),
            decoration: const InputDecoration.collapsed(
                hintText: "Write your query..."),
          )),
          IconButton(
              onPressed: () => sendMessage(), icon: const Icon(Icons.send))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      return chatMessages[index];
                    })),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextComposer(),
            )
          ],
        ),
      ),
    );
  }
}
