import 'package:flutter/material.dart';

class Tenantprofilescreen extends StatefulWidget {
  const Tenantprofilescreen({super.key});

  @override
  State<Tenantprofilescreen> createState() => _TenantprofilescreenState();
}

class _TenantprofilescreenState extends State<Tenantprofilescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(
                  'https://static1.srcdn.com/wordpress/wp-content/uploads/2021/12/One-Piece-Sales-Luffy.jpg',
                ),
              ),
            ],
          ),

          // ListView(
          //   children: [
          //     ListTile(
          //       onTap: () {
          //         Navigator.pushNamed(context, '/tenantpreference');
          //       },
          //       leading: Icon(Icons.person),
          //       title: Text("User Preference"),
          //       subtitle: Text("Change your profile details"),
          //       trailing: Icon(Icons.arrow_forward_ios),
          //     ),
          //   ],
          // ),
          ListTile(
            leading: Icon(
                Icons.person), // An optional widget to display before the title
            title: Text('User Preference'), // The main text
            subtitle: Text(
                'Change your preferences'), // Additional text displayed below the title
            trailing: Icon(Icons
                .arrow_forward), // An optional widget to display after the title
            onTap: () {
              Navigator.pushNamed(context, '/tenantpreference');
            },
          ),
        ],
      ),
    );
  }
}
