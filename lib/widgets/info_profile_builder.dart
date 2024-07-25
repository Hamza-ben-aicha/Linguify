import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildProfileInfo(String title, String content, String fieldKey, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          content,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        // trailing: IconButton(
        //   icon: Icon(Icons.edit, color: Colors.white70),
        //   onPressed: () {
        //     _showEditDialog(title, fieldKey);
        //   },
        // ),
      ),
      Divider(color: Colors.white24),
    ],
  );
}