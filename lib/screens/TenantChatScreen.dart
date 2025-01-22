import 'package:flutter/material.dart';
import 'package:gharsathi/global_variables.dart';
import 'package:gharsathi/screens/ChatScreen.dart';
import 'package:gharsathi/services/ChatService.dart';
import 'package:gharsathi/services/authentication.dart';
import 'package:gharsathi/widgets/UserTile.dart';

class Tenantchatscreen extends StatelessWidget {
  Tenantchatscreen({super.key});

  //chat and auth services
  final Chatservice _chatservice = Chatservice();
  final Authentication _authentication = Authentication();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Chat room"),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatservice.getUsersStream(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Text("Error");
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }
        //return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

// Build individual list tile for user, only if they are landlords
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    final currentUserEmail = _authentication.getCurrentUser()?.email;

    // Display only landlords, and exclude the current user
    if (userData["usertype"] == "Landlord" &&
        userData["email"] != currentUserEmail) {
      final fullName = "${userData["firstName"]} ${userData["lastName"]}";

      return Usertile(
        text: fullName,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Chatscreen(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
                receiverName: fullName,
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
