import 'package:flutter/material.dart';

class C_Sms_EtudiantSection extends StatelessWidget {
  final String sender;
  final bool isAdministrator;
  C_Sms_EtudiantSection({required this.sender, required this.isAdministrator});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Communication avec $sender',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1869a6),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildMessageBubble(
                  sender: 'Moi',
                  content: 'Bonjour, comment ça va?',
                  isSender: true,
                  avatar: 'assets/images/avatar.png',
                ),
                _buildMessageBubble(
                  sender: sender,
                  content: 'Bonjour, ça va bien. Et vous?',
                  isSender: false,
                  avatar: 'assets/images/avatar.png',
                ),
                _buildMessageBubble(
                  sender: 'Moi',
                  content: 'Je vais bien, merci!',
                  isSender: true,
                  avatar: 'assets/images/avatar.png',
                ),
                _buildMessageBubble(
                  sender: sender,
                  content: 'C\'est super à entendre!',
                  isSender: false,
                  avatar: 'assets/images/avatar.png',
                ),
              ],
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required String sender,
    required String content,
    required bool isSender,
    required String avatar,
  }) {
    return Row(
      mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSender)
          CircleAvatar(
            radius: 20.0,
            backgroundImage: AssetImage(avatar),
          ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isSender ? Colors.blue[100] : Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                sender,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSender ? Colors.blue : Colors.black,
                ),
              ),
              SizedBox(height: 4.0),
              Text(content),
            ],
          ),
        ),
        if (isSender)
          CircleAvatar(
            radius: 20.0,
            backgroundImage: AssetImage(avatar),
          ),
      ],
    );
  }

  Widget _buildMessageInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Écrire un message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // Implement message sending functionality here
            },
          ),
        ],
      ),
    );
  }
}

