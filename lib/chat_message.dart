import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text, sender;
  const ChatMessage({super.key, required this.text, required this.sender});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 16.0, top: 12),
          child: CircleAvatar(
            child: Text(sender[0]),
          ),
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text),
            )
          ],
        ))
      ],
    );
  }
}
