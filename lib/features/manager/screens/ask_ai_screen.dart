import 'package:flutter/material.dart';
import 'package:visit_tracker_app/features/manager/models/chat_message_model.dart';
import 'package:visit_tracker_app/features/manager/widgets/ai_chart_response_widget.dart';
import 'package:visit_tracker_app/shared/widgets/loading_indicator.dart';

class AskAiScreen extends StatefulWidget {
  const AskAiScreen({super.key});

  @override
  State<AskAiScreen> createState() => _AskAiScreenState();
}

class _AskAiScreenState extends State<AskAiScreen> {
  final _controller = TextEditingController();
  final List<ChatMessageModel> _messages = [
    ChatMessageModel(
      id: 'init1',
      text: "Hello! Try asking me to 'Compare sales of Anuj and Chetan'.",
      type: ChatMessageType.ai,
    ),
  ];
  bool _isLoading = false;

  void _sendMessage() {
    final text = _controller.text;
    if (text.isEmpty) return;

    setState(() {
      _messages.insert(0, ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        type: ChatMessageType.user,
      ));
      _isLoading = true;
    });

    _controller.clear();

    // In a real app, you would use a more sophisticated method to get the names.
    // For this demo, we'll just hardcode them based on the user's prompt.
    if (text.toLowerCase().contains('compare')) {
      _showChartResponse("Anuj", "Chetan");
    } else {
      _showTextResponse();
    }
  }

  void _showTextResponse() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _isLoading = false;
        _messages.insert(0, ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: "I'm sorry, I can only provide comparisons for now. Try asking me to 'Compare sales of Anuj and Chetan'.",
          type: ChatMessageType.ai,
        ));
      });
    });
  }

  // --- FIX 1 & 2: This function now accepts the names ---
  void _showChartResponse(String person1, String person2) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        _isLoading = false;
        _messages.insert(0, ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: "Here is the sales comparison you requested for $person1 and $person2:",
          type: ChatMessageType.ai,
          // --- And passes them to the widget ---
          customContent: AiChartResponseWidget(
            salesperson1: person1,
            salesperson2: person2,
          ),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask AI'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildChatBubble(message);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: LoadingIndicator(),
            ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessageModel message) {
    final isUser = message.type == ChatMessageType.user;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) const CircleAvatar(child: Icon(Icons.smart_toy)),
          if (!isUser) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isUser ? Colors.indigo[400] : Colors.grey[700],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: const TextStyle(color: Colors.white),
                  ),
                  if (message.customContent != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: message.customContent!,
                    ),
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser) const CircleAvatar(child: Icon(Icons.person)),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            // --- FIX 3: Replaced deprecated withOpacity ---
            color: Colors.black12, // More efficient than withOpacity(0.1)
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Ask AI about sales performance...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}