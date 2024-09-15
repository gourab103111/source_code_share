import 'package:flutter/material.dart';

Widget buildMenu() {
  return const SingleChildScrollView(
    padding: EdgeInsets.symmetric(vertical: 50.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 22.0,
                ),
                SizedBox(height: 16.0),
                Text(
                  "Rahul Jograna",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
        ListTile(
            leading: Icon(Icons.home, size: 20.0, color: Colors.white),
            title: Text('Home'),
            textColor: Colors.white,
            dense: true),
        ListTile(
            leading: Icon(Icons.newspaper, size: 20.0, color: Colors.white),
            title: Text('History'),
            textColor: Colors.white,
            dense: true),
        ListTile(
            leading: Icon(Icons.account_circle_outlined,
                size: 20.0, color: Colors.white),
            title: Text('Profile'),
            textColor: Colors.white,
            dense: true),
        ListTile(
            leading: Icon(Icons.translate, size: 20.0, color: Colors.white),
            title: Text('Languages'),
            textColor: Colors.white,
            dense: true),
        ListTile(
            leading: Icon(Icons.attach_email_outlined,
                size: 20.0, color: Colors.white),
            title: Text('Contact us'),
            textColor: Colors.white,
            dense: true),
        ListTile(
            leading:
                Icon(Icons.wechat_outlined, size: 20.0, color: Colors.white),
            title: Text('Chats'),
            textColor: Colors.white,
            dense: true),
        ListTile(
            leading: Icon(Icons.account_balance_wallet_outlined,
                size: 20.0, color: Colors.white),
            title: Text('Wallet'),
            textColor: Colors.white,
            dense: true),
        ListTile(
            leading: Icon(Icons.card_giftcard, size: 20.0, color: Colors.white),
            title: Text('Refer & Earn'),
            textColor: Colors.white,
            dense: true),
        ListTile(
            leading: Icon(Icons.logout, size: 20.0, color: Colors.white),
            title: Text('Logout'),
            textColor: Colors.white,
            dense: true),
      ],
    ),
  );
}
