import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/services/ChatService.dart';
import 'package:gharsathi/services/authentication.dart';
import 'package:gharsathi/widgets/ChatBubble.dart';
import 'package:gharsathi/widgets/MessageTextField.dart';

class Chatscreen extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;

  Chatscreen({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat and auth services
  final Chatservice _chatservice = Chatservice();
  final Authentication _authentication = Authentication();

  // Send message
  void sendMessage() async {
    // Only send the message if the text field is not empty
    if (_messageController.text.isNotEmpty) {
      await _chatservice.sendMessage(receiverID, _messageController.text);

      // Clear text controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _builderUserInput(),
        ],
      ),
    );
  }

// build message List
  Widget _buildMessageList() {
    String senderID = _authentication.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatservice.getMessages(receiverID, senderID),
        builder: (context, snapshot) {
          //erros
          if (snapshot.hasError) {
            return const Text("Error");
          }

          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }
          //return list view
          return ListView(
            children: snapshot.data!.docs
                .map((doc) => _buildMessageitem(doc))
                .toList(),
          );
        });
  }

  //build message item
  Widget _buildMessageitem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser =
        data['senderID'] == _authentication.getCurrentUser()!.uid;

    //align messesage to right
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Chatbubble(message: data["message"], isCurrentUser: isCurrentUser)
          ],
        ));
  }

  //build message input
  Widget _builderUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(
              child: Messagetextfield(
                  hintText: "Type a message",
                  obscureText: false,
                  controller: _messageController)),

          //send button
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_upward),
          )
        ],
      ),
    );
  }
}
